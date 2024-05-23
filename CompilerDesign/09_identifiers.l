digit     [0-9]
letter    [_A-Za-z]
%{
#include<stdio.h>
%}
%% 
{letter}({letter}|{digit})*    printf("Valid Identifier : %s\n",yytext);
. ;
\n ;
%% 
int yywrap()
{
    return(1);
}
int main(int argc, char *argv[]) 
{   
    yyin = fopen(argv[1], "r");
    yylex();
    fclose(yyin);
    return 0;
}