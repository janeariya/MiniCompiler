#include "asmGenerator.h"

char* init_var(char* taroffset) {
	char* asscode = (char *)malloc(sizeof(char*));
	sprintf(asscode,"\txor %rax, %rax\n"); //clear reg
	sprintf(asscode,"\tmov %rax,-%s(%rbp)\n",taroffset); //alloc var count offset from base pointer
	return asscode;
}

char* assign(char* opOffset,char* taroffset){
	char* asscode = (char *)malloc(sizeof(char*));
	//if op == '' means $a = add, sub, mul, div, mod, const
	if(opOffset == '-1'){
		sprintf(asscode,"\tpop %rax\n");
		sprintf(asscode,"\tmov %rax,-%s(%rbp)\n",taroffset);
	}
	//if go else means $a = var (op is var address )
	else{
		sprintf(asscode,"\tmov -%s(%rbp),-%s(%rbp)\n",opOffset,taroffset);
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
	if(operandright == NULL){
		sprintf(asscode,"\tpop %rbx\n");
	}
	else{
		sprintf(asscode,"\tmov -%s(%rbp), %rbx\n",operandright);
	}
	if(operandleft == NULL){
		sprintf(asscode,"\tpop %rax\n");
	}
	else{
		sprintf(asscode,"\tmov -%s(%rbp), %rax\n",operandleft);
	}

	sprintf(asscode,"\tadd %rbx, %rax\n"); // %rax = %rax + %rbx
	sprintf(asscode,"\tpush %rax\n");
	return asscode;
}

char* sub(char* operandleft,char* operandright){
	char* asscode = (char*)malloc(sizeof(char*));
	//no operand passed means get it from stack
	if(operandright == NULL){
		sprintf(asscode,"\tpop %rbx\n");
	}
	else{
		sprintf(asscode,"\tmov -%s(%rbp), %rbx\n",operandright);
	}
	if(operandleft == NULL){
		sprintf(asscode,"\tpop %rax\n");
	}
	else{
		sprintf(asscode,"\tmov -%s(%rbp), %rax\n",operandleft);
	}

	sprintf(asscode,"\tsub %rbx, %rax\n"); // %rax = %rax - %rbx
	sprintf(asscode,"\tpush %rax\n");
	return asscode;
}

char* mul(char* operandleft,char* operandright){
	char* asscode = (char*)malloc(sizeof(char*));
	//no operand passed means get it from stack
	if(operandright == NULL){
		sprintf(asscode,"\tpop %rbx\n");
	}
	else{
		sprintf(asscode,"\tmov -%s(%rbp), %rbx\n",operandright);
	}
	if(operandleft == NULL){
		sprintf(asscode,"\tpop %rax\n");
	}
	else{
		sprintf(asscode,"\tmov -%s(%rbp), %rax\n",operandright);
	}

	sprintf(asscode,"\timul %rbx\n"); //%rax = %rax x %rbx ; imul is signed
	sprintf(asscode,"\tpush %rax\n");
	return asscode;
}

char* div(char* operandleft,char* operandright){
	char* asscode = (char*)malloc(sizeof(char*));
	//no operand passed means get it from stack
	if(operandright == NULL){
		sprintf(asscode,"\tpop %rbx\n");
	}
	else{
		sprintf(asscode,"\tmov -%s(%rbp), %rbx\n", operandright);
	}
	if(operandleft == NULL){
		sprintf(asscode,"\tpop %rax\n");
	}
	else{
		sprintf(asscode,"\tmov -%s(%rbp), %rax\n", operandleft);
	}

	sprintf(asscode,"\tidiv %rbx\n"); //%rax = %rax / %rbx ; idiv is signed
	sprintf(asscode,"\tpush %rax\n");
	return asscode;
}

char* mod(char* operandleft,char* operandright){
	char* asscode = (char*)malloc(sizeof(char*));
	//no operand passed means get it from stack
	if(operandright == NULL){
		sprintf(asscode,"\tpop %rbx\n");
	}
	else{
		sprintf(asscode,"\tmov -%s(%rbp), %rbx\n", operandright);
	}
	if(operandleft == NULL){
		sprintf(asscode,"\tpop %rax\n");
	}
	else{
		sprintf(asscode,"\tmov -%s(%rbp), %rax\n", operandleft);
	}

	sprintf(asscode,"\txor %rdx, %rdx\n");
	sprintf(asscode,"\tidiv %rbx\n"); //%rax = %rax / %rbx 
	sprintf(asscode,"\tpush %rdx\n"); //%rdx = %rax % %rbx
	return asscode;
}

char* show(char* opOffset){
	char* asscode = (char*)malloc(sizeof(char*));
	//save val to stack before call function
	sprintf(asscode,"\tpush %rax\n"); 
	sprintf(asscode,"\tpush %rbx\n");
	sprintf(asscode,"\tpush %rcx\n");
	sprintf(asscode,"\tpush %rdx\n");
	sprintf(asscode,"\tpush %rdi\n");
	sprintf(asscode,"\tpush %rsi\n");
	sprintf(asscode,"\tpush %rbp\n");
	// put string to print
	sprintf(asscode,"\tmov $show, %rdi\n");
	// put format
	if(opOffset == '-1'){
		sprintf(asscode,"\tpop %rsi\n");
	}
	else{
		sprintf(asscode,"\tmov -%s(%rbp),%rsi\n",opOffset);
	}
	// set rax = 0
	sprintf(asscode,"\txor %rax, %rax\n");
	// call printf
	sprintf(asscode,"\tcall printf\n");

	// return val to reg back to main
	sprintf(asscode,"\tpop %rax\n");
	sprintf(asscode,"\tpop %rbx\n");
	sprintf(asscode,"\tpop %rcx\n");
	sprintf(asscode,"\tpop %rdx\n");
	sprintf(asscode,"\tpop %rdi\n");
	sprintf(asscode,"\tpop %rsi\n");
	sprintf(asscode,"\tpop %rbp\n");	

	return asscode;
}
char* head(){
	char* asscode = (char*)malloc(sizeof(char*));
	sprintf(asscode,"\t.global main\n");
	sprintf(asscode,"\t.text\n");
	sprintf(asscode,"main:\tmov %rsp,%rbp\n");
	sprintf(asscode,"\tsub $208,%rsp\n");
	return asscode;
}
char* foot(){
	char* asscode = (char*)malloc(sizeof(char*));
	sprintf(asscode,"\tadd $208, %rsp\n");
	sprintf(asscode,"\tret\n");
	sprintf(asscode,"show:\t,asciz \" %d \\n\" \n");
	return asscode;
}
/*int fileGen(node* q){
	FILE * fp;
	fp = fopen ("asm.s", "w+");
	while(){
		fprintf(fp, "%s",);
	}

	fclose(fp);
	return(0);
}*/