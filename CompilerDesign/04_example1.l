%{
#include<stdio.h>
%}
%%
[0-9]*	{yylval=atoi(yytext);printf("yylval=%d",&yylval);}
aba	printf("2");
a       printf("3");
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