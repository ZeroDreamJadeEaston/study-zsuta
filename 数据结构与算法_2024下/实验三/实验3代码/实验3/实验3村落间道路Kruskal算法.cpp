#include<stdio.h>
#include<string.h>
#include<stdlib.h>
#include<assert.h>
#include<limits.h>
#define MAX 1000
#define NO INT_MAX

typedef struct Graph {
	int arcnum; 
	int vexnum; 
	int matrix[MAX][MAX]; 
} Graph;

typedef struct Arc {
	int begin;  
	int end;    
	int weight; 
} Arc;

Graph* create_graph() {
	Graph* g = (Graph*)malloc(sizeof(Graph));
	assert(g);
	

	scanf("%d%d", &g->vexnum, &g->arcnum);
	

	for (int i = 0; i < g->vexnum; i++) {
		for (int j = 0; j < g->vexnum; j++) {
			g->matrix[i][j] = NO;
		}
	}
	

	for (int i = 0; i < g->arcnum; i++) {
		int a, b, weight;
		scanf("%d%d%d", &a, &b, &weight);
		a--; b--; 
		g->matrix[a][b] = weight;
		g->matrix[b][a] = weight;
	}
	
	return g;
}

int compare_arc(const void* a, const void* b) {
	return ((Arc*)a)->weight - ((Arc*)b)->weight;
}

void Kruskal(Graph* g) {
	
	Arc* arc = (Arc*)malloc(sizeof(Arc) * g->arcnum);
	int count = 0;
	
	for (int i = 0; i < g->vexnum; i++) {
		for (int j = i + 1; j < g->vexnum; j++) {
			if (g->matrix[i][j] != NO) {
				arc[count].begin = i;
				arc[count].end = j;
				arc[count].weight = g->matrix[i][j];
				count++;
			}
		}
	}
	
	
	if (count < g->vexnum - 1) {
		printf("-1\n");
		free(arc);
		return;
	}
	

	qsort(arc, count, sizeof(Arc), compare_arc);
	
	int* parent = (int*)malloc(sizeof(int) * g->vexnum);
	for (int i = 0; i < g->vexnum; i++) {
		parent[i] = i;
	}
	
	
	int edge_count = 0;
	int total_weight = 0; 
	
	for (int i = 0; i < count && edge_count < g->vexnum - 1; i++) {
		int x = arc[i].begin;
		int y = arc[i].end;
		
	
		while (x != parent[x]) x = parent[x];
		while (y != parent[y]) y = parent[y];
		
	
		if (x != y) {
			parent[x] = y;
			total_weight += arc[i].weight;
			edge_count++;
		}
	}
	
	
	if (edge_count != g->vexnum - 1) {
		printf("-1\n");
	} else {
		printf("%d\n", total_weight);
	}
	
	free(arc);
	free(parent);
}

int main() {
	Graph* g = create_graph();
	Kruskal(g);
	free(g);
	return 0;
}

