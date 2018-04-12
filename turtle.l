%{
extern int yylval;
%}

%%
Forward			return 1;
Turn[ \t]		return 2;
Right			return 3;
Left			return 4;
Color[ \t]		return 5;
Red			return 6;
Green			return 7;
Blue			return 8;
Black			return 9;

[0-9]+			yylval=atoi(yytext);return 10;
rgb			return 11;
\(			return 12;
\)			return 13;
,			return 14;

Size			return 15;

;			return 25;
\/\/.*			;
[[:space:]]		;
.			fprintf(stderr, "Unexpected %c\n", yytext[0]);
%%
