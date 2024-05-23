%{
#include<stdio.h>
int flag1=0,flag2=0;
%}
%%
[a-zA-Z_][a-zA-Z0-9_]* {flag1++;}
[+] {flag1--;}
[-] {flag1--;}
[*] {flag1--;}
[/] {flag1--;}
. {flag2=1;}
%%
int main()
{
	printf("Enter the arithematic operation:   ");
	yylex();
	if(flag1!=1||flag2==1)
	{
		printf("Invalid expression \n");
		return(0);
	}
	else
	{
		printf("valid arithematic expression \n");
		
	}
}
int yywrap()
{
    return(1);
}