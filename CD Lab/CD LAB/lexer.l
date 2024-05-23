%{
#include<stdio.h>
#include "y.tab.h"
int yywrap();
int yylineno;
%}

letter [a-zA-Z]
digit [0-9]
id {letter}(_|{letter}|{digit})*
opsign [+-]?
fractional_part (\.{digit})?
number {opsign}{digit}+{fractional_part}



%%

\/\/(.*) ;
\/\*(.*\n)*.*\*\/ ;

int	return INT;
float	{return FLOAT;}
char	return CHAR;
double	return DOUBLE;
static 	return STATIC;
main	return MAIN;
if	return IF;
else	return ELSE;
for	return FOR;
while	return WHILE;
do	return DO;
break	return BREAK;
switch return SWITCH;
case return CASE;
struct return STRUCT;
default return DEFAULT;
#include return INCLUDE;
"<"{id}".h>" return HEADER;
{id}	return ID;
{number}	return NUM;


"<"	return LT;
">"	return GT;
">="	return GTE;	
"<="	return LTE;
"=="	return EQ;
"("	return OPEN_BRACES;
")"	return CLOSED_BRACES;
"["	return OPEN_SQUARE_BRACES;
"]"	return CLOSE_SQUARE_BRACES;
"{"	return OPEN_CURLY_BRACES;
"}"	return CLOSE_CURLY_BRACES;
";" return SEM;
":" return COL;
\r	;
[' '|'\t']	;
\n	++yylineno;
.	return *yytext;

%%

int yywrap() {
}
