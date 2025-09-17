#include<stdio.h>
#include<assert.h>
#include<stdlib.h>
#include<stdbool.h>

bool match(const char* str, int* left_count, int* right_count)
{   
	char stack[1024];  
	int top = -1;
	int i = 0;
	bool mismatch = false; // 标志位，检测是否有不匹配的括号对
	
	while (str[i] != '\0') {   
		if (str[i] == '(' || str[i] == '{' || str[i] == '[') {
			stack[++top] = str[i];  
			(*left_count)++;
		} 
		else if (str[i] == ')' || str[i] == '}' || str[i] == ']') {
			(*right_count)++;      
			if (top == -1) {  // 栈为空，意味着多了一个右括号
				mismatch = true;  // 设置不匹配标志
			} else if ((str[i] == ')' && stack[top] != '(') ||
				(str[i] == ']' && stack[top] != '[') ||
				(str[i] == '}' && stack[top] != '{')) {
				mismatch = true;  // 栈顶元素与当前右括号不匹配
			}
			if (top != -1) {  
				top--;
			}
		}
		i++;
	}
	
	if (top != -1) {  // 如果栈非空，意味着还有未匹配的左括号
		mismatch = true;
	}
	
	return !mismatch;  // 若无不匹配的括号，返回 true；否则返回 false
}

int main()
{
	char str[1024] = "";
	fgets(str, 1024, stdin);  
	int left_count = 0, right_count = 0;
	bool result = match(str, &left_count, &right_count);
	
	printf("%d %d\n", left_count, right_count);
	
	if (result) {
		printf("YES\n");
	} else {
		printf("NO\n");
	}
	
	return 0;
}

