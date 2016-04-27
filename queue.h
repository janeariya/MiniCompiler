#include <stdio.h>
#include <stdlib.h>
#include <conio.h>

typedef struct node {
	char* ass;
	struct node* next;
} node;

struct node* getNewnode (char* ass);
int isEmpty(node *node);
void enQ (node** head,node** tail,char* ass);
char* deQ (node** head,node** tail);
