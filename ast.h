#include <stdio.h>
#include <stdlib.h>

struct node
{
	int var_name; //-1 means undef; use for var node
	int address; //-1 means undef; use for var node to address from base pointer
	int val; //-1 means undef; use for const
	struct node* node_left; //null for undef
	struct node* node_right; //null for undef
};

struct node* init(int var_name,int val,struct node* left,struct node* right);