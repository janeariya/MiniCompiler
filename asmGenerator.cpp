#include <iostream>
#include <string>
#include <sstream> 

using namespace std;

string init_var(int taroffset) {
	stringstream asscode;
	asscode << "\txor %rax, %rax" << endl; //clear reg
	asscode << "\tmov %rax,-"<<taroffset<<"(%rbp)"<<endl; //alloc var count offset from base pointer
	return asscode.str();
}

string assign(int opOffset,int taroffset){
	stringstream asscode;
	//if op == '' means $a = add, sub, mul, div, mod, const
	if(opOffset == -1){
		asscode << "\tpop %rax"<< endl;
		asscode << "\tmov %rax,-"<<taroffset<<"(%rbp)"<<endl;
	}
	//if go else means $a = var (op is var address )
	else{
		asscode << "\tmov -"<<opOffset<<"(%rbp),-"<<taroffset<<"(%rbp)"<<endl;
	}
	return asscode.str();
}

string constn(int val){
	stringstream asscode;
	asscode <<  "\tmov"<< val <<",%rax"<<endl; //copy cont to rax
	asscode <<  "\tpush %rax"<< endl; //push rax into stack
	return asscode.str();
}

string add(int operandleft,int operandright){
	stringstream asscode;
	//no operand passed means get it from stack
	if(operandright == -1){
		asscode << "\tpop %rbx"<< endl;
	}
	else{
		asscode << "\tmov -"<< operandright <<"(%rbp), %rbx" << endl;
	}
	if(operandleft == -1){
		asscode << "\tpop %rax"<< endl;
	}
	else{
		asscode << "\tmov -"<<operandleft<<"(%rbp), %rax"<<endl;
	}

	asscode << "\tadd %rbx, %rax"<< endl; // %rax = %rax + %rbx
	asscode << "\tpush %rax"<< endl;
	return asscode.str();
}

string sub(int operandleft,int operandright){
	stringstream asscode;
	//no operand passed means get it from stack
	if(operandright == -1){
		asscode << "\tpop %rbx"<< endl;
	}
	else{
		asscode << "\tmov -"<< operandright <<"(%rbp), %rbx" << endl;
	}
	if(operandleft == -1){
		asscode << "\tpop %rax"<< endl;
	}
	else{
		asscode << "\tmov -"<<operandleft<<"(%rbp), %rax"<<endl;
	}

	asscode << "\tsub %rbx, %rax"<< endl; // %rax = %rax - %rbx
	asscode << "\tpush %rax"<< endl;
	return asscode.str();
}

string mul(int operandleft,int operandright){
	stringstream asscode;
	//no operand passed means get it from stack
	if(operandright == -1){
		asscode << "\tpop %rbx"<< endl;
	}
	else{
		asscode << "\tmov -"<< operandright <<"(%rbp), %rbx" << endl;
	}
	if(operandleft == -1){
		asscode << "\tpop %rax"<< endl;
	}
	else{
		asscode << "\tmov -"<<operandleft<<"(%rbp), %rax"<<endl;
	}

	asscode << "\timul %rbx"<< endl; //%rax = %rax x %rbx ; imul is signed
	asscode << "\tpush %rax"<< endl;
	return asscode.str();
}

string divide(int operandleft,int operandright){
	stringstream asscode;
	//no operand passed means get it from stack
	if(operandright == -1){
		asscode << "\tpop %rbx"<< endl;
	}
	else{
		asscode << "\tmov -"<< operandright <<"(%rbp), %rbx" << endl;
	}
	if(operandleft == -1){
		asscode << "\tpop %rax"<< endl;
	}
	else{
		asscode << "\tmov -"<<operandleft<<"(%rbp), %rax"<<endl;
	}

	asscode << "\tidiv %rbx"<< endl; //%rax = %rax / %rbx ; idiv is signed
	asscode << "\tpush %rax"<< endl;
	return asscode.str();
}

string mod(int operandleft,int operandright){
	stringstream asscode;
	//no operand passed means get it from stack
	if(operandright == -1){
		asscode << "\tpop %rbx"<< endl;
	}
	else{
		asscode << "\tmov -"<< operandright <<"(%rbp), %rbx" << endl;
	}
	if(operandleft == -1){
		asscode << "\tpop %rax"<< endl;
	}
	else{
		asscode << "\tmov -"<<operandleft<<"(%rbp), %rax"<<endl;
	}

	asscode << "\txor %rdx, %rdx"<< endl;
	asscode << "\tidiv %rbx"<< endl; //%rax = %rax / %rbx 
	asscode << "\tpush %rdx"<< endl; //%rdx = %rax % %rbx
	return asscode.str();
}

string asif(int icount){
	stringstream asscode;
	asscode << "IF"<< icount <<" :"<<endl;
	return asscode.str();	
}

string asloophead(int lcount){
	stringstream asscode;
	asscode << "LOOP"<<lcount<<" :"<<endl;
	return asscode.str();	
}

string condition(int operandleft,int operandright,int icount){
	stringstream asscode;
	if(operandright == -1){
		asscode << "\tpop %rbx"<< endl;
	}
	else{
		asscode << "\tmov -"<< operandright <<"(%rbp), %rbx" << endl;
	}
	if(operandleft == -1){
		asscode << "\tpop %rax"<< endl;
	}
	else{
		asscode << "\tmov -"<<operandleft<<"(%rbp), %rax"<<endl;
	}
	asscode << "\tcmp %rax,%rbx"<< endl;
	asscode << "\tjnz IF"<<icount<<endl;
	return asscode.str();
}

string show(int opOffset){
	stringstream asscode;
	//save val to stack before call function
	asscode << "\tpush %rax"<< endl; 
	asscode << "\tpush %rbx"<< endl;
	asscode << "\tpush %rcx"<< endl;
	asscode << "\tpush %rdx"<< endl;
	asscode << "\tpush %rdi"<< endl;
	asscode << "\tpush %rsi"<< endl;
	asscode << "\tpush %rbp"<< endl;
	// put string to print
	asscode << "\tmov $show, %rdi"<< endl;
	// put format
	if(opOffset == -1){
		asscode << "\tpop %rsi"<< endl;
	}
	else{
		asscode << "\tmov -"<<opOffset<<"(%rbp),%rsi"<<endl;
	}
	// set rax = 0
	asscode << "\txor %rax, %rax"<< endl;
	// call printf
	asscode << "\tcall printf"<< endl;

	// return val to reg back to main
	asscode << "\tpop %rax"<< endl;
	asscode << "\tpop %rbx"<< endl;
	asscode << "\tpop %rcx"<< endl;
	asscode << "\tpop %rdx"<< endl;
	asscode << "\tpop %rdi"<< endl;
	asscode << "\tpop %rsi"<< endl;
	asscode << "\tpop %rbp"<< endl;	

	return asscode.str();
}
string head(){
	stringstream asscode;
	asscode << "\t.global main"<< endl;
	asscode << "\t.text"<< endl;
	asscode << "main:\tmov %rsp,%rbp"<< endl;
	asscode << "\tsub $208,%rsp"<< endl;
	return asscode.str();
}
string foot(){
	stringstream asscode;
	asscode << "\tadd $208, %rsp"<< endl;
	asscode << "\tret"<< endl;
	asscode << "show:\t,asciz \" %d \\n\" "<< endl;
	return asscode.str();
}
