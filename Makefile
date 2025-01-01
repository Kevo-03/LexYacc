# Default target
all: project1 project2
	./project1 input.txt | ./project2

# Rule for project1
project1: lex1.yy.c y1.tab.c
	g++ lex1.yy.c y1.tab.c -ll -o project1

# Rule for project2
project2: lex2.yy.c y2.tab.c
	g++ lex2.yy.c y2.tab.c -ll -o project2

# Rule to generate lex output for project1
lex1.yy.c: Project.l
	lex -o lex1.yy.c Project.l

# Rule to generate yacc output for project1
y1.tab.c: ConstFolding.y
	yacc -d -o y1.tab.c ConstFolding.y

# Rule to generate lex output for project2
lex2.yy.c: Project.l
	lex -o lex2.yy.c Project.l

# Rule to generate yacc output for project2
y2.tab.c: Propagation.y
	yacc -d -o y2.tab.c Propagation.y

# Clean target to remove all generated files
clean:
	rm -f lex1.yy.c y1.tab.c y1.tab.h project1
	rm -f lex2.yy.c y2.tab.c y2.tab.h project2
run1: project1
	./project1 input.txt
run2: project2
	./project2 input.txt