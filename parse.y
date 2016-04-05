%{
#include <stdio.h>
#include <stdlib.h>
extern int yylex ();
extern void yyerror ( char *);

typedef struct var_int{
	char name;
	int val;
	struct var_int* next;
}var_int;

typedef struct var_sting{
	char *name;
	char val[128];
	int len;
	struct var_string* next;
}var_string;
var_int* head_int;
var_string* head_string;

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
	result stas END 						{ printf("> "); }	
	| 	result if END 						{ printf("> "); }
	| 	result loop END 					{ printf("> "); }
	|
	;
stas :
	| stas sta ';'
sta :
	| SHOW exp 								{}
	| SHOW STRING 							{}
	| ID ASSIGN exp							{   if(!hasVar($1))
												{
													enQInt($1,$3);
												}
												else
												{

												}
											}
	;
if :
	 IF '(' cond ')' '{' stas '}'			{
	 										}
	;
loop : LOOP ID ':' INT TO INT '{' stas '}' 	
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

node *getNewVar_int(char name,int val,var_int *next){
	var_int * n = (var_int *)malloc(sizeof(var_int *));
	n->name = name;
	n->val = val;
	n->next = next;
	return n;
}
node *getNewVar_string(char* name,char[] val,int len,var_string *next){
	var_string * n = (var_string *)malloc(sizeof(var_string *));
	n->name = name;
	n->val = val;
	n->len = len;
	n->next = next;
	return n;
}


void enQInt(char name,int val){
	var_int *newVar = getNewVar_int(name,val,NULL);
	if((*head_int) != NULL){
		(*head_int)->next = newVar;
	}
	else{
		head_int= &newVar;
	}
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

int hasVar(char id){
	if(arr[(int)id-97]!=0){
		return 1;
	}
	return 0;
}
