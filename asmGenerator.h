#include <stdio.h>
#include <string.h>
#include <conio.h>
#include <stdlib.h>

char* init_var(char* taroffset);
char* assign(char* opOffset,char* taroffset);
char* constn(char* val);
char* add(char* operandleft,char* operandright);
char* sub(char* operandleft,char* operandright);
char* mul(char* operandleft,char* operandright);
char* div(char* operandleft,char* operandright);
char* mod(char* operandleft,char* operandright);
char* show(char* opOffset);
char* head();
char* foot();
