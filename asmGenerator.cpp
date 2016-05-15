#include <iostream>
#include <string>
#include <sstream> 

using namespace std;

string init_var(int taroffset) {
	stringstream asscode;
	asscode << "\txor %rax, %rax" << endl; //clear reg
	asscode << "\tmovq %rax,-"<<taroffset<<"(%rbp)"<<endl; //alloc var count offset from base pointer
	return asscode.str();
}
string init_string(char* ch,int i) {
	stringstream asscode;
	asscode << "\t.s"<<i<<": .string "<<ch<< endl;
	return asscode.str();	
}


string assign(int opOffset,int taroffset){
	stringstream asscode;
	//if op == '' means $a = add, sub, mul, div, mod, const
	if(opOffset == -1){
		asscode << "\tpop %rax"<< endl;
		asscode << "\tmovq %rax,-"<<taroffset<<"(%rbp)"<<endl;
	}
	//if go else means $a = var (op is var address )
	else{
		asscode << "\tmovq -"<<opOffset<<"(%rbp),-"<<taroffset<<"(%rbp)"<<endl;
	}
	return asscode.str();
}

string constn(int val){
	stringstream asscode;
	asscode <<  "\tmovq $"<< val <<",%rax"<<endl; //copy cont to rax
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
		asscode << "\tmovq -"<< operandright <<"(%rbp), %rbx" << endl;
	}
	if(operandleft == -1){
		asscode << "\tpop %rax"<< endl;
	}
	else{
		asscode << "\tmovq -"<<operandleft<<"(%rbp), %rax"<<endl;
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
		asscode << "\tmovq -"<< operandright <<"(%rbp), %rbx" << endl;
	}
	if(operandleft == -1){
		asscode << "\tpop %rax"<< endl;
	}
	else{
		asscode << "\tmovq -"<<operandleft<<"(%rbp), %rax"<<endl;
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
		asscode << "\tmovq -"<< operandright <<"(%rbp), %rbx" << endl;
	}
	if(operandleft == -1){
		asscode << "\tpop %rax"<< endl;
	}
	else{
		asscode << "\tmovq -"<<operandleft<<"(%rbp), %rax"<<endl;
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
		asscode << "\tmovq -"<< operandright <<"(%rbp), %rbx" << endl;
	}
	if(operandleft == -1){
		asscode << "\tpop %rax"<< endl;
	}
	else{
		asscode << "\tmovq -"<<operandleft<<"(%rbp), %rax"<<endl;
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
		asscode << "\tmovq -"<< operandright <<"(%rbp), %rbx" << endl;
	}
	if(operandleft == -1){
		asscode << "\tpop %rax"<< endl;
	}
	else{
		asscode << "\tmovq -"<<operandleft<<"(%rbp), %rax"<<endl;
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

string asloophead(int var,int lcount){
	stringstream asscode;
	asscode << "\tpop %rcx"<< endl;
	asscode << "\tpop %rax"<< endl;
	asscode << "LOOP"<<lcount<<" :"<<endl;

	asscode << "\tcmp %rax,%rcx"<< endl;
	asscode << "\tjg LE"<<lcount<<endl;

	asscode <<"\tdec %rax"<<endl;
	asscode << "\tmovq %rax,-"<<var<<"(%rbp)"<<endl;

	return asscode.str();	
}
string loopend(int lcount){
	stringstream asscode;
	asscode <<"\tjmp LOOP"<<lcount<<" "<<endl;
	asscode << "LE"<<lcount<<" :"<<endl;
	return asscode.str();
}
string condition(int operandleft,int operandright,int icount){
	stringstream asscode;
	if(operandright == -1){
		asscode << "\tpop %rbx"<< endl;
	}
	else{
		asscode << "\tmovq -"<< operandright <<"(%rbp), %rbx" << endl;
	}
	if(operandleft == -1){
		asscode << "\tpop %rax"<< endl;
	}
	else{
		asscode << "\tmovq -"<<operandleft<<"(%rbp), %rax"<<endl;
	}
	asscode << "\tcmp %rax,%rbx"<< endl;
	asscode << "\tjnz IF"<<icount<<endl;
	return asscode.str();
}

string show(int opOffset){
	stringstream asscode;
	// put string to print
	asscode << "\tleaq .show, %rdi"<< endl;
	// put format
	if(opOffset == -1){
		asscode << "\tpop %rsi"<< endl;
	}
	else{
		asscode << "\tmovq -"<<opOffset<<"(%rbp),%rsi"<<endl;
	}
	// set rax = 0
	asscode << "\txor %rax, %rax"<< endl;
	// call printf
	asscode << "\tcall printf"<< endl;

	return asscode.str();
}
string showString(int i){
	stringstream asscode;
	// put string to print
	asscode << "\tleaq .showstring, %rdi"<< endl;
	// put format
	asscode << "\tleaq .s"<<i<<", %rsi"<< endl;
	// set rax = 0
	asscode << "\txor %rax, %rax"<< endl;
	// call printf
	asscode << "\tcall printf"<< endl;

	return asscode.str();
}
string head(){
	stringstream asscode;
	asscode << ".global main"<< endl;
	asscode << ".text"<< endl;
	asscode << "main:\n\tmovq %rsp,%rbp"<< endl;
	asscode << "\tsub $216,%rsp"<< endl;
	return asscode.str();
}
string foot(){
	stringstream asscode;
	asscode << "\tadd $216, %rsp"<< endl;
	asscode << "\tret"<< endl;
	asscode << ".data\n\t.show: .string \" %d \\n\" "<< endl;
	asscode << "\t.showstring: .string \" %s \\n\" "<< endl;
	return asscode.str();
}
