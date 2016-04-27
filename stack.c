#include "stack.h"

stack* getNewstack (struct node_ast* node){
	
	stack* newstack = (stack*)malloc(sizeof(stack*));
	newstack->node = node;
    newstack->next = NULL;
    return newstack;
}

int isEmpty_stack (stack* top){
	if(top!=NULL)
		return 0;
	return 1;
}

void push (stack** top,struct node_ast* node){
	
	stack* newstack = getNewstack(node);
	if(!isEmpty_stack (*top) ){
		newstack->next = *top;
		
	}
	
	*top = newstack;
	
}
struct node_ast* pop (stack** top){
	
	
	if(!isEmpty_stack(*top)){
		
		struct node_ast* node = (*top)->node;
		stack* temp = *top;
		*top = (*top)->next;
		free(temp);
		return node;
	}
	return NULL;
}

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

