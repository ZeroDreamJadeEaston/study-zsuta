#include <stdio.h>
#include <stdbool.h>
#include <stdlib.h>
#include <assert.h>

typedef struct Node 
{
	char data;
	struct Node* LChild;
	struct Node* RChild;
} Node, Tree;

// 创建二叉树
void create_tree(Tree** root) 
{
	char userKey = 0;
	scanf(" %c", &userKey);
	if (userKey == '#') {
		*root = NULL;
	} else {
		*root = (Tree*)malloc(sizeof(Tree));
		assert(*root);
		(*root)->data = userKey;
		create_tree(&(*root)->LChild);
		create_tree(&(*root)->RChild);
	}
}

// 查找从根节点到目标节点的路径
bool find_path(Tree* root, char x, char* path, int* pathLen)
{
	if (root == NULL) {
		return false;
	}
	
	// 当前节点加入路径
	path[*pathLen] = root->data;
	(*pathLen)++;
	
	// 检查当前节点是否是目标节点
	if (root->data == x) {
		return true;
	}
	
	// 在左子树或右子树中查找目标节点
	if (find_path(root->LChild, x, path, pathLen) || 
		find_path(root->RChild, x, path, pathLen)) {
		return true;
	}
	
	// 回溯：移除当前节点
	(*pathLen)--;
	return false;
}

int main() 
{
	Tree* A = NULL;
	create_tree(&A);
	
	char x;
	scanf(" %c", &x);
	
	char path[100];
	int pathLen = 0;
	
	if (find_path(A, x, path, &pathLen)) {
		for (int i = 0; i < pathLen; i++) {
			printf("%c ", path[i]);
		}
		printf("\n");
	} else {
		printf("Node not found.\n");
	}
	
	return 0;
}

