#include <stdio.h>
#include <stdlib.h>

typedef struct node_ast
{
	int var_name; //-1 means undef; use for var node
	int address; //-1 means undef; use for var node to address from base pointer
	int val; //-1 means undef; use for const
	struct node_ast* node_left; //null for undef
	struct node_ast* node_right; //null for undef
}node_ast;

node_ast* init(int var_name,int val,node_ast* left, node_ast* right);
