#include "ast.h"

 node_ast* init(int var_name,int val,  node_ast* left,  node_ast* right){
	  node_ast* node = (  node_ast*)malloc(sizeof(  node_ast*)) ;
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
