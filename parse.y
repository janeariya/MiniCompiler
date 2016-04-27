%{
#include <stdio.h>
#include <stdlib.h>
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
			SHOW exp 							{
													node_ast* nexp = pop(&top);
													enQ(&head_codeQ,&tail,show(nexp->address));
												}
		| 	SHOW STRING 						{
															
												}
		| 	var ASSIGN exp						{
													node_ast* nexp = pop(&top);
													node_ast* nvar = pop(&top);
													enQ(&head_codeQ,&tail,assign(nexp->address,nvar->address));
												}
		;

if 		:
	 		IF '(' cond ')' '{' stas '}'		{ 
	 												enQ(&head_codeQ,&tail_codeQ,asif(icount));
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
			NUM									{ 	node_ast* const = init(-1,$1,NULL,NULL);
													enQ(&head_codeQ,&tail_codeQ,constn($1));
													push(&top,const);
												}
		| 	ID   								{	node_ast* var = init($1,-1,NULL,NULL);
													if(isReginit[$1] == 0){
														enQ(&head_initQ,&tail_initQ,init_var($1));
														isReginit[$1] = 1;
													}
													push(&top,var);
												}
		| 	exp '-' exp							{	
													node_ast* right = pop(&tail);
													node_ast* left = pop(&tail);
													node_ast* sub = init(-1,-1,left,right);
													push(&tail,sub);
													enQ(&head_codeQ,&tail_codeQ,sub(left->address,right->address));
												}

		| 	exp '+' exp 						{
													node_ast* right = pop(&tail);
													node_ast* left = pop(&tail);
													node_ast* add = init(-1,-1,left,right);
													push(&tail,add);
													enQ(&head_codeQ,&tail_codeQ,add(left->address,right->address));
												}
		| 	exp '*' exp 						{
													node_ast* right = pop(&tail);
													node_ast* left = pop(&tail);
													node_ast* mul = init(-1,-1,left,right);
													push(&tail,mul);
													enQ(&head_codeQ,&tail_codeQ,mul(left->address,right->address));
												}
		| 	exp '/' exp							{	node_ast* right = pop(&tail);
													node_ast* left = pop(&tail);
													node_ast* div = init(-1,-1,left,right);
													push(&tail,div);
													enQ(&head_codeQ,&tail_codeQ,div(left->address,right->address));
												}
		| 	exp '%' exp							{
													node_ast* right = pop(&tail);
													node_ast* left = pop(&tail);
													node_ast* mov = init(-1,-1,left,right);
													push(&tail,div);
													enQ(&head_codeQ,&tail_codeQ,mov(left->address,right->address));	
												}
		| 	'-' exp								{

													node_ast* num = pop(&tail);
													num->val = num->val*-1;
													push(&tail,num);
													deQ(&head_codeQ,&tail_codeQ);
													enQ(&head_codeQ,&tail_codeQ,constn(num->val));
												}
		| 	'(' exp ')'							{}
		;

cond 	: 
			NUM									{	node_ast* const = init(-1,$1,NULL,NULL);
													enQ(&head_codeQ,&tail_codeQ,constn($1));
													push(&top,const);
												}
		| 	exp EQUAL exp 						{	
													node_ast* right = pop(&tail);
													node_ast* left = pop(&tail);
													enQ(&head_code,&tail_code,condition(left->address,right->address,icount++));
												}
		;

var 	: 
			ID 									{	node_ast* var = init($1,-1,NULL,NULL);
													if(isReginit[$1] == 0){
														enQ(&head_initQ,&tail_initQ,init_var($1));
														isReginit[$1] = 1;
													}
													push(&top,var);
												}   
		;     
%%
