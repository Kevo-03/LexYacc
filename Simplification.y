%{
	#include <stdio.h>
	#include <iostream>
	#include <string>
    #include <string.h>
	using namespace std;
	#include "y.tab.h"
	extern FILE *yyin;
	extern int yylex();
	void yyerror(string s);

    string result = "";

%}

%union
{
	int number;
	char * str;
}

%token  MINUSOP PLUSOP DIVIDEOP MULTOP ASSIGNOP POWEROP SEMICOLON
%token<number> INTEGER
%token<str> VARIABLE
%left PLUSOP MINUSOP SEMICOLON
%left MULTOP DIVIDEOP POWEROP

%%

program:
  statement
	|
	statement program
    ;

statement:
    VARIABLE ASSIGNOP VARIABLE PLUSOP INTEGER SEMICOLON
    {
        if (strcmp($1, $3) == 0 && $5 == 0) {} 
        else 
        {
            result += string($1) + " = " + string($3) + " + " + to_string($5) + ";\n";
        }
    }
    |
    VARIABLE ASSIGNOP INTEGER SEMICOLON
    {
        result += string($1) + " = " + to_string($3) + ";\n";
    }
    |
    VARIABLE ASSIGNOP VARIABLE SEMICOLON
    {
        result += string($1) + " = " + string($3) + ";\n";
    }
    |
    VARIABLE ASSIGNOP VARIABLE MULTOP INTEGER SEMICOLON
    {
        if (strcmp($1, $3) == 0 && $5 == 1) 
        {  }
        else 
        {
            result += string($1) + " = " + string($3) + " * " + to_string($5) + ";\n";
        }
    }
    |
    VARIABLE ASSIGNOP INTEGER MULTOP VARIABLE SEMICOLON
    {
        if ($3 == 1) 
        { } 
        else 
        {
            result += string($1) + " = " + to_string($3) + " * " + string($5) + ";\n";
        }
    }
    |
    VARIABLE ASSIGNOP VARIABLE DIVIDEOP INTEGER SEMICOLON
    {
        if (strcmp($1, $3) == 0 && $5 == 1) 
        {} 
        else 
        {
            result += string($1) + " = " + string($3) + " / " + to_string($5) + ";\n";
        }
    }
    |
    VARIABLE ASSIGNOP INTEGER DIVIDEOP VARIABLE SEMICOLON
    {
        if ($3 == 0)
        {} 
        else 
        {
            result += string($1) + " = " + to_string($3) + " / " + string($5) + ";\n";
        }
    }
    ;


%%

void yyerror(string s){
	cout<<"error: "<<s<<endl;
}
int yywrap(){
	return 1;
}
int main(int argc, char *argv[])
{
    /* Call the lexer, then quit. */
    yyin=fopen(argv[1],"r");
    yyparse();
    fclose(yyin);
    cout<<result;
    return 0;
}
