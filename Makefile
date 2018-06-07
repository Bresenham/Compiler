all: turtle first.ps

lex.yy.c: turtle.l
	flex turtle.l

turtle.tab.c turtle.tab.h: turtle.y
	bison -v -d turtle.y

turtle: lex.yy.c turtle.tab.c turtle.tab.h symtab.h symtab.c
	gcc lex.yy.c turtle.tab.c symtab.c -lfl -o turtle

first.ps: first.tlt turtle
	./turtle < first.tlt > first.ps
	more first.ps

clean:
	rm -f lex.yy.c turtle.tab.* *.ps *.o
	rm -f turtle

