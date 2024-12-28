digit	[0-9]
letter	[A-Za-z]
%{
#include <stdio.h>
#include <string.h>
#include "y.tab.h"

%}
%%
[0-9]+ 	yylval.number=atoi(yytext);	return INTEGER;
\+		return PLUSOP;
\-		return MINUSOP;
\= 		return EQUALSYM;
\^      return SQUARE;
\*      return MULOP;
\/      return DIVOP;
{letter}({letter}|{digit})* 	return IDENTIFIER;
\n
[ \t]+
%%

