%{
    int lineno;
    
%}
%%
.*    {  yyout=fopen("output.c","a");
	fprintf(yyout,"%2d\t%s\n", lineno, yytext);
	        lineno++;
	 fclose(yyout) ;  }
\n
%%
int yywrap()
{ 
    return(1); 
}
void main(int argc) 
{
    
    yyin = fopen("helloworld.c", "r");
    yylex();
    fclose(yyin);
    
}
