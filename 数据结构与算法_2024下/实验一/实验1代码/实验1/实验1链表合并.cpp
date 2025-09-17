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
{
	if (list == NULL || list->next == NULL)
	{
		printf("NULL");
		return;
	}
	
	
	while (list!= NULL)
	{
		if(list->next==NULL)
		{
			printf("%d",list->data);
			list=list->next;
			
		}
		else{
			
		
		printf("%d ", list->data); 
		list=list->next;
		}
	}
	
	printf("\n");
}


void push_list(List** tailNode, int data)
{
	List* newNode = create_node(data);
	(*tailNode)->next = newNode;
	*tailNode = newNode;  
}
List* mergeList(List* list1,List* list2)
{
	List* first=list1->next;
	List* second=list2->next;
	List* dummy = create_list(); 
	List* tailNode = dummy;      
	
	while(first!=NULL&&second!=NULL)
	{
		if(first->data<second->data)
		{
			tailNode->next=first;
			tailNode=first;
			first=first->next;
		}
		else
		{
			tailNode->next=second;
			tailNode=second;
			second=second->next;
		}
	}
	if(first!=NULL)
	{
		tailNode->next=first;
	}
	if(second!=NULL)
	{
		tailNode->next=second;
	}
	
	List* result = dummy->next; 
	free(dummy); 
	return result;

}


int main()
{   
	int n;
	int m;
	List* list1=create_list();
	List* list2=create_list();
	List* tail1 = list1; 
	List* tail2 = list2; 
	
	while(scanf("%d",&n)&&n!=-1){
		
		push_list(&tail1,n);
		
	}
	
	while(scanf("%d",&m)&&m!=-1){
		
		push_list(&tail2,m);
		
	}
	 List* result = mergeList(list1,list2);
	traverse_list(result);
	
	return 0;
}
