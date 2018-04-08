%{
#include <stdio.h>
extern int yylex(void);
int yyerror(char *msg);
%}

%token	FORWARD		1
%token	TURN		2
%token	RIGHT		3
%token	LEFT		4
%token	COLOR		5
%token	RED		6
%token	GREEN		7
%token	BLUE		8
%token	BLACK		9
%token	SEMICOLON	10

%%
program: header command trailer;
header: {printf("%%!PS\n\n");};
trailer: ;

command: command command;
command: FORWARD SEMICOLON {printf("newpath 0 0 moveto 100 100 lineto currentpoint translate stroke\n");};
command: TURN dir SEMICOLON;
command: COLOR col SEMICOLON;

dir: LEFT {printf("90 rotate\n");};
dir: RIGHT{printf("270 rotate\n");};

col: RED{printf("255 0 0 setrgbcolor\n");};
col: GREEN{printf("0 255 0 setrgbcolor\n");};
col: BLUE{printf("0 0 255 setrgbcolor\n");};
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
