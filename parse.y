%{
//#include <stdio.h>
//#include <stdlib.h>
#include <cstdio>
#include <iostream>
#include <queue>
#include <stack>
#include <string>
#include "asmGenerator.cpp" 
#include "ast.cpp"

using namespace std;

extern "C" int yylex();
extern "C" int yyparse();
extern "C" FILE *yyin;
 
void yyerror(const char *s);

int isReginit[27] = {};
int lcount = 0;
int icount = 0;
queue<string> bodycode;
queue<string> initcode;
stack<NodeAst*> nodes;

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
													NodeAst* nodeExp = nodes.top();
													nodes.pop();	
													bodycode.push(show(nodeExp->getAddress()));
												}
		| 	SHOW STRING 						{
															
												}
		| 	var ASSIGN exp						{
													cout<<"sta2"<<endl;
													NodeAst* nodeExp = nodes.top();
													nodes.pop();
													NodeAst* nodeVar = nodes.top();
													nodes.pop();
													bodycode.push(assign(nodeExp->getAddress(),nodeVar->getAddress()));
												}
		;

if 		:
	 		IF '(' cond ')' '{' stas '}'		{ 
	 												cout<<"if"<<endl;
	 												bodycode.push(asif(icount));
	 											}
		;
conloop	:
			NUM TO NUM							{

												}
		;
loop 	: 
			LOOP conloop '{' stas '}' 			{
													
												}	
		;

exp		: 
			NUM									{ 	
													cout<<"x1"<<endl;
													NodeAst* nconst = new NodeAst(-1,$1,'c',NULL,NULL);
													bodycode.push(constn($1));
													nodes.push(nconst);
												}
		| 	ID   								{	
													cout<<"x2"<<endl;
													NodeAst* var = new NodeAst($1,-1,'v',NULL,NULL);
													if(isReginit[$1] == 0){
														initcode.push(init_var($1));
														isReginit[$1] = 1;
													}
													nodes.push(var);
												}
		| 	exp '-' exp							{	
													cout<<"x3"<<endl;
													NodeAst* right = nodes.top();
													nodes.pop();
													NodeAst* left = nodes.top();
													nodes.pop();
													NodeAst* subn = new NodeAst(-1,-1,'s',left,right);
													nodes.push(subn);
													bodycode.push(sub(left->getAddress(),right->getAddress()));
												}

		| 	exp '+' exp 						{
													cout<<"x4"<<endl;
													NodeAst* right = nodes.top();
													nodes.pop();
													NodeAst* left = nodes.top();
													nodes.pop();
													NodeAst* addn = new NodeAst(-1,-1,'a',left,right);
													nodes.push(addn);
													bodycode.push(add(left->getAddress(),right->getAddress()));
												}
		| 	exp '*' exp 						{
													cout<<"x5"<<endl;
													NodeAst* right = nodes.top();
													nodes.pop();
													NodeAst* left = nodes.top();
													nodes.pop();
													NodeAst* muln = new NodeAst(-1,-1,'m',left,right);
													nodes.push(muln);
													bodycode.push(mul(left->getAddress(),right->getAddress()));
												}
		| 	exp '/' exp							{	
													cout<<"x6"<<endl;
													NodeAst* right = nodes.top();
													nodes.pop();
													NodeAst* left = nodes.top();
													nodes.pop();
													NodeAst* divn = new NodeAst(-1,-1,'d',left,right);
													nodes.push(divn);
													bodycode.push(divide(left->getAddress(),right->getAddress()));
												}
		| 	exp '%' exp							{
													cout<<"x7"<<endl;
													NodeAst* right = nodes.top();
													nodes.pop();
													NodeAst* left = nodes.top();
													nodes.pop();
													NodeAst* modn = new NodeAst(-1,-1,'M',left,right);
													nodes.push(modn);
													bodycode.push(mod(left->getAddress(),right->getAddress()));	
												}
		| 	'-' exp								{
													cout<<"x8"<<endl;
													NodeAst* num = nodes.top();
													nodes.pop();
													num->setVal(num->getVal()*-1);
													nodes.push(num);
													//deQ(&head_codeQ,&tail_codeQ);
													bodycode.push(constn(num->getVal()));
												}
		| 	'(' exp ')'							{	
													cout<<"x9"<<endl;
													$$ = $2;}
		;

cond 	: 
			NUM									{	
													cout<<"con1"<<endl;
													NodeAst* nconst = new NodeAst(-1,$1,'c',NULL,NULL);
													bodycode.push(constn($1));
													nodes.push(nconst);
												}
		| 	exp EQUAL exp 						{	
													cout<<"con2"<<endl;
													NodeAst* right = nodes.top();
													nodes.pop();
													NodeAst* left = nodes.top();
													nodes.pop();
													bodycode.push(condition(left->getAddress(),right->getAddress(),icount++));
												}
		;

var 	: 
			ID 									{	
													cout<<"var"<<endl;
													NodeAst* var = new NodeAst($1,-1,'v',NULL,NULL);
													if(isReginit[$1] == 0){
														initcode.push(init_var($1));
														isReginit[$1] = 1;
													}
													nodes.push(var);
												}   
		;     
%%


void yyerror(const char *s) {
	cout << "parse error!  Message: " << s << endl;
	// might as well halt now:
	//exit(-1);
}

int main(int,char**) {
  	yyparse();
  	return 0;
}
