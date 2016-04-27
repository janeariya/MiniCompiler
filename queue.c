#include "queue.h"

int main(int argc, char const *argv[])
{
    /* code */
    printf("%s\n", "555");
    node* head = NULL;
    node* tail = NULL;    
    enQ(&tail,(char *)"donus");
    enQ(&tail,(char *)"donus2");
    printf("%s\n", deQ(&head,&tail));
    getch();
    return 0;
}

node* getNewnode (char* ass){
	
	node* newNode = (node*)malloc(sizeof(node*));
	newNode->ass = ass;
    newNode->next = NULL;
    return newNode;
}

void enQ (node** tail,char* ass){
      
	node* newNode = getNewnode(ass);
    if(isEmpty(*tail))
        *tail = newNode;
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

int isEmpty(node *node){
    
    if(node!=NULL)
        return 0;
    else
        return 1;
}
