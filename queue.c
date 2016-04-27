#include "queue.h"


node_q* getNewnode_q (char* ass){
	
	node_q* newnode_q = (node_q*)malloc(sizeof(node_q*));
	newnode_q->ass = ass;
    newnode_q->next = NULL;
    return newnode_q;
}

void enQ (node_q** head,node_q** tail,char* ass){
      
	node_q* newnode_q = getNewnode_q(ass);
    if(isEmpty(*head))
        *head = newnode_q;
    else
	    (*tail)->next = newnode_q;
	*tail = newnode_q;
	
}
char* deQ (node_q** head,node_q** tail){
    
    char* ass;
    node_q* temp;

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

int isEmpty(node_q* node_q){
    
    if(node_q!=NULL)
        return 0;
    else
        return 1;
}
