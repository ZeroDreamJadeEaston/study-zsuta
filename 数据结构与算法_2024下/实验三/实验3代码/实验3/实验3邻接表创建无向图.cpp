#include<stdio.h>
#include<assert.h>
#include<stdlib.h>
#include<limits.h>
#include<string.h>
#define MAX 100


typedef struct ArcNode
{
	int index;
	struct ArcNode* next;
}ArcNode;
ArcNode* create_node(int index)
{
	ArcNode* newNode=(ArcNode*)malloc(sizeof(ArcNode));
	assert(newNode);
	newNode->index=index;
	newNode->next=NULL;
	return newNode;
}

//无表头链表表头法插入
void insert_node(ArcNode** headNode,int index)
{
	ArcNode* newNode=create_node(index);
//	newNode->next=headNode;
//	headNode=newNode;
	newNode->next=*headNode;
	*headNode=newNode;
}

//顶点信息
typedef struct VNode
{
	char data[20];
	ArcNode* list;
	
}VNode;

//图结构
typedef struct Graph
{
	int arcnum;
	int vexnum;
	VNode vextex[MAX];
}Graph;

//定位邻接顶点该插入哪一行横向纵表
int get_pos(Graph* g,const char* v)
{
	for(int i=0;i<g->vexnum;i++)
	{
		if(strcmp(g->vextex[i].data,v)==0)
		{
			return i;
		}
		
	}	
	return -1;
}
Graph* create_graph()
{
	Graph* g=(Graph*)malloc(sizeof(Graph));
	assert(g);
	//printf("输入边和顶点数：");
	scanf("%d%d",&g->vexnum,&g->arcnum);
	//printf("输入顶点信息：");
	char temp[MAX];
	scanf("%s",temp);
	for(int i=0;i<g->vexnum;i++)
	{
		//scanf_s("%s",g->vextex[i].data,20);
		//	strcpy_s(g->vextex[i].data,1,temp);
		g->vextex[i].data[0]=temp[i];
		g->vextex[i].data[1]='\0';
		g->vextex[i].list=NULL;
	}
	
	char v1[20]="";
	char v2[20]="";
	char v[MAX];
	int i=0;
	int j=0;
	//printf("输入边信息：");
	for(int k=0;k<g->arcnum;k++)
	{
		//scanf_s("%s%s",v1,20,v2,20);
		scanf("%s",v);
		
		v1[0] = v[0];
		v1[1] = '\0'; 
		
		v2[0] = v[1]; 
		v2[1] = '\0'; 
		i=get_pos(g,v1);
		j=get_pos(g,v2);
		if (i == -1 || j == -1) {
			fprintf(stderr, "Error: Invalid vertex names '%s' or '%s'.\n", v1, v2);
			continue;
		}
		//v1--v2
		//v2--v1
		insert_node(&g->vextex[i].list,j);
		insert_node(&g->vextex[j].list,i);
		
	}
	return g;
	
}

void print_graph(Graph* g)
{     
	for(int i=0;i<g->vexnum;i++)
	{   int count=0;
		//printf("%s:\t",g->vextex[i].data);
		ArcNode* pmove=g->vextex[i].list;
		while(pmove!=NULL)
		{    //int pos=pmove->index;
			//printf("%s\t",g->vextex[pos].data);
			count++;
			pmove=pmove->next;
		}
		if(i!=g->vexnum-1)
		{
			printf("%d ",count);
		}
		else
		{
			printf("%d",count);
		}	
		
	}
}

int main()
{   
	Graph* g=create_graph();
	print_graph(g);
	
	return 0;
}
