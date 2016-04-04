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
%token SHOW INT IF LOOP ASSIGN TO
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
	| 	result if '\n' 	{ printf("> "); }
	| 	result loop '\n' 	{ printf("> "); }
	|
	;
stas :
	| stas sta ';'
sta :
	exp				{ printf("= %d\n", $1); }
	| SHOW exp 		{ printf("= %d\n",$2); }
	| SHOW STRING 	{ printf("= %s\n", $2);}
	| ID ASSIGN exp	{ arr[$1] = $3; printf("%d\n",arr[$1]);}
	;
if :
	 IF '(' exp ')' '{' stas '}'	{ if($3)
	 									{ $6 }
	 								}
	;
loop :
	 LOOP '(' exp ')' '{' stas '}'	{}
	| LOOP ID ':' INT TO INT '{' stas '}' {}
	;
exp: NUM
	| ID   			{ $$ = arr[$1]; }
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
