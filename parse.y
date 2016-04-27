%{
#include <stdio.h>
#include <stdlib.h>
#include "ast.h"
#include "asmGenerator.h"
#include "stack.h"
#include "queue.h"
extern int yylex ();
extern void yyerror ( char *);

byte isReginit[] = {0,0,0,0,0,0,0,0,0,0,
					0,0,0,0,0,0,0,0,0,0,
					0,0,0,0,0,0};
int lcount = 0;
int icount = 0;

node_q* head_initQ = NULL;
node_q* tail_initQ = NULL;

node_q* head_codeQ = NULL;
node_q* tail_codeQ = NULL;

stack* top = NULL;


%}

%union{
	int dval;
	char *strval;
	int chval;
}

%token <dval> NUM
%token <chval> ID
%token <strval> STRING
%token SHOW INT IF LOOP ASSIGN TO END ERROR
%left '+' '-' 
%left '*' '/' '%' EQUAL
%left '(' ')'
%left '{' '}'
%type <dval> exp cond
%type <chval> var
%start result
%%
result 	:
			stas END result	 							
		| 	if END result 						
		| 	loop END result 
		|										
		;

stas 	: 
		| 	sta stas

sta 	:
			SHOW exp 							{}
		| 	SHOW STRING 						{}
		| 	var ASSIGN exp						{}
		;

if 		:
	 		IF '(' cond ')' '{' stas '}'		{ 
	 												enQ(&head_codeQ,&tail_codeQ,asif(icount++));
	 											}
		;
conloop	:
			NUM TO NUM							{}
		;
loop 	: 
			LOOP conloop '{' stas '}' 			{
													en
												}	
		;

exp		: 
			NUM									{ 	node_q* const = init(-1,$1,NULL,NULL);
													enQ(&head_codeQ,&tail_codeQ,constn($1));
													push(&top,const);
												}
		| 	ID   								{	}
		| 	exp '-' exp							{}

		| 	exp '+' exp 						{}
		| 	exp '*' exp 						{}
		| 	exp '/' exp							{}
		| 	exp '%' exp							{}
		| 	'-' exp								{}
		| 	'(' exp ')'							{}
		;

cond 	: 
			NUM									{}
		| 	exp EQUAL exp 						{}
		;

var 	: 
			ID 									{	node_q* var = init($1,-1,NULL,NULL);
													if(isReginit[$1] == 0){
														enQ(&head_initQ,&tail_initQ,init_var($1));
														isReginit[$1] = 1;
													}
													push(&top,var);
												}   
		;     
%%
