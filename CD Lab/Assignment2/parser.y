%{
	#include "quad_generation.c"
	#include <stdio.h>
	#include <stdlib.h>
	#include <string.h>

	#define YYSTYPE char*

	void yyerror(char* s); 											// error handling function
	int yylex(); 													// declare the function performing lexical analysis
	extern int yylineno; 											// track the line number

	FILE* icg_quad_file; //file initialisation for intermediate code generation
	int temp_no = 1;
	int label_no=1;
%}


%token T_ID T_NUM IF ELSE GT GTE LT LTE EQ NE DO WHILE
 
/* specify start symbol */
%start START

%nonassoc IF      //non associative to prevent syntacatic anomalies
%nonassoc ELSE

%%
START : S { 
		printf("Valid syntax\n");   //validation of syntax
		YYACCEPT; //successful parsing MACRO
	};
	 			
	

/* Grammar for assignment */
ASSGN : T_ID '=' E	{		
			
				quad_code_gen($1, $3, "=", " ");		//nside the action, quad_code_gen($1, $3, "=", " "); generates intermediate code for the assignment operation. Here, $1 represents the     identifier, $3 represents the expression, and "=" is the assignment operator.	
			
			}
	;

/* Expression Grammar */
E : E '+' T 	{	
			
			$$ = new_temp();
			quad_code_gen($$, $1, "+", $3);
		}
	| E '-' T 	{	
	
				$$ = new_temp();
				quad_code_gen($$, $1, "-", $3);
			}
	| T
	;
	
	
T : T '*' F 	{	
			$$ = new_temp();
			quad_code_gen($$, $1, "*", $3);
		}
	| T '/' F 	{		
	
	
				$$ = new_temp();
				quad_code_gen($$, $1, "/", $3);
			}
	| F
	;

F : '(' E ')' 	{		    //factor rule(takes an expression/value)

			$$=strdup($2); // duplicate a string
		}
	| T_ID 		{		
					$$=strdup($1);//assignment of expression/value
				}
	| T_NUM 	{		
				$$=strdup($1);
			}
	;
	
S : IF '(' EXPR ')' '{' S '}' {quad_code_gen($3,"","Label","");} S 
       | IF '(' EXPR ')' '{' S '}' {
       			$2 = new_label();
		 		quad_code_gen($2,"","goto","");		
			 	quad_code_gen($3,"","Label","");} ELSE '{' S '}' {quad_code_gen($2,"","Label","");}S
       | ASSGN ';' S 
       |'{'S'}'
       | DO '{' S '}' WHILE '(' EXPR ')' ';' { 
        $1 = new_label();
        quad_code_gen($1, "", "Label", ""); // Generate label for start of loop
        quad_code_gen("", "", "goto", ""); // Jump to condition check
        quad_code_gen($7, "", "Label", ""); // Generate label for end of loop
    } S 
	|
       ;

EXPR : E RELOP E  {	$$ = new_temp();
		quad_code_gen($$, $1, $2, $3);
		$1 = new_label();
		quad_code_gen($1,$$,"if","");	
		$$ = new_label();
		quad_code_gen($$,"","goto","");
		quad_code_gen($1,"","Label","");	
			
		};

RELOP :  GT {strcpy($$,">");}
     | LT {strcpy($$,"<");}
     | LTE {strcpy($$,"<=");}
     | GTE {strcpy($$,">=");}
     | EQ {strcpy($$,"==");}
     | NE {strcpy($$,"!=");}
     ;

%%


/* error handling function */
void yyerror(char* s)
{
	printf("Error :%s at %d \n",s,yylineno);
}


/* main function - calls the yyparse() function which will in turn drive yylex() as well */
int main(int argc, char* argv[])
{
	
	icg_quad_file = fopen("icg_quad.txt","a");
	fprintf(icg_quad_file,"Generated Intermediate Code \n");
	yyparse();
	fclose(icg_quad_file);
	return 0;
}