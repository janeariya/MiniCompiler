#include "alloc.h"

char* int_alloc(char* name,int val){
	char* asscode;
	sprintf(asscode,"%s DQ %d \n",name,val);
	return asscode;
}
char* string_alloc(char* name,char* val){
	char* asscode;
	sprintf(asscode,"%s DB \'%s\',0xA,0xD \n",name,val);
	return asscode;
}

char* show_string(char* name){
	char asscode;
	sprintf(asscode,"push %s \n",name);
	sprintf(asscode,"JM show \n");
	return asscode;
}   

char* show_string_pro(){
	char asscode;
	sprintf(asscode,"show: \n");
	sprintf(asscode,"call printf \n");
	sprintf(asscode,"ret \n");
}
char* show_int_alloc(){
	char asscode;
	sprintf(asscode,"show_int_alloc %d,10,0\n");
}