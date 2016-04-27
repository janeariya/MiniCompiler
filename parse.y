%{
#include <stdio.h>
#include <stdlib.h>
#include "asmGenerator.h"
#include "stack.h"
#include "queue.h"
extern int yylex ();
extern void yyerror ( char *);
extern int yyparse();
int isReginit[] = {0,0,0,0,0,0,0,0,0,0,
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
%define debug
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
		|	 stas END result {printf("hi");}							
		| 	if END result 	{printf("hi2");}					
		| 	loop END result  {printf("hi3");}									
		;

stas 	: 
		| 	 sta stas
		;

sta 	:
			SHOW exp 							{
													printf("sta");
													node_ast* nexp = pop(&top);
													enQ(&head_codeQ,&tail_codeQ,show(nexp->address));
												}
		| 	SHOW STRING 						{
															
												}
		| 	var ASSIGN exp						{
													printf("sta2");
													node_ast* nexp = pop(&top);
													node_ast* nvar = pop(&top);
													enQ(&head_codeQ,&tail_codeQ,assign(nexp->address,nvar->address));
												}
		;

if 		:
	 		IF '(' cond ')' '{' stas '}'		{ 
	 												printf("if");
	 												enQ(&head_codeQ,&tail_codeQ,asif(icount));
	 											}
		;
conloop	:
			NUM TO NUM							{}
		;
loop 	: 
			LOOP conloop '{' stas '}' 			{
													
												}	
		;

exp		: 
			NUM									{ 	
													printf("x1");
													node_ast* nconst = init(-1,$1,NULL,NULL);
													enQ(&head_codeQ,&tail_codeQ,constn($1));
													push(&top,nconst);
												}
		| 	ID   								{	
																	printf("x2");
													node_ast* var = init($1,-1,NULL,NULL);
													if(isReginit[$1] == 0){
														enQ(&head_initQ,&tail_initQ,init_var($1));
														isReginit[$1] = 1;
													}
													push(&top,var);
												}
		| 	exp '-' exp							{	
															printf("x3");
													node_ast* right = pop(&top);
													node_ast* left = pop(&top);
													node_ast* subn = init(-1,-1,left,right);
													push(&top,subn);
													enQ(&head_codeQ,&tail_codeQ,sub(left->address,right->address));
												}

		| 	exp '+' exp 						{
															printf("x4");
													node_ast* right = pop(&top);
													node_ast* left = pop(&top);
													node_ast* addn = init(-1,-1,left,right);
													push(&top,addn);
													enQ(&head_codeQ,&tail_codeQ,add(left->address,right->address));
												}
		| 	exp '*' exp 						{
															printf("x5");
													node_ast* right = pop(&top);
													node_ast* left = pop(&top);
													node_ast* muln = init(-1,-1,left,right);
													push(&top,muln);
													enQ(&head_codeQ,&tail_codeQ,mul(left->address,right->address));
												}
		| 	exp '/' exp							{	
															printf("x6");
		node_ast* right = pop(&top);
													node_ast* left = pop(&top);
													node_ast* divn = init(-1,-1,left,right);
													push(&top,divn);
													enQ(&head_codeQ,&tail_codeQ,divide(left->address,right->address));
												}
		| 	exp '%' exp							{
															printf("x7");
													node_ast* right = pop(&top);
													node_ast* left = pop(&top);
													node_ast* modn = init(-1,-1,left,right);
													push(&top,modn);
													enQ(&head_codeQ,&tail_codeQ,mod(left->address,right->address));	
												}
		| 	'-' exp								{
													printf("x8");
													node_ast* num = pop(&top);
													num->val = num->val*-1;
													push(&top,num);
													deQ(&head_codeQ,&tail_codeQ);
													enQ(&head_codeQ,&tail_codeQ,constn(num->val));
												}
		| 	'(' exp ')'							{	
															printf("x9");
													$$ = $2;}
		;

cond 	: 
			NUM									{	
																printf("con1");
			node_ast* nconst = init(-1,$1,NULL,NULL);
													enQ(&head_codeQ,&tail_codeQ,constn($1));
													push(&top,nconst);
												}
		| 	exp EQUAL exp 						{	
																		printf("con2");
													node_ast* right = pop(&top);
													node_ast* left = pop(&top);
													enQ(&head_codeQ,&tail_codeQ,condition(left->address,right->address,icount++));
												}
		;

var 	: 
			ID 									{	
																printf("var");
			node_ast* var = init($1,-1,NULL,NULL);
													if(isReginit[$1] == 0){
														enQ(&head_initQ,&tail_initQ,init_var($1));
														isReginit[$1] = 1;
													}
													push(&top,var);
												}   
		;     
%%

int main() {
  	while(yyparse());
	
	FILE* ass;
	ass = fopen("/As.s","w+");
	fprintf(ass,head());
	while(!isEmpty(head_initQ)){
		 fprintf(ass,head_initQ->ass);
		 deQ(&head_initQ,&tail_initQ);
	}
	while(!isEmpty(head_codeQ)){
		 fprintf(ass,head_codeQ->ass);
		 deQ(&head_codeQ,&tail_codeQ);
	}
	fprintf(ass,foot());
	fclose(ass);
  	
  	return 0;
}
