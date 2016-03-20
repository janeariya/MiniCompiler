%{
#include <stdio.h>
#include <stdlib.h>
#include <math.h>
extern int yylex ();
extern void yyerror ( char *);
typedef struct node{
	int val;
	struct node * next;	
} node;

typedef struct sym{
	char *name;
	struct sym *next;
} sym;

node *getNewNode(int val,node *next);
void push(int val);
int pop(void);

int acc = 0;
int size = 0;
int reg[] = {0,0,0,0,0,0,0,0,0,0};
node * topNode = NULL;

%}
%union{
	int dval;
	char *id;
}
%token <dval> NUM
%token <id> ID
%token Show IF LOOP
%token INT CHAR STRING BOOL
%left '+' '-'
%left '*' '/' '\\'
%right '^'
%left ')' '('
%token COMMENT
%type <dval> exp
%start result
%%
result :
	result sta '\n' { printf("> "); }	
	|
	;
sta :
	exp				{ printf("= %d\n", $1); }
	| SHOW exp 		{ printf("= %d\n",$2); }
	;
exp: NUM
	| exp '-' exp	{ $$ = $1 - $3; acc = $$;}
	| exp '+' exp 	{ $$ = $1 + $3; acc = $$;}
	| exp '*' exp 	{ $$ = $1 * $3; acc = $$;}
	| exp '/' exp 	{ $$ = $1 / $3; acc = $$;}
	| exp '%' exp	{ $$ = $1 % $3;	acc = $$;}
	| '-' exp		{ $$ = (-1) * $2; }
	| exp '^' exp	{ $$ = pow($1,$3); acc = $$;}
	| exp < exp 	{ $$ = $1 < $3; acc = $$;}
	| exp > exp		{ $$ = $1 > $3; acc = $$;}
	| exp == exp	{ $$ = $1 == $3; acc = $$;}
	| NOT exp 		{ $$ = ~ $2;	acc = $$;}
	| '(' exp ')'	{ $$ = $2;		acc = $$;}
	;
%%

node *getNewNode(int val,node *next){
	node * n = (node *)malloc(sizeof(node *));
	n->val = val;
	n->next = next;
	return n;
}
void push(int val){
	size++;
	node *newNode = getNewNode(val,NULL);
	if(topNode != NULL){
		newNode->next = topNode;
	}
	topNode = newNode;
}
int pop(){
	if(topNode != NULL){
		size--;
		int temp = topNode->val;
		node *tempNode = topNode->next;
		free(topNode);
		topNode = topNode->next;
		return temp;
	}
	else{printf("! ERROR\n");}
	return 0;
}
