#include <stdio.h>
#include <stdlib.h>
#include "ast.h"

typedef struct stack
{
	struct node_ast* node;
	struct stack* next;
	
}stack;

stack* getNewstack (struct node_ast* node);
int isEmpty_stack (stack* top);
void push (stack** top,struct node_ast* node);
struct node_ast* pop (stack** top);
struct node_ast* initi(int var_name,int val,struct node_ast* left,struct node_ast* right);

