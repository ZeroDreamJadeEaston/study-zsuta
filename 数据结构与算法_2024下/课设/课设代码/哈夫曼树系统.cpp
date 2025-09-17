#include<stdio.h>
#include<stdlib.h>
#include<assert.h>
#include<stdbool.h>
#include<string.h>
#define MAX 100
#define MAX_CHAR 256  
#define MAX_SIZE 100
typedef struct HuffMantreeNode
{    
	char key;
	int frequency;
	struct HuffMantreeNode* parentNode;
	struct HuffMantreeNode* LChild;
	struct HuffMantreeNode* RChild;
}Node;

Node* create_node(char key,int frequency)
{
	Node* newNode=(Node*)malloc(sizeof(Node));
	assert(newNode);
	newNode->key=key;
	newNode->frequency=frequency;
	newNode->parentNode=NULL;
	newNode->LChild=NULL;
	newNode->RChild=NULL;
	return newNode;
}

Node* build_huffmantreeNode(Node* first,Node* second)
{
	Node* parentNode=create_node('\0',first->frequency+second->frequency); 
	Node* min=first->frequency>second->frequency?second:first;
	Node* max=first->frequency>second->frequency?first:second;
	parentNode->LChild=min;
	parentNode->RChild=max;
	first->parentNode=parentNode;
	second->parentNode=parentNode;
	return parentNode;
}

//小顶堆
typedef struct Heap
{
	int sizeHeap;
	Node** heapData;
}Heap;

Heap* create_heap()
{
	Heap* heap=(Heap*)malloc(sizeof(Heap));
	assert(heap);
	heap->sizeHeap=0;
	heap->heapData=(Node**)malloc(sizeof(Node*)*MAX);
	assert(heap->heapData);
	return heap;
}
int size_heap(Heap* heap)
{
	return heap->sizeHeap;
}
bool empty_heap(Heap* heap)
{
	return heap->sizeHeap==0;
}

//向上渗透
void move_heap(Heap* heap,int curPos)
{
	while(curPos>1)
	{
		Node* min=heap->heapData[curPos];
		int parentIndex=curPos/2;
		if(min->frequency<heap->heapData[parentIndex]->frequency)
		{
			heap->heapData[curPos]=heap->heapData[parentIndex];
			heap->heapData[parentIndex]=min;
			curPos=parentIndex;
		}
		else
		{
			break;
		}
	}
}
void insert_heap(Heap* heap,Node* data)
{
	heap->heapData[++heap->sizeHeap]=data;
	move_heap(heap,heap->sizeHeap);
}
Node* pop_heap(Heap* heap)
{
	Node* min=heap->heapData[1];
	int curPos=1;
	int childIndex=curPos*2;
	while(childIndex<=heap->sizeHeap)
	{
		Node* temp=heap->heapData[childIndex];
		if(childIndex+1<=heap->sizeHeap&&temp->frequency>heap->heapData[childIndex+1]->frequency)
		{
			temp=heap->heapData[++childIndex];
		}
		heap->heapData[curPos]=temp;
		curPos=childIndex;
		childIndex*=2;
	}
	heap->heapData[curPos]=heap->heapData[heap->sizeHeap];
	move_heap(heap,curPos);
	--heap->sizeHeap;
	return min;
}
void printCurNode(Node* curNode)
{
	if(curNode->key==NULL)
	{
		printf("#");
	}
	printf("%c ",curNode->key);
}
void traverses_preorder(Node* root)
{
	if(root!=NULL)
	{
		printCurNode(root);
		traverses_preorder(root->LChild);
		traverses_preorder(root->RChild);
	}
	else if(root==NULL)
	{
		return;
	}
	
}
void traverses_midorder(Node* root)
{
	if(root!=NULL)
	{
		traverses_midorder(root->LChild);
		printCurNode(root);
		traverses_midorder(root->RChild);
	}
	else if(root==NULL)
	{
		return;
	}
}
void traverses_lastorder(Node* root)
{
	if(root!=NULL)
	{
		traverses_lastorder(root->LChild);
		traverses_lastorder(root->RChild);
			printCurNode(root);
	}
	else if(root==NULL)
	{
		return;
	}
}
void init_heap(Heap* heap,char characters[],int frequency[],int n)
{
	for(int i=0;i<n;i++)
	{
		insert_heap(heap,create_node(characters[i],frequency[i]));
	}
}
Node* build_huffmantree(char characters[],int frequency[],int n)
{
	if(n<=0)
	{
		return NULL;
	}
	else if(n==1)
	{
		return create_node(characters[0],frequency[0]);
	}
	else
	{
		Heap* heap=create_heap();
		init_heap(heap,characters,frequency,n);
		Node* root=NULL;
		while(!empty_heap(heap))
		{
			Node* first=pop_heap(heap);
			if(empty_heap(heap))
			{
				break;
			}
			Node* second=pop_heap(heap);
			root=build_huffmantreeNode(first,second);
			insert_heap(heap,root);
		}
		return root;
		
	}
}
Node* search_huffmantree(Node* tree,char key)
{
	Node* pmove=tree;
	Node* stack[MAX];
	int top=-1;
	while(pmove!=NULL||top!=-1)
	{
		while(pmove!=NULL&&pmove->key!=key)
		{
			stack[++top]=pmove;
			pmove=pmove->LChild;
		}
		if(pmove==NULL)
		{
			pmove=stack[top--];
			pmove=pmove->RChild;
		}
		else if(pmove->key==key)
		{
			break;
		}
		
	}
	return pmove;
}

void print_huffmancode(Node* leaf)
{
	Node* pmove=leaf;
	int stack[MAX];
	int top=-1;
	while(pmove!=NULL)
	{
		if(pmove->parentNode!=NULL&&pmove->parentNode->LChild==pmove)
		{
			stack[++top]=0;
		}
		else if(pmove->parentNode!=NULL&&pmove->parentNode->RChild==pmove)
		{
			stack[++top]=1;
		}
		else
		{
			break;
		}
		pmove=pmove->parentNode;
	}
	
	while(top!=-1)
	{
		printf("%d",stack[top--]);	
	}
	printf("\n");
}
// 打印赫夫曼树
void print_huffman_tree(Node* root,int depth)
{
	if (root == NULL) return;
	for (int i = 0; i < depth; i++) printf("\t");
	if (root->key != '\0') {
		printf("'%c' (%d)", root->key, root->frequency);
	} else {
		printf("内部节点 (%d)\n", root->frequency);
	}
	
	print_huffman_tree(root->LChild, depth + 1);
	print_huffman_tree(root->RChild, depth + 2);
}
// 编码函数
void encode(const char* text, char codes[MAX_CHAR][MAX_SIZE], FILE* codeFile) {
	for (int i = 0; text[i] != '\0'; i++) {
		if (codes[(unsigned char)text[i]][0] == '\0') { // 检查编码是否存在
			printf("未找到字符 '%c' 的编码，跳过该字符。\n", text[i]);
			continue;
		}
		fprintf(codeFile, "%s", codes[(unsigned char)text[i]]); // 输出编码到文件
	}
	printf("编码完成，结果已写入文件 CodeFile.txt。\n");
}

void generate_codes(Node* root, char* code, int top, char codes[MAX_CHAR][MAX_SIZE]) {
	if (root->LChild == NULL && root->RChild == NULL) {
		code[top] = '\0'; // 添加字符串结束符
		strcpy(codes[(unsigned char)root->key], code); // 存储编码
		return;
	}
	
	if (root->LChild != NULL) {
		code[top] = '0';
		generate_codes(root->LChild, code, top + 1, codes);
	}
	if (root->RChild != NULL) {
		code[top] = '1';
		generate_codes(root->RChild, code, top + 1, codes);
	}
}

// 将赫夫曼树保存到文件
void save_huffman_tree(Node* root, FILE* file) {
	if (root == NULL) {
		fprintf(file, "# "); // 使用特殊标记表示空节点
		return;
	}
	
	fprintf(file, "%c %d ", root->key, root->frequency); // 保存当前节点
	save_huffman_tree(root->LChild, file);              // 保存左子树
	save_huffman_tree(root->RChild, file);              // 保存右子树
}


// 从文件读取赫夫曼树
Node* load_huffman_tree(FILE* file) {
	char key;
	int frequency;
	
	if (fscanf(file, " %c", &key) != 1 || key == '#') { // 读取空节点标记
		return NULL;
	}
	fscanf(file, "%d", &frequency); // 读取权值
	
	Node* node = create_node(key, frequency);
	node->LChild = load_huffman_tree(file); // 递归加载左子树
	node->RChild = load_huffman_tree(file); // 递归加载右子树
	return node;
}
// 解码函数
void decode(Node* root, FILE* codeFile, FILE* textFile) {
	if (!root) {
		printf("赫夫曼树为空，无法进行解码操作。\n");
		return;
	}
	
	char ch;
	Node* current = root; // 从根节点开始解码
	printf("译码结果：\n");
	while ((ch = fgetc(codeFile)) != EOF) {
		if (ch == '0') {
			current = current->LChild; // 根据 0 移动到左子树
		} else if (ch == '1') {
			current = current->RChild; // 根据 1 移动到右子树
		} else {
			printf("遇到无效字符 '%c'，跳过。\n", ch);
			continue;
		}
		
		// 如果到达叶子节点，输出字符并回到根节点
		if (current->LChild == NULL && current->RChild == NULL) {
			printf("%c", current->key);        // 输出到终端
			fputc(current->key, textFile);    // 写入解码文件
			current = root;                   // 返回到根节点
		}
	}
	printf("\n解码完成，结果已保存到文件 TextFile.txt。\n");
}

// 打印代码文件内容
void print_code_file(const char* input_filename, const char* output_filename) {
	FILE* input_file = fopen(input_filename, "r");
	if (!input_file) {
		printf("无法打开文件 %s\n", input_filename);
		return;
	}
	
	FILE* output_file = fopen(output_filename, "w");
	if (!output_file) {
		printf("无法打开文件 %s 进行写入。\n", output_filename);
		fclose(input_file);
		return;
	}
	
	char ch;
	int char_count = 0;
	
	printf("文件内容如下：\n");
	while ((ch = fgetc(input_file)) != EOF) {
		putchar(ch);                  // 显示到终端
		fputc(ch, output_file);       // 写入输出文件
		char_count++;
		
		// 每行 50 个字符换行
		if (char_count % 50 == 0) {
			putchar('\n');            // 终端换行
			fputc('\n', output_file); // 文件换行
		}
	}
	
	// 如果最后一行未满 50 个字符，手动换行
	if (char_count % 50 != 0) {
		putchar('\n');
		fputc('\n', output_file);
	}
	
	fclose(input_file);
	fclose(output_file);
	
	printf("\n文件内容已写入 %s\n", output_filename);
}

// 打印赫夫曼树到终端和文件
// 打印赫夫曼树，同时将结构保存到文件
void print_huffman_tree(Node* root, int depth, FILE* file) {
	if (root == NULL) return;
	
	// 打印当前深度的缩进
	for (int i = 0; i < depth; i++) {
		printf("\t");
		if (file) fprintf(file, "\t");
	}
	
	// 打印当前节点信息
	if (root->key != '\0') { // 叶子节点
		printf("'%c' (%d)\n", root->key, root->frequency);
		if (file) fprintf(file, "'%c' (%d)\n", root->key, root->frequency);
	} else { // 内部节点
		printf("内部节点 (%d)\n", root->frequency);
		if (file) fprintf(file, "内部节点 (%d)\n", root->frequency);
	}
	
	// 打印左子树
	for (int i = 0; i < depth + 1; i++) {
		printf("\t");
		if (file) fprintf(file, "\t");
	}
	printf("|\n");
	if (file) fprintf(file, "|\n");
	
	for (int i = 0; i < depth + 1; i++) {
		printf("\t");
		if (file) fprintf(file, "\t");
	}
	printf("--> 左子树:\n");
	if (file) fprintf(file, "--> 左子树:\n");
	
	print_huffman_tree(root->LChild, depth + 1, file); // 递归打印左子树
	
	// 打印右子树
	for (int i = 0; i < depth + 1; i++) {
		printf("\t");
		if (file) fprintf(file, "\t");
	}
	printf("|\n");
	if (file) fprintf(file, "|\n");
	
	for (int i = 0; i < depth + 1; i++) {
		printf("\t");
		if (file) fprintf(file, "\t");
	}
	printf("--> 右子树:\n");
	if (file) fprintf(file, "--> 右子树:\n");
	
	print_huffman_tree(root->RChild, depth + 1, file); // 递归打印右子树
}


// 菜单函数
void menu() {
	printf("\t--------------------------------------------------------\n");
	printf("\t|\t              哈夫曼树操作  \t\t\t|\n");
	printf("\t|\t======================================\t\t|");
	printf( "\n\t|\t\t\t\t\t\t\t|\n");
	printf("\t|\tI: 初始化\t\t\t\t\t|\n");
	printf("\t|\tE: 编码\t\t\t\t\t\t|\n");
	printf("\t|\tD: 译码\t\t\t\t\t\t|\n");
	printf("\t|\tP: 打印代码文件\t\t\t\t\t|\n");
	printf("\t|\tT: 打印赫夫曼树\t\t\t\t\t|\n");
	printf("\t|\tQ: 退出\t\t\t\t\t\t|");
	printf( "\n\t|\t\t\t\t\t\t\t|");
	printf( "\n\t|\t\t\t\t\t\t\t|");
	printf("\n\t--------------------------------------------------------\n");
	printf( "\n");
	printf( "\t\t\t请选择：" );
}
int main()
{   
	char choice='\0';
	Node* root=NULL;
	char codes[MAX_CHAR][MAX_SIZE] = {0};
	FILE *codeFile, *textFile, *treeFile;
	
		while(1){
		menu();
			scanf(" %c", &choice);	
			if (choice == 'I') {
				int n;
				printf("请输入字符集大小 n: ");
				scanf("%d", &n);
				char characters[n];
				int frequencies[n];
				
				printf("请输入字符和权值:\n");
				for (int i = 0; i < n; i++) {
					printf("字符 %d: ", i + 1);
					scanf(" %c", &characters[i]);
					printf("权值 %d: ", i + 1);
					scanf("%d", &frequencies[i]);
				}
				
			root=build_huffmantree(characters,frequencies,n);
				printf("先序排序:\n");
			traverses_preorder(root);
				printf("\n中序排序:\n");
				traverses_midorder(root);
				printf("\n后序排序:\n");
				traverses_lastorder(root);
				char code[MAX_SIZE];
				generate_codes(root, code, 0, codes);
				printf("\n赫夫曼树初始化完成。\n");
				
				// 将赫夫曼树保存到文件
				treeFile = fopen("hfmTree.xls", "wb");
				if (!treeFile) {
					printf("无法打开文件hfmTree.xls进行写入。\n");
				} else {
					save_huffman_tree(root, treeFile);
					fclose(treeFile);
					printf("赫夫曼树已保存到文件hfmTree.xls。\n");
				}
			system("pause");
			system("cls");
				}
			
			 else if (choice == 'E') {
			textFile = fopen("ToBeTran.txt", "r");
				 if (!textFile) {
					 printf("无法打开文件 ToBeTran.txt 进行读取。\n");
					 continue;
				 }
				 
				 // 从文件加载赫夫曼树
				 treeFile = fopen("hfmTree.xls", "rb");
				 if (!treeFile) {
					 printf("无法打开文件 hfmTree.xls 进行读取。\n");
					 fclose(textFile);
					 continue;
				 }
				 root = load_huffman_tree(treeFile);
				 fclose(treeFile);
				 
				 if (!root) {
					 printf("赫夫曼树加载失败。\n");
					 fclose(textFile);
					 continue;
				 }
				 
				 // 生成赫夫曼编码
				 char code[MAX_SIZE];
				 generate_codes(root, code, 0, codes);
				 // 打印赫夫曼编码表到终端
				 printf("赫夫曼编码表:\n");
				 for (int i = 0; i < MAX_CHAR; i++) {
					 if (codes[i][0] != '\0') { // 如果字符有编码
						 printf("%c: %s\n", i, codes[i]);
					 }
				 }
				 
				 
				 // 打开编码结果文件
				 codeFile = fopen("CodeFile.txt", "w");
				 if (!codeFile) {
					 printf("无法打开文件 CodeFile.txt 进行写入。\n");
					 fclose(textFile);
					 continue;
				 }
				 
				 // 对正文进行编码
				 char ch;
				 while ((ch = fgetc(textFile)) != EOF) {
					 if (codes[ch][0] != '\0') {  // 如果字符有对应编码
						 fprintf(codeFile, "%s", codes[ch]);
					 } else {
						 printf("未找到字符 '%c' 的编码，跳过该字符。\n", ch);
					 }
				 }
				 
				 printf("编码完成，结果已写入文件 CodeFile.txt。\n");
				 
				 fclose(textFile);
				 fclose(codeFile);
				 system("pause");
				 system("cls");
			} 
			else if (choice == 'D') {
				// 打开编码文件 CodeFile.txt
				codeFile = fopen("CodeFile.txt", "r");
				if (!codeFile) {
					printf("无法打开文件 CodeFile.txt 进行读取。\n");
					continue;
				}
				
				// 打开输出文件 TextFile.txt
				textFile = fopen("TextFile.txt", "w");
				if (!textFile) {
					printf("无法打开文件 TextFile.txt 进行写入。\n");
					fclose(codeFile);
					continue;
				}
				
				// 从文件加载赫夫曼树
				treeFile = fopen("hfmTree.xls", "rb");
				if (!treeFile) {
					printf("无法打开文件 hfmTree.xls 进行读取。\n");
					fclose(codeFile);
					fclose(textFile);
					continue;
				}
				root = load_huffman_tree(treeFile);
				fclose(treeFile);
				
				if (!root) {
					printf("赫夫曼树加载失败，无法进行译码操作。\n");
					fclose(codeFile);
					fclose(textFile);
					continue;
				}
				
				// 调用解码函数
				decode(root, codeFile, textFile);
				
				fclose(codeFile);
				fclose(textFile);
				system("pause");
				system("cls");
			}
			
			else if (choice == 'P') {
			print_code_file("CodeFile.txt", "CodePrin.txt");
				system("pause");
				system("cls");
			} 
			
			else if (choice == 'T') {
			printf("哈夫曼树打印结果如下：\n");
				// 从文件加载赫夫曼树
				treeFile = fopen("hfmTree.xls", "rb");
				if (!treeFile) {
					printf("无法打开文件 hfmTree.xls 进行读取。\n");
					fclose(textFile);
					continue;
				}
				root = load_huffman_tree(treeFile);
				fclose(treeFile);
				
				if (!root) {
					printf("赫夫曼树加载失败。\n");
					fclose(textFile);
					continue;
				}
				
				// 生成赫夫曼编码
				char code[MAX_SIZE];
				generate_codes(root, code, 0, codes);
				// 打印赫夫曼编码表到终端
				printf("赫夫曼编码表:\n");
				for (int i = 0; i < MAX_CHAR; i++) {
					if (codes[i][0] != '\0') { // 如果字符有编码
						printf("%c: %s\n", i, codes[i]);
					}
				}
				// 打开文件 TreePrint.xls
				FILE* treePrintFile = fopen("TreePrint.xls", "w");
				if (!treePrintFile) {
					printf("无法打开文件 TreePrint.xls 进行写入。\n");
					continue;
				}
				
				// 打印到编译器并写入文件
				print_huffman_tree(root, 0, treePrintFile);
				
				// 关闭文件
				fclose(treePrintFile);
				
				printf("哈夫曼树已写入文件 TreePrint.xls。\n");
				
				system("pause");
				system("cls");
			} 
			
			else if (choice == 'Q') {
				printf("感谢你的使用，下次再见！");
				break;
			} 
			
			else {
				printf("无效输入，请重新选择。\n");
				system("pause");
				system("cls");
			}
		
			
		}
	return 0;
}
