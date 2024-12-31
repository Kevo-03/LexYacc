digit	[0-9]
letter	[A-Za-z]
%{
#include <stdio.h>
#include <string.h>
#include "y.tab.h"

%}
%%
[0-9]+ 	yylval.number=atoi(yytext);	return INTEGER;
";" return SEMICOLON;
\+		return PLUSOP;
\-		return MINUSOP;
\= 		return ASSIGNOP;
\^      return POWEROP;
\*      return MULTOP;
\/      return DIVIDEOP;
{letter}({letter}|{digit})* 	{yylval.str = strdup(yytext); return VARIABLE;}
\n
[ \t]+
%%

