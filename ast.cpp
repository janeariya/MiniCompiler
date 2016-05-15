#include <iostream>

using namespace std;

class NodeAst{
	int var_name;
	int val;
	int address;
	char node_type;
	NodeAst *left;
	NodeAst *right;
public:
	NodeAst(int var_name,int val,char node_type,NodeAst *left,NodeAst *right){
		this->var_name = var_name;
		this->val = val;
		this->node_type = node_type;
		this->left = left;
		this->right = right;
		if(var_name == -1){
			this->address = -1;
		}
		else{
			this->address = (var_name)*8;
		}
	}
	int getVal_name(){
		return this->var_name;
	}
	int getVal(){
		return this->val;
	}
	void setVal(int val){
		this->val = val;
	}
	char getnode_type(){
		return this->node_type;
	}
	int getAddress(){
		return this->address;
	}
	NodeAst getNodeLeft(){
		this->left;
	}
	NodeAst getNoderight(){
		this-right;
	}
};
