%{
	#include <stdio.h>
	#include <iostream>
	#include <string>
    #include <string.h>
	#include <map>
	using namespace std;
	#include "y.tab.h"
	extern FILE *yyin;
	extern int yylex();
	void yyerror(string s);

    string result = "";

    int integerPower(int base, int exponent) 
    {
        int result = 1;
        for (int i = 0; i < exponent; ++i) 
        {
            result *= base;
        }
        return result;
    }

	/*
		we need to store the name of variable and  value of it.
		So we can use two array for that. One for keeping names, one for the values.
		But it would be a little bit complicated.
		Instead we use map library of c++.
		This is not about lex and yacc it is about data structure
	*/
	map<string,int> values;
%}

%union
{
	int number;
	char * str;
}

%token  MINUSOP PLUSOP DIVIDEOP MULTOP ASSIGNOP POWEROP
%token<number> INTEGER
%token<str> VARIABLE
%type<str> expression operand
%left PLUSOP MINUSOP
%left MULTOP DIVIDEOP POWEROP

%%

program:
  statement
	|
	statement program
    ;

statement:
	VARIABLE ASSIGNOP expression
	{
			result += string($1) + "=" + string($3) + "\n";
	}
    ;

expression:
	VARIABLE						
    {  
       string combined=string($1);
	   $$ = strdup(combined.c_str()); 
    } 
	|
	INTEGER 						 
    {  
        string combined=string($1);
	    $$ = strdup(combined.c_str()); 
    }
	|
    VARIABLE operand INTEGER
    {
        string combined =  string($1) + string($2)  + string($3);
		$$ = strdup(combined.c_str());
    }
    |
    VARIABLE operand VARIABLE
    {
        string combined =  string($1) + string($2)  + string($3);
		$$ = strdup(combined.c_str());
    }
    |
    INTEGER operand VARIABLE
    {
        string combined =  string($1) + string($2)  + string($3);
		$$ = strdup(combined.c_str());
    }
    |
	INTEGER  PLUSOP INTEGER      
    { 
        int res = $1 + $3;
        string combined=string(res);
	    $$ = strdup(combined.c_str()); 
    }
    |
	INTEGER  MINUSOP INTEGER      
    { 
        int res = $1 - $3; 
        string combined=string(res);
	    $$ = strdup(combined.c_str()); 
    }
    |
	INTEGER  MULTOP INTEGER      
    { 
        int res = $1 * $3;
        string combined=string(res);
	    $$ = strdup(combined.c_str());  
    }
    |
	INTEGER  DIVIDEOP INTEGER      
    { 
        int res = $1 / $3;
        string combined=string(res);
	    $$ = strdup(combined.c_str());  
    }
    |
	INTEGER  POWEROP INTEGER      
    { 
        int res = integerPower($1,$3);
        string combined=string(res);
	    $$ = strdup(combined.c_str());  
    }
    ;
operand :
    PLUSOP 
    {
        string op = "+";
        $$ = strdup(op.c_str());
    }
    MINUSOP
    {
        string op = "-";
        $$ = strdup(op.c_str());
    }
    MULTOP
    {
        string op = "*";
        $$ = strdup(op.c_str());
    }
    DIVIDEOP
    {
        string op = "/";
        $$ = strdup(op.c_str());
    }
    POWEROP
    {
        string op = "^";
        $$ = strdup(op.c_str());
    }


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
    return 0;
}
