#include "alloc.h"

char* int_alloc(char* name,int val){
	char* asscode;
	sprintf(asscode,"%s DQ %d \n",name,val);
	return asscode;
}
char* string_alloc(char* name,char* val){
	char* asscode;
	sprintf(asscode,"%s DB \'%s\',0xA,0xD \n",name,val);
	sprintf(asscode,"%slen EQU $-%s \n",name,val,name);
	return asscode;
}

char* show_string(char* name){
	char asscode;
	sprintf(asscode,"mov eax, 4 \n");
	sprintf(asscode,"mov ebx, 1 \n");
	sprintf(asscode,"mov ecx, %s \n",name);
	sprintf(asscode,"mov ecx, %slen \n",name);
	sprintf(asscode,"int 0x80 \n");
	return asscode;
}   