#include "queue.h"

typedef struct node {
	char* ass;
	struct node* next;
}node;

//node* head = NULL;
//node* tail = NULL;

node* getNewnode (char* ass){
	
	node* newNode = (node*)malloc(sizeof(node*));
	newNode->ass = ass;
    newNode->next = NULL;
    return newNode;
}

void enQ (node** q,char* ass){
      
	node* newNode = getNewnode(ass);
    if(isEmpty(*q))
        *q = newNode;
    else
	    (*q)->next = newNode;
	//tail = newNode;
	
}
char* deQ (node** q){
    
    char* ass;
    node* temp;
    
    if(!isEmpty(*q)){
    	
        ass = (*q)->ass;
        temp = *q;
        //if(head == tail)
        //    tail == NULL;
        (*q) = (*q)->next;
        free(temp);
        
        return ass;
    }
    return NULL;
}
/*char* getHead (){
    
    if(!isEmpty())
        return head->ass;
    return NULL;
    
}*/

int isEmpty(node *q){
    
    if(q!=NULL)
        return 0;
    else
        return 1;
}
