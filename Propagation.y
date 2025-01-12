%{
	#include <stdio.h>
	#include <iostream>
	#include <string>
    #include <string.h>
    #include <map>
	using namespace std;
	#include "y2.tab.h"
	extern FILE *yyin;
	extern int yylex();
	void yyerror(string s);

    string result = "";
    map<string,int> values;
%}

%union
{
	int number;
	char * str;
}

%token  MINUSOP PLUSOP DIVIDEOP MULTOP ASSIGNOP POWEROP SEMICOLON
%token<number> INTEGER
%token<str> VARIABLE
%type<str> expression operand
%left PLUSOP MINUSOP SEMICOLON
%left MULTOP DIVIDEOP POWEROP

%%

program:
  statement
	|
	statement program
    ;

statement:
	VARIABLE ASSIGNOP expression SEMICOLON
	{
        result += string($1) + "=" + string($3) + ";\n";
	}
    |
    VARIABLE ASSIGNOP INTEGER SEMICOLON
    {
        values[string($1)] = $3;
        result += string($1) + "=" + to_string($3) + ";\n";
    }
    |
    VARIABLE ASSIGNOP VARIABLE SEMICOLON
    {
        if(values.find(string($3)) != values.end())
        {
            values[string($1)] = values[string($3)];
            result += string($1) + "=" + to_string(values[string($1)]) + ";\n";
        }
        else
        {
            result += string($1) + "=" + string($3) + ";\n";
        }
    }
    ;

expression:
	VARIABLE						
    {  
        string combined;
        if(values.find(string($1)) != values.end())
            combined = to_string(values[string($1)]);
        else 
            combined = string($1);

	    $$ = strdup(combined.c_str()); 
    } 
	|
    VARIABLE operand INTEGER
    {
        string var;
        if(values.find(string($1)) != values.end())
           var = to_string(values[string($1)]);
        else 
           var = string($1);

        string combined =  var + string($2)  + to_string($3);
		$$ = strdup(combined.c_str());
    }
    |
    VARIABLE operand VARIABLE
    {
        string var1;
        if(values.find(string($1)) != values.end())
           var1 = to_string(values[string($1)]);
        else 
           var1 = string($1);
        
        string var2;
        if(values.find(string($3)) != values.end())
           var2 = to_string(values[string($3)]);
        else 
           var2 = string($3);
        string combined =  var1 + string($2)  + var2;
		$$ = strdup(combined.c_str());
    }
    |
    INTEGER operand VARIABLE
    {
        string var;
        if(values.find(string($3)) != values.end())
           var = to_string(values[string($3)]);
        else 
           var = string($3);
        string combined =  to_string($1) + string($2)  + var;
		$$ = strdup(combined.c_str());
    }
    |
	INTEGER  PLUSOP INTEGER      
    { 
        string combined=to_string($1) + "+" + to_string($3);
	    $$ = strdup(combined.c_str()); 
    }
    |
	INTEGER  MINUSOP INTEGER      
    { 
        string combined=to_string($1) + "-" + to_string($3);
	    $$ = strdup(combined.c_str()); 
    }
    |
	INTEGER  MULTOP INTEGER      
    { 
        string combined=to_string($1) + "*" + to_string($3);
	    $$ = strdup(combined.c_str());  
    }
    |
	INTEGER  DIVIDEOP INTEGER      
    { 
        string combined=to_string($1) + "/" + to_string($3);
	    $$ = strdup(combined.c_str());  
    }
    |
	INTEGER  POWEROP INTEGER      
    { 
        string combined=to_string($1) + "^" + to_string($3);
	    $$ = strdup(combined.c_str());  
    }
    ;
operand :
    PLUSOP 
    {
        string op = "+";
        $$ = strdup(op.c_str());
    }
    |
    MINUSOP
    {
        string op = "-";
        $$ = strdup(op.c_str());
    }
    |
    MULTOP
    {
        string op = "*";
        $$ = strdup(op.c_str());
    }
    |
    DIVIDEOP
    {
        string op = "/";
        $$ = strdup(op.c_str());
    }
    |
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
    cout<<result;
    return 0;
}
