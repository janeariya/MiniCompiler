%{
#include <stdio.h>
#include <stdlib.h>
extern int yylex ();
extern void yyerror ( char *);

struct var_int{
	char * name;
	int val;
}

struct var_sting{
	char *name;
	char val[128];
	int len;
}

%}

%union{
	int dval;
	char *strval;
}
%token <dval> NUM
%token <dval> ID
%token <strval> STRING
%token SHOW INT IF LOOP ASSIGN TO END ERROR
%right '>' '<'
%left '+' '-' 
%left '*' '/' '%' EQUAL
%left '(' ')'
%left '{' '}'
%type <dval> exp var
%start result
%%
result :
	result stas END 						{ printf("> "); }	
	| 	result if END 						{ printf("> "); }
	| 	result loop END 					{ printf("> "); }
	|
	;
stas :
	| stas sta ';'
sta :
	exp										{}
	| SHOW exp 								{}
	| SHOW STRING 							{}
	| ID ASSIGN exp							{}
	| ID ASSIGN STRING						{}
	;
if :
	 IF '(' exp ')' '{' stas '}'			{
	 										}
	;
loop :
	 LOOP '(' exp ')' '{' stas '}'			
	| LOOP ID ':' INT TO INT '{' stas '}' 	
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
	| exp EQUAL exp 						{ $$ = $1 == $3; }
	| exp '>' exp							{ $$ = $1 > $3; }
	| exp '<' exp  							{ $$ = $1 < $3; }
	;
var : ID 			{ if(hasVar($1))
						{
							$$=$1;
						}
						else
						{
							printf("Variable %c never assign\n",$1+97);
						}
					}   
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
		topNode = tempNode;
		return temp;
	}
	else{printf("! ERROR\n");}
	return 0;
}
int hasVar(int id){
	if(arr[id]!=0){
		return 1;
	}
	return 0;
}

/*struct AstElement* makeIf(struct AstElement* cond, struct AstElement* exec)
{
    struct AstElement* result = checkAlloc(sizeof(*result));
    result->kind = ekWhile;
    result->data.Stmt.cond = cond;
    result->data.whileStmt.statements = exec;
    return result;
}
struct AstElement* makeWhile(struct AstElement* cond, struct AstElement* exec)
{
    struct AstElement* result = checkAlloc(sizeof(*result));
    result->kind = ekWhile;
    result->data.whileStmt.cond = cond;
    result->data.whileStmt.statements = exec;
    return result;
}*/
