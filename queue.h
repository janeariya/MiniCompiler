#include <stdio.h>
#include <stdlib.h>

struct node* getNewnode (char* ass);
int isEmpty(node* q);
void enQ (node** q,char* ass);
char* deQ (node** q);
char* getHead (void);
