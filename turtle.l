

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
;			return 10;
.			fprintf(stderr, "Unexpected %c\n", yytext[0]);
%%
