#include "queue.h"


node* getNewnode (char* ass){
	
	node* newNode = (node*)malloc(sizeof(node*));
	newNode->ass = ass;
    newNode->next = NULL;
    return newNode;
}

void enQ (node** head,node** tail,char* ass){
      
	node* newNode = getNewnode(ass);
    if(isEmpty(*head))
        *head = newNode;
    else
	    (*tail)->next = newNode;
	*tail = newNode;
	
}
char* deQ (node** head,node** tail){
    
    char* ass;
    node* temp;

    if(!isEmpty(*head)){
    	
        ass = (*head)->ass;
        temp = *head;
        if(*head == *tail)
            *tail == NULL;
        (*head) = (*head)->next;
        free(temp);
        
        return ass;
    }
    return NULL;
}

int isEmpty(node* node){
    
    if(node!=NULL)
        return 0;
    else
        return 1;
}
