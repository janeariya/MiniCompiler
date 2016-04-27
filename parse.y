%{
#include <stdio.h>
#include <stdlib.h>
#include "ast.h"
#include "asmGenerator.h"
extern int yylex ();
extern void yyerror ( char *);

byte isReginit[] = {0,0,0,0,0,0,0,0,0,0,
					0,0,0,0,0,0,0,0,0,0,
					0,0,0,0,0,0};
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
	 		IF '(' cond ')' '{' stas '}'		{}
		;

loop 	: 
			LOOP var ':' INT TO INT '{' stas '}' {}	
		;

exp		: 
			NUM									{ 	struct node_q* const = init(-1,$1,NULL,NULL);
													enQ(constn($1));
													push(const);
												}
		| 	ID   								{}
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
			ID 									{	struct node_q* var = init($1,-1,NULL,NULL);
													if(isReginit[$1] == 0){
														enQ(init_var($1));
														isReginit[$1] = 1;
													}
													push(var);
												}   
		;     
%%
