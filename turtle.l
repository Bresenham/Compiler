%{
#include "symtab.h"
#include "turtle.tab.h"
%}

%%
Forward			return FORWARD;
Turn[ \t]		return TURN;
Right			return RIGHT;
Left			return LEFT;
rgb			return RGB;
Color[ \t]		return COLOR;
Red			return RED;
Green			return GREEN;
Blue			return BLUE;
Black			return BLACK;

Variable		return VAR;
If			return IF;
AND			return AND;
OR			return OR;
Then			return THEN;
Else			return ELSE;
Begin			return START;
End			return END;

[a-z]+			{
				yylval.n = lookup(yytext);
				if(yylval.n == NULL) yylval.n = insert(yytext);
				return ID;
			}

\<			return LESS;
\>			return GREATER;
!			return NOT;
=			return ASSIGN;

\+			return PLUS;
\*			return STAR;
-			return MINUS;
\/			return SLASH;

Curve			return CURVE;

[0-9]+			yylval.i=atoi(yytext);return INTEGER;
[0-9]+\.[0-9]+	yylval.d = atof(yytext); return DOUBLE;
\(			return OPENPR;
\)			return CLOSEDPR;
,			return COMMA;

Size			return SIZE;

;			return SEMICOLON;
\/\/.*			;
[[:space:]]		;
.			fprintf(stderr, "Unexpected %c\n", yytext[0]);
%%
