#include <stdio.h>
#include <string.h>
#include <conio.h>
#include <stdlib.h>

char* init_var(int taroffset);
char* assign(int opOffset,int taroffset);
char* constn(int val);
char* add(int operandleft,int operandright);
char* sub(int operandleft,int operandright);
char* mul(int operandleft,int operandright);
char* div(int operandleft,int operandright);
char* mod(int operandleft,int operandright);
char* show(int opOffset);
char* asif(int icount);
char* asloophead(int lcount);
char* head();
char* foot();
