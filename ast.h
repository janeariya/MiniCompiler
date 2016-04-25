#include <stdio.h>
#include <stdlib.h>

struct node
{
	int var_name; //-1 means undef; use for var node
	int address; //-1 means undef; use for var node to address from base pointer
	int val; //-1 means undef; use for const
	struct* node_left; //null for undef
	struct* node_right; //null for undef
};

struct *node init(int var_name,int val,struct* left,struct* right);