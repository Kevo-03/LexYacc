# Default target
example1: project1 project2 project3
	./project1 input1.txt | ./project2 | ./project1 | ./project3 
example2: project1 project2 
	./project1 input2.txt | ./project2 | ./project1 | ./project2 | ./project1 | ./project2 | ./project1

# Rule for project1
project1: lex1.yy.c y1.tab.c
	g++ lex1.yy.c y1.tab.c -ll -o project1

# Rule for project2
project2: lex2.yy.c y2.tab.c
	g++ lex2.yy.c y2.tab.c -ll -o project2

project3: lex3.yy.c y3.tab.c
	g++ lex3.yy.c y3.tab.c -ll -o project3

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

lex3.yy.c: Project.l
	lex -o lex3.yy.c Project.l

# Rule to generate yacc output for project3
y3.tab.c: Simplification.y
	yacc -d -o y3.tab.c Simplification.y


# Clean target to remove all generated files
clean:
	rm -f lex1.yy.c y1.tab.c y1.tab.h project1
	rm -f lex2.yy.c y2.tab.c y2.tab.h project2
	rm -f lex3.yy.c y3.tab.c y3.tab.h project3

run1: project1
	./project1 input.txt
run2: project2
	./project2 input.txt
run3: project3
	./project3 input.txt