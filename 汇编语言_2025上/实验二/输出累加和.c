/*计算1+2+3+…+100，并将结果显示在屏幕上。
  在汇编语言中，21H中断中没有输入输出整数的功能，只能输入输出单个字符。
  为方便映射到汇编程序，此C程序中在输入输出时只能使用getchar、putchar函数。 
*/ 
#include <stdio.h>
int main(){
	short sum=0;	//累加和初始化 
	short i=1;		//累加项初始化 
	//计算1+2+3+…+100 
	while(i<=100){
		sum+=i;
		i++;
	}
	char digits[5];	//数组digits存放累加和sum整数分离出的各位数字字符 
	short count=0;	//digits中存入的数字字符的个数
	//从累加和sum中逆序分离出各位数字，并存入数组digits 
	do{
		char digit=sum%10;
		digit+='0';
		digits[count]=digit;
		count++;
		sum/=10;
	}while(sum!=0);
	//逆序输出数组digits中的各个字符 
	do{
		count--;
		putchar(digits[count]);
	}while(count>0);
	//输出回车符 
	putchar('\n');
	return 0;	
}