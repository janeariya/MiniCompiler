#include "ast.h"

struct node* init(int var_name,int val,struct node* left,struct node* right){
	struct node* node = (struct node*)malloc(sizeof(struct node*)) ;
	node->var_name = var_name;
	node->val = val;
	node->node_left = left;
	node->node_right = right;
	if(var_name == -1 ){
		node->address = -1;
	}
	else{
		node->address = val*8;
	}
	return node;
}