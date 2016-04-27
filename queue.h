#include <stdio.h>
#include <stdlib.h>
#include <conio.h>

typedef struct node_q {
	char* ass;
	struct node_q* next;
} node_q;

struct node_q* getNewnode_q (char* ass);
int isEmpty(node_q *node_q);
void enQ (node_q** head,node_q** tail,char* ass);
char* deQ (node_q** head,node_q** tail);
