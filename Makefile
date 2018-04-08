o:
	flex turtle.l
	bison turtle.y
	gcc lex.yy.c turtle.tab.c -lfl  -o turtle
	./turtle < first.tlt > first.ps

