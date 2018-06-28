%{
#include <stdio.h>
#include "symtab.h"
extern int yylex(void);
int yyerror(char *msg);
%}

%token	FORWARD TURN RIGHT LEFT COLOR RED GREEN BLUE BLACK RGB VAR

%token	PLUS MINUS STAR SLASH OPENPR CLOSEDPR IF THEN AND OR ELSE WHILE DO FOR WHILST

%token	<i> INTEGER <d> DOUBLE

%token	<n> ID

%token	CURVE SIZE

%token	COMMA SEMICOLON ASSIGN PROCEDURE

%token	LESS GREATER NOT STEP

%token	START END MOD

%union {int i; node *n; double d;}

//%define parse.error verbose

%%
program: header declist commandList trailer;
header: {printf("%%!PS\n\n");};
trailer: ;

declist: ;
declist: declist dec;
// fprintf(stderr,"LEVEL: %d, %d", $2->level, level);
dec: VAR ID SEMICOLON {if($2->defined == 1 && $2->level == level) yyerror("Multiple variable declaration!"); else {$2->defined = 1; printf("/tlt%s 0 def ", $2->name); insert($2->name)->defined = 1;}};

dec: PROCEDURE ID {scope_open(); printf("/tpt%s { 4 dict begin \n", $2->name);} OPENPR paramlist CLOSEDPR
	START declist commandList END {scope_close(); printf("end } def\n");};

paramlist: ;
paramlist: params;

params: ID {$1->defined = 1; printf("/tlt%s exch def\n", $1->name);};
params: ID COMMA params {$1->defined = 1; printf("/tlt%s exch def\n", $1->name);};

commandList: ;
commandList: commandList command;

forvarassign: ID ASSIGN expr {if($1->defined) printf("/tlt%s exch store\n", $1->name); else yyerror("Variable undefined");};

varassign: forvarassign SEMICOLON ;

command: varassign;

ifhead: IF bool THEN {printf("{\n");};
command: ifhead command ELSE {printf("}\n");} {printf("{\n");} command {printf("} ifelse\n");};
command: ifhead command {printf("} if\n");};

command: WHILE {printf("{\n");} bool {printf("{\n");} DO command {printf("}{exit}ifelse}loop\n");};

command: FOR forvarassign {printf("{\n");} WHILE bool {printf("{\n");} STEP forvarassign DO command {printf("}{exit}ifelse}loop\n");};

command: FOR varassign {printf("{\n");} bool SEMICOLON {printf("{\n");} varassign DO command {printf("}{exit}ifelse}loop\n");};

command: START {scope_open(); printf("4 dict begin ");} declist commandList END { scope_close(); printf("end ");};

command: ID OPENPR arglist CLOSEDPR SEMICOLON {printf("tpt%s\n",$1->name);};

arglist: ;
arglist: args;
args: expr;
args: args COMMA expr;

command: FORWARD SEMICOLON {printf("newpath 0 0 moveto 0 100 lineto currentpoint translate stroke\n");};
command: FORWARD expr SEMICOLON {printf("newpath 0 0 moveto 0 exch lineto currentpoint translate stroke\n");};

command: COLOR col SEMICOLON;

command: COLOR RGB OPENPR expr {printf("255 div ");} COMMA expr {printf("255 div ");} COMMA expr {printf("255 div ");} CLOSEDPR SEMICOLON{
	printf("setrgbcolor\n");
};

command: TURN LEFT SEMICOLON {printf("90 rotate\n");};
command: TURN RIGHT SEMICOLON{printf("270 rotate\n");};
command: TURN LEFT expr SEMICOLON {printf("rotate\n");};
command: TURN RIGHT expr SEMICOLON {printf("-1 mul rotate\n");};

command: {printf("0 0\n");} CURVE expr COMMA expr COMMA expr SEMICOLON {printf("newpath arc currentpoint translate stroke\n");};

command: SIZE expr SEMICOLON {printf("setlinewidth\n");};

bool: bool OR frel {printf("or ");};
bool: bool AND frel {printf("and ");};
bool: frel;

frel: NOT rel {printf("not ");};
frel: rel;

rel: expr LESS expr {printf("lt ");};
rel: expr GREATER expr {printf("gt ");};
rel: expr LESS ASSIGN expr {printf("le ");};
rel: expr GREATER ASSIGN expr {printf("ge ");};
rel: expr NOT ASSIGN expr {printf("ne ");};
rel: expr ASSIGN ASSIGN expr {printf("eq ");};
rel: OPENPR rel CLOSEDPR;

expr: prod;
expr: expr MOD prod {printf("mod ");};
expr: expr PLUS prod {printf("add ");};
expr: expr MINUS prod {printf("sub ");};

prod: factor;
prod: prod STAR factor {printf("mul ");};
prod: prod SLASH factor {printf("div ");};

factor: atomic;
factor: PLUS atomic;
factor: MINUS atomic {printf("neg ");};

atomic: ID {if($1->defined) printf("tlt%s ", $1->name); else yyerror("Variable undefined");};
atomic: INTEGER {printf("%d ", $1);};
atomic: DOUBLE {printf("%f ", $1);};
atomic: OPENPR expr CLOSEDPR;

col: RED{printf("1 0 0 setrgbcolor\n");};
col: GREEN{printf("0 1 0 setrgbcolor\n");};
col: BLUE{printf("0 0 1 setrgbcolor\n");};
col: BLACK{printf("0 0 0 setrgbcolor\n");};
%%

int yyerror(char *msg){
	fprintf(stderr,"ERROR: %s\n", msg);
	return 0;
}

int main(void){
	yyparse();
	return 0;
}
