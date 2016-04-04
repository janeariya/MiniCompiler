%{
#include <stdio.h>
#include <stdlib.h>
#include <math.h>
extern int yylex ();
extern void yyerror ( char *);

%}
%union{
	int dval;
}
%token <dval> NUM
%token <dval> ID
%token SHOW INT IF LOOP STRING ASSIGN TO ERROR
%right '>' '<'
%left '+' '-' 
%left '*' '/' '%' EQUAL
%right '^'
%left '(' ')'
%left '{' '}'
%type <dval> exp
%start result
%%
result :
	result stas '\n' { printf("> "); }	
	|
	;
stas :
	| stas sta ';'
sta :
	exp				{ printf("= %d\n", $1); }
	| SHOW exp 		{ printf("= %d\n",$2); }
	| IF exp '{' stas '}'	{}
	| LOOP exp '{' stas '}'	{}
	| LOOP ID ':' INT TO INT '{' stas '}' {}
	| ID ASSIGN exp	{ arr[$1] = $3; printf("%d\n",arr[$1]);}
	| ERROR {printf("Error!!");}
	;
exp: NUM
	| ID
	| exp '-' exp	{ $$ = $1 - $3; }
	| exp '+' exp 	{ $$ = $1 + $3; }
	| exp '*' exp 	{ $$ = $1 * $3; }
	| exp '/' exp 	{ $$ = $1 / $3; }
	| exp '%' exp	{ $$ = $1 % $3;	}
	| '-' exp		{ $$ = (-1) * $2; }
	| exp '^' exp	{ $$ = pow($1,$3); }
	| '(' exp ')'	{ $$ = $2;		}
	| exp EQUAL exp { $$ = $1 == $3; }
	| exp '>' exp	{ $$ = $1 > $3; }
	| exp '<' exp  	{ $$ = $1 < $3; }
	;
%%
