//PES1UG21CS599

%{
    #define YYSTYPE char*
    #include <unistd.h>
    #include "y.tab.h"
    #include <stdio.h>
    extern void yyerror(const char *); 
%}

/* Regular definitions */
digit	[0-9]
letter	[a-zA-Z]
id	{letter}({letter}|{digit})*
digits	{digit}+
opFraction	(\.{digits})?
opExponent	([Ee][+-]?{digits})?
number	{digits}{opFraction}{opExponent}
%option yylineno

%%
\/\/(.*) ; // ignore comments
[\t\n] ; // ignore whitespaces
if	return IF;
else	return ELSE;
while	return WHILE;
do	return DO;
"("		{return *yytext;}
")"		{return *yytext;}
"{"		{return *yytext;}
"}"		{return *yytext;}
"."         	{return *yytext;}
","         	{return *yytext;}
"*"         	{return *yytext;}
"+"         	{return *yytext;}
";"         	{return *yytext;}
"-"         	{return *yytext;}
"/"         	{return *yytext;}
"="         	{return *yytext;}
"<"	return LT;
">"	return GT;
">="	return GTE;	
"<="	return LTE;
"=="	return EQ;
"!="	return NE;
{number}	{
			yylval = strdup(yytext);  //stores the value of the number to be used later for symbol table insertion
			return T_NUM;
		}
{id}        	{
					yylval = strdup(yytext); //stores the identifier to be used later for symbol table insertion
					return T_ID;
				}
.		{} // anything else => ignore
%%
int yywrap() {
    // Return 1 to indicate EOF (end of file)
    return 1;
}