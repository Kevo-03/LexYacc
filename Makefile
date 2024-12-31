all: lex yacc
	g++ lex.yy.c y.tab.c -ll -o project

yacc: ConstFolding.y
	yacc -d ConstFolding.y

lex: Project.l
	lex Project.l

run: project
	./project input.txt
clean:
	rm lex.yy.c y.tab.c  y.tab.h  project
