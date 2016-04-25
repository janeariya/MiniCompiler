%{
#include <stdio.h>
#include <stdlib.h>
extern int yylex ();
extern void yyerror ( char *);

%}

%union{
	int dval;
	char *strval;
	char chval;
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
result :
	result stas END 						{}	
	| 	result if END 						{}
	| 	result loop END 					{}
	|
	;
stas :
	| stas sta ';'
sta :
	SHOW exp 								{}
	| SHOW STRING 							{}
	| ID ASSIGN exp							{}
	;
if :
	 IF '(' cond ')' '{' stas '}'			{}
	;
loop : LOOP ID ':' INT TO INT '{' stas '}'  {}	
	;
exp: NUM
	| ID   									{ $$ = arr[$1]; }
	| exp '-' exp							{ $$ = $1 - $3; }
	| exp '+' exp 							{ $$ = $1 + $3; }
	| exp '*' exp 							{ $$ = $1 * $3; }
	| exp '/' exp 							{ $$ = $1 / $3; }
	| exp '%' exp							{ $$ = $1 % $3;	}
	| '-' exp								{ $$ = (-1) * $2; }
	| '(' exp ')'							{ $$ = $2; }
	;
cond : NUM
	| exp EQUAL exp 						{ $$ = $1 == $3; }
	;
var : ID 									{}   
	;     
%%
