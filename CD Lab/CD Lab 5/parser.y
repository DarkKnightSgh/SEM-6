%{
	#include "abstract_syntax_tree.c"
	#include <stdio.h>
	#include <stdlib.h>
	#include <string.h>
	void yyerror(char* s); 											 
	int yylex(); 												
	extern int yylineno; 											%}
// union to allow nodes to have return different datatypes
%union																
{
	char* text;
	expression_node* exp_node;
}
%token <text> T_ID T_NUM IF ELSE DO WHILE LT GT LTE GTE EQ NE
%type <exp_node> E T F ASSGN IF_STATEMENT START EXPR S DO_WHILE_STATEMENT STMT
%type <text> RELOP

/* specify start symbol */
%start START
%%
START : STMT {display_exp_tree($1);printf("Valid syntax\n"); YYACCEPT;}
		;

STMT :  S  STMT	{ $$ = init_exp_node("seq", $1, $2);}
	|	S{ $$ = init_exp_node("seq", $1,NULL);}

S : ASSGN {$$ = $1;}
	|IF_STATEMENT {$$ = $1;}
	|DO_WHILE_STATEMENT {$$ = $1;}
	;
ASSGN : T_ID '=' E ';' {$$=init_exp_node(strdup("="),init_exp_node($1,NULL,NULL),$3);}
	;
E : E '+' T 		{$$=init_exp_node(strdup("+"),$1,$3);}
   | E '-' T 		{$$=init_exp_node(strdup("-"),$1,$3);}
   | T 				{$$=$1;}
   ;
T : T '*' F 		{{$$=init_exp_node(strdup("*"),$1,$3);}}
   | T '/' F 		{$$=init_exp_node(strdup("/"),$1,$3);}
   | F 				{$$=$1;}
   ;
F : '(' E ')' 		{$$=$2;}
	| T_ID 			{$$=init_exp_node($1, NULL,NULL);}
	| T_NUM 		{$$=init_exp_node($1, NULL,NULL);}
	;

IF_STATEMENT : 	IF '(' EXPR ')' '{' STMT '}' {
		$$ = init_exp_node("if", $3, $6);
	}
	|  IF '(' EXPR ')' '{' STMT '}' ELSE '{' STMT '}' {
		$$ = init_exp_node("if-else", $3, init_exp_node("else",$6,$10));
	}

DO_WHILE_STATEMENT : DO '{' STMT '}' WHILE '(' EXPR ')' {
        $$ = init_exp_node("do-while", $3, $7);
    	}

EXPR : EXPR RELOP E {$$=init_exp_node(strdup($2), $1, $3);}
		| E 
     ;

RELOP : GTE {$$ = $1;}
		|LTE {$$ = $1;}
		|EQ {$$ = $1;} 
		|LT {$$ = $1;} 
		|GT {$$ = $1;} 
		|NE {$$ = $1;}
      ;

// RELOP : LT { $$ = "<";}
// 	   | GT { $$ = ">";}
// 	   | GTE { $$ = ">=";}
// 	   | LTE { $$ = "<=";} 
// 	   | EQ { $$ = "==";}
// 	   | NE { $$ = "!=";}
// 	   ;

// RELOP : GTE {
//     $$ = init_exp_node($1, NULL, NULL);
// }
//     | LTE {$$ = init_exp_node($1, NULL, NULL);}
//     | EQ {$$ = init_exp_node($1, NULL, NULL);} 
//     | LT {$$ = init_exp_node($1, NULL, NULL);} 
//     | GT {$$ = init_exp_node($1, NULL, NULL);} 
//     | NE {$$ = init_exp_node($1, NULL, NULL);}
//     ;


%%


/* error handling function */
void yyerror(char* s)
{
	printf("Error :%s at %d \n",s,yylineno);
}


/* main function - calls the yyparse() function which will in turn drive yylex() as well */
int main(int argc, char* argv[])
{
	yyparse();
	return 0;
}