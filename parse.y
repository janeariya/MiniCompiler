%{
#include <stdio.h>
#include <stdlib.h>
extern int yylex ();
extern void yyerror ( char *);
typedef struct node{
	int val;
	struct node * next;	
} node;

node *getNewNode(int val,node *next);
void push(int val);
int pop(void);

int acc = 0;
int size = 0;
int arr[] = {0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0};
node * topNode = NULL;

%}
%union{
	int dval;
	char *strval;
}
%token <dval> NUM
%token <dval> ID
%token <strval> STRING
%token SHOW INT IF LOOP ASSIGN TO ERROR
%right '>' '<'
%left '+' '-' 
%left '*' '/' '%' EQUAL
%right '^'
%left '(' ')'
%left '{' '}'
%type <dval> exp var
%start result
%%
result :
	result stas '\n' { printf("> "); }	
	| 	result if '\n' 	{ printf("> "); }
	| 	result loop '\n' 	{ printf("> "); }
	|
	;
stas :
	| stas sta ';'
sta :
	| SHOW exp 		{ printf("= %d\n",$2); }
	| SHOW STRING 	{ printf("= %s\n", $2);}
	| ID ASSIGN exp	{ arr[$1] = $3;}
	;
if :
	 IF '(' exp ')' '{' stas '}'	{ if($3)
	 									{ printf("if"); }
	 								}
	;
loop :
	 LOOP '(' exp ')' '{' stas '}'	{}
	| LOOP var ':' INT TO INT '{' stas '}' {}
	;
exp: NUM
	| var   		{ $$ = arr[$1]; }
	| exp '-' exp	{ $$ = $1 - $3; }
	| exp '+' exp 	{ $$ = $1 + $3; }
	| exp '*' exp 	{ $$ = $1 * $3; }
	| exp '/' exp 	{ $$ = $1 / $3; }
	| exp '%' exp	{ $$ = $1 % $3;	}
	| '-' exp		{ $$ = (-1) * $2; }
	| '(' exp ')'	{ $$ = $2;		}
	| exp EQUAL exp { $$ = $1 == $3; }
	| exp '>' exp	{ $$ = $1 > $3; }
	| exp '<' exp  	{ $$ = $1 < $3; }
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
