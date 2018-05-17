%{
#include <stdio.h>
#include "symtab.h"
extern int yylex(void);
int yyerror(char *msg);
%}

%token	FORWARD TURN RIGHT LEFT COLOR RED GREEN BLUE BLACK RGB VAR

%token	PLUS MINUS STAR SLASH OPENPR CLOSEDPR

%token	<i> INTEGER <d> DOUBLE

%token	<n> ID

%token	CURVE SIZE

%token	COMMA SEMICOLON ASSIGN

%union {int i; node *n; double d;}

//%define parse.error verbose

%%
program: header declist commandList trailer;
header: {printf("%%!PS\n\n");};
trailer: ;

declist: ;
declist: declist dec;

dec: VAR ID SEMICOLON {$2->defined = 1;};

commandList: ;
commandList: commandList command;

command: ID ASSIGN expr SEMICOLON {if($1->defined) printf("/tlt%s exch def\n", $1->name);};

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

expr: prod;
expr: expr PLUS prod {printf("add ");};
expr: expr MINUS prod {printf("sub ");};

prod: factor;
prod: prod STAR factor {printf("mul ");};
prod: prod SLASH factor {printf("div ");};

factor: atomic;
factor: PLUS atomic;
factor: MINUS atomic {printf("neg ");};

atomic: ID {if($1->defined) printf("tlt%s ", $1->name);};
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
