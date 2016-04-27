%{
//#include <stdio.h>
//#include <stdlib.h>
//#include "asmGenerator.h"
#include <iostream>
#include <queue>
#include <stack>
#include <string>
#include "asmGenerator.cpp" 

using namespace std;

extern "C" int yylex();
extern "C" int yyparse();
extern "C" FILE *yyin;

int isReginit[] = {0,0,0,0,0,0,0,0,0,0,
					0,0,0,0,0,0,0,0,0,0,
					0,0,0,0,0,0};
int lcount = 0;
int icount = 0;


%}
%define parse.error verbose
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
		|	result stas {cout<<"hi"<<endl;}							
		| 	result if 	{cout<<"hi2"<<endl;}					
		| 	result loop  {cout<<"hi3"<<endl;}
		|	result END									
		;

stas 	: 
		| 	 stas sta
		;

sta 	:
			SHOW exp 							{
													cout<<"sta"<<endl;
													//node_ast* nexp = pop(&top);
													//enQ(&head_codeQ,&tail_codeQ,show(nexp->address));
												}
		| 	SHOW STRING 						{
															
												}
		| 	var ASSIGN exp						{
													cout<<"sta2"<<endl;
													//node_ast* nexp = pop(&top);
													//node_ast* nvar = pop(&top);
													//enQ(&head_codeQ,&tail_codeQ,assign(nexp->address,nvar->address));
												}
		;

if 		:
	 		IF '(' cond ')' '{' stas '}'		{ 
	 												cout<<"if"<<endl;
	 												//enQ(&head_codeQ,&tail_codeQ,asif(icount));
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
													cout<<"x1"<<endl;
													//node_ast* nconst = init(-1,$1,NULL,NULL);
													cout<<constn($1);
													//enQ(&head_codeQ,&tail_codeQ,constn($1));
													//push(&top,nconst);
												}
		| 	ID   								{	
																	cout<<"x2"<<endl;
													//node_ast* var = init($1,-1,NULL,NULL);
													//if(isReginit[$1] == 0){
													//	enQ(&head_initQ,&tail_initQ,init_var($1));
													//	isReginit[$1] = 1;
													//}
													//push(&top,var);
												}
		| 	exp '-' exp							{	
															cout<<"x3"<<endl;
													//node_ast* right = pop(&top);
													//node_ast* left = pop(&top);
													//node_ast* subn = init(-1,-1,left,right);
													//push(&top,subn);
													//enQ(&head_codeQ,&tail_codeQ,sub(left->address,right->address));
												}

		| 	exp '+' exp 						{
															cout<<"x4"<<endl;
													//node_ast* right = pop(&top);
													//node_ast* left = pop(&top);
													//node_ast* addn = init(-1,-1,left,right);
													//push(&top,addn);
													//enQ(&head_codeQ,&tail_codeQ,add(left->address,right->address));
												}
		| 	exp '*' exp 						{
															cout<<"x5"<<endl;
													//node_ast* right = pop(&top);
													//node_ast* left = pop(&top);
													//node_ast* muln = init(-1,-1,left,right);
													//push(&top,muln);
													//enQ(&head_codeQ,&tail_codeQ,mul(left->address,right->address));
												}
		| 	exp '/' exp							{	
															cout<<"x6"<<endl;
													//node_ast* right = pop(&top);
													//node_ast* left = pop(&top);
													//node_ast* divn = init(-1,-1,left,right);
													//push(&top,divn);
													//enQ(&head_codeQ,&tail_codeQ,divide(left->address,right->address));
												}
		| 	exp '%' exp							{
															cout<<"x7"<<endl;
													//node_ast* right = pop(&top);
													//node_ast* left = pop(&top);
													//node_ast* modn = init(-1,-1,left,right);
													//push(&top,modn);
													//enQ(&head_codeQ,&tail_codeQ,mod(left->address,right->address));	
												}
		| 	'-' exp								{
													cout<<"x8"<<endl;
													//node_ast* num = pop(&top);
													//num->val = num->val*-1;
													//push(&top,num);
													//deQ(&head_codeQ,&tail_codeQ);
													//enQ(&head_codeQ,&tail_codeQ,constn(num->val));
												}
		| 	'(' exp ')'							{	
															cout<<"x9"<<endl;
													$$ = $2;}
		;

cond 	: 
			NUM									{	
																cout<<"con1"<<endl;
													//node_ast* nconst = init(-1,$1,NULL,NULL);
													//enQ(&head_codeQ,&tail_codeQ,constn($1));
													//push(&top,nconst);
												}
		| 	exp EQUAL exp 						{	
																		cout<<"con2"<<endl;
													//node_ast* right = pop(&top);
													//node_ast* left = pop(&top);
													//enQ(&head_codeQ,&tail_codeQ,condition(left->address,right->address,icount++));
												}
		;

var 	: 
			ID 									{	
																cout<<"var"<<endl;
													//node_ast* var = init($1,-1,NULL,NULL);
													//if(isReginit[$1] == 0){
													//	enQ(&head_initQ,&tail_initQ,init_var($1));
													//	isReginit[$1] = 1;
													//}
													//push(&top,var);
												}   
		;     
%%


void yyerror ( char * str ) { 
	cout<< " ERROR : Could not parse !"<<str<<endl;
}

int yywrap ( void ) { return 0; }

int main() {
  	yyparse();
	
/*	FILE* ass;
	ass = fopen("/As.s","w+");
	fcout<<ass,head());
	while(!isEmpty(head_initQ)){
		 fcout<<ass,head_initQ->ass);
		 deQ(&head_initQ,&tail_initQ);
	}
	while(!isEmpty(head_codeQ)){
		 fcout<<ass,head_codeQ->ass);
		 deQ(&head_codeQ,&tail_codeQ);
	}
	fcout<<ass,foot());
	fclose(ass); */
  	
  	return 0;
}
