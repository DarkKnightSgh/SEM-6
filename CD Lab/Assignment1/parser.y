%{
#include <stdio.h>
#include <stdlib.h>
int yylex();
void yyerror(char* s);
extern int yylineno;
extern char *yytext;
%}

%token INT FLOAT DOUBLE CHAR STATIC ID INCLUDE HEADER MAIN DO WHILE IF ELSE FOR BREAK NUM LT GT GTE LTE EQ NE OPEN_BRACES CLOSED_BRACES OPEN_SQUARE_BRACES CLOSE_SQUARE_BRACES OPEN_CURLY_BRACES CLOSE_CURLY_BRACES SEM NUM_WHOLE SWITCH CASE DEFAULT COL STRUCT
%start P

%%

P : S {printf("Valid Syntax\n"); YYACCEPT;}
  ;

S : INCLUDE HEADER S
  | MAINFUNCTION S
  | DECLARATION SEM S
  | STRUCT_STATEMENT S
  | 
  ;

TYPE : INT 
| FLOAT 
| CHAR 
| DOUBLE
     ;

DECLARATION : TYPE List_Var | s_error
    ;

ARRAY_DECLARATION : TYPE ID DIMENSIONS SEM | TYPE Array_List SEM
                  ;

DIMENSIONS : SIZE 
            | DIMENSIONS SIZE 
            ;
SIZE : OPEN_SQUARE_BRACES NUM CLOSE_SQUARE_BRACES
      ;

Array_List : ID DIMENSIONS ',' Array_List | ID DIMENSIONS
           ; 

List_Var : ID ',' List_Var | ID 
         ;

ASSIGNMENT : TYPE ID '=' EXPR | ID '=' EXPR 
      ;

EXPR : EXPR RELOP E | E | S
     ;

RELOP : GTE|LTE|EQ|LT|GT
      ;

E : E'+'T|E'-'T|T
  ;

T : T'*'F|T'/'F|F
  ;

F : OPEN_BRACES EXPR CLOSED_BRACES | ID | NUM
  ;

MAINFUNCTION : TYPE MAIN OPEN_BRACES Empty_ListVar CLOSED_BRACES OPEN_CURLY_BRACES STATEMENT CLOSE_CURLY_BRACES
     ;

Empty_ListVar : List_Var
	      |
              ;

STATEMENT : DECLARATION SEM STATEMENT
            |ARRAY_DECLARATION STATEMENT
            |ASSIGNMENT SEM STATEMENT
          | IF_STATEMENT STATEMENT
          | FOR_LOOP STATEMENT
          | WHILE_LOOP STATEMENT
          | SWITCH_STATEMENT STATEMENT
          |
          ;


IF_STATEMENT : IF OPEN_BRACES CONDITION CLOSED_BRACES Stmt ELSE Stmt
             | IF OPEN_BRACES CONDITION CLOSED_BRACES Stmt
             ;
Stmt : SingleStmt 
     | Block 
     ;

SingleStmt : DECLARATION SEM SingleStmt
            |ARRAY_DECLARATION SingleStmt
            |ASSIGNMENT SEM SingleStmt
           | IF_STATEMENT 
           | FOR_LOOP 
           | WHILE_LOOP 
           | BREAK SEM
           |
           ;


Block : OPEN_CURLY_BRACES Stmt CLOSE_CURLY_BRACES
      ;

CONDITION : EXPR | ASSIGNMENT 

FOR_LOOP : FOR OPEN_BRACES CONDITION CLOSED_BRACES Stmt
         ;

WHILE_LOOP : WHILE OPEN_BRACES CONDITION CLOSED_BRACES Stmt
           ;

SWITCH_STATEMENT : SWITCH OPEN_BRACES ID CLOSED_BRACES OPEN_CURLY_BRACES CASE_LIST CLOSE_CURLY_BRACES

CASE_LIST : CASE NUM COL SingleStmt CASE_LIST
            | DEFAULT COL SingleStmt
            |
            ;

STRUCT_STATEMENT : STRUCT ID OPEN_CURLY_BRACES ASSIGNMENT SEM CLOSE_CURLY_BRACES SEM
                  ;

            

s_error : error;
%%

void yyerror(char* s)
{
    printf("Invalid Syntax: %s, line number: %d, token: %s\n", s, yylineno, yytext);
}

int main()
{
    if (!yyparse())
        printf("Valid Syntax\n");
    else
        printf("Invalid Syntax\n");
    return 0;
}
