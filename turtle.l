%{
#include "turtle.tab.h"
%}

%%
Forward			return FORWARD;
Turn[ \t]		return TURN;
Right			return RIGHT;
Left			return LEFT;
Color[ \t]		return COLOR;
Red			return RED;
Green			return GREEN;
Blue			return BLUE;
Black			return BLACK;

[0-9]+			yylval=atoi(yytext);return INTEGER;
rgb			return RGB;
\(			return OPENPR;
\)			return CLOSEDPR;
,			return COMMA;

Size			return SIZE;

;			return SEMICOLON;
\/\/.*			;
[[:space:]]		;
.			fprintf(stderr, "Unexpected %c\n", yytext[0]);
%%
