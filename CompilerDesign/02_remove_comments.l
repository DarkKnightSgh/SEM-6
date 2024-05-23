%%
"//".* 
"//".*\n  
. {printf("%s",yytext);}
%%
int yywrap()
{
    return(1);
}
int main(int argc, char *argv[]) 
{
yyin=fopen("helloworld.c","r");
yylex();
return 0;
}