#include "asmGenerator.h"

char* init_var(char* taroffset){
	char* asscode = (char *)malloc(sizeof(char*));
	sprintf(asscode,"\txor %rax, %rax\n"); //clear reg
	sprintf(asscode,"\tmov %rax,-%s(%rbp)\n",taroffset); //alloc var count offset from base pointer
	return asscode;
}

char* assign(char* opOffset,char* taroffset){
	char* asscode = (char *)malloc(sizeof(char*));
	//if op == '' means $a = add, sub, mul, div, mod, const
	if(op == ''){
		sprintf(asscode,"\tpop %rax\n");
		sprintf(asscode,"\tmov %rax,-%s(%rbp)\n",taroffset);
	}
	//if go else means $a = var (op is var address )
	else{
		sprintf(asscode,"\tmov -%s(%rbp),%s(%rbp)\n",opOffset,taroffset);
	}
	return asscode;
}

char* constn(char* val){
	char* asscode = (char *)malloc(sizeof(char*));
	sprintf(asscode, "\tmov %s,%rax\n",val); //copy cont to rax
	sprintf(asscode, "\tpush %rax\n"); //push rax into stack
	return asscode;
}

char* add(char* operandleft,char* operandright){
	char* asscode = (char*)malloc(sizeof(char*));
	//no operand passed means get it from stack
	if(operandright == ''){
		sprintf(asscode,"\tpop %rbx\n");
	}
	else{
		sprintf(asscode,"\tmov -%s(%rbp), %rbx\n");
	}
	if(operandleft == ''){
		sprintf(asscode,"\tpop %rax\n");
	}
	else{
		sprintf(asscode,"\tmov -%s(%rbp), %rax\n")
	}

	sprintf(asscode,"\tadd %rbx, %rax\n"); // %rax = %rax + %rbx
	sprintf(asscode,"\tpush %rax\n");
	return asscode;
}

char* sub(char* operandleft,char* operandright){
	char* asscode = (char*)malloc(sizeof(char*));
	//no operand passed means get it from stack
	if(operandright == ''){
		sprintf(asscode,"\tpop %rbx\n");
	}
	else{
		sprintf(asscode,"\tmov -%s(%rbp), %rbx\n");
	}
	if(operandleft == ''){
		sprintf(asscode,"\tpop %rax\n");
	}
	else{
		sprintf(asscode,"\tmov -%s(%rbp), %rax\n")
	}

	sprintf(asscode,"\tsub %rbx, %rax\n"); // %rax = %rax - %rbx
	sprintf(asscode,"\tpush %rax\n");
	return asscode;
}

char* mul(char* operandleft,char* operandright){
	char* asscode = (char*)malloc(sizeof(char*));
	//no operand passed means get it from stack
	if(operandright == ''){
		sprintf(asscode,"\tpop %rbx\n");
	}
	else{
		sprintf(asscode,"\tmov -%s(%rbp), %rbx\n");
	}
	if(operandleft == ''){
		sprintf(asscode,"\tpop %rax\n");
	}
	else{
		sprintf(asscode,"\tmov -%s(%rbp), %rax\n")
	}

	sprintf(asscode,"\tmul %rbx\n"); //%rax = %rax x %rbx
	sprintf(asscode,"\tpush %rax\n");
	return asscode;
}