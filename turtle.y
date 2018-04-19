%{
#include <stdio.h>
extern int yylex(void);
int yyerror(char *msg);
%}

%token	FORWARD		
%token	TURN		
%token	RIGHT		
%token	LEFT		
%token	COLOR		
%token	RED		
%token	GREEN		
%token	BLUE		
%token	BLACK		
%token	INTEGER		

%token	RGB		
%token	OPENPR		
%token	CLOSEDPR
%token	COMMA

%token	SIZE

%token	SEMICOLON

%%
program: header commandList trailer;
header: {printf("%%!PS\n\n");};
trailer: ;

commandList: ;
commandList: commandList command;

command: FORWARD SEMICOLON {printf("newpath 0 0 moveto 0 100 lineto currentpoint translate stroke\n");};
command: FORWARD INTEGER SEMICOLON {printf("newpath 0 0 moveto 0 %d lineto currentpoint translate stroke\n", $2);};

command: COLOR col SEMICOLON;
command: COLOR RGB OPENPR INTEGER COMMA INTEGER COMMA INTEGER CLOSEDPR SEMICOLON{
	printf("%f %f %f setrgbcolor\n",$4 / 255.0,$6 / 255.0,$8 / 255.0);
};

command: TURN LEFT SEMICOLON {printf("90 rotate\n");};
command: TURN RIGHT SEMICOLON{printf("270 rotate\n");};
command: TURN LEFT INTEGER SEMICOLON {printf("%d rotate\n", 90 + $3);};
command: TURN RIGHT INTEGER SEMICOLON{printf("%d rotate\n", 270 + $3);};

command: SIZE INTEGER SEMICOLON{printf("%d setlinewidth\n",$2);};

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
