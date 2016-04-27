#include "ast.h"

struct node_ast* initi(int var_name,int val,struct node_ast* left,struct node_ast* right){
	struct node_ast* node = (struct node_ast*)malloc(sizeof(struct node_ast*)) ;
	node->var_name = var_name;
	node->val = val;
	node->node_left = left;
	node->node_right = right;
	if(var_name == -1 ){
		node->address = -1;
	}
	else{
		node->address = (var_name+1)*8;
	}
	return node;
}
