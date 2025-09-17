#include<stdio.h>
#include<stdlib.h>
#include<assert.h>
#include<stdbool.h>
typedef struct List
{
	int data;
	struct List* next;
}List;

List* create_list()
{
	List* list=(List*)malloc(sizeof(List));
	assert(list);
	list->next=NULL;
	return list;
}

List* create_node(int data)
{
	List* newNode=(List*)malloc(sizeof(List));
	assert(newNode);
	newNode->data=data;
	newNode->next=NULL;
	return newNode;
}

void traverse_list(List* list)
{     list=list->next;
	while(list!=NULL){
		printf("%d ",list->data);
		list=list->next;
	}printf("\n");
	
}
void push_list(List* list,int data)
{    
	List* newNode=create_node(data);
		newNode->next=list->next;
		list->next=newNode;
}

int main()
{   
	int n;
	List* list=create_list();
	while(scanf("%d",&n)&&n!=-1){
		
		push_list(list,n);
		
	}
	traverse_list(list);
	
	return 0;
}
