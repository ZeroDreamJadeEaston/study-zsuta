/*输入10个一位数字，保存到数组buf，求最大数max和最小数min，并输出。
  在汇编语言中，21H中断中没有输入输出整数的功能，只能输入输出单个字符。
  为方便映射到汇编程序，此C程序中在输入输出时只能使用getchar、putchar函数。 
*/ 
#include <stdio.h>
char buf[10];
char max;
char min;
int main(){
	//输入10个一位数，并求极值 
	short i=0;
	while(i<10){		
		char ch;
		while((ch=getchar())<'0' || ch>'9');
		ch-='0';
		buf[i]=ch;
		if(i==0){
			max=ch;
			min=ch;
		}else if(ch<min){
			min=ch;
		}else if(ch>max){
			max=ch;
		}
		i++;
	}
	//输出极值
	printf("\nThe maximum value is ");
	putchar(max+'0');
	printf("\nThe minimum value is ");
	putchar(min+'0'); 
	putchar('\n');
	return 0;	
}