/*����10��һλ���֣����浽����buf���������max����С��min���������
  �ڻ�������У�21H�ж���û��������������Ĺ��ܣ�ֻ��������������ַ���
  Ϊ����ӳ�䵽�����򣬴�C���������������ʱֻ��ʹ��getchar��putchar������ 
*/ 
#include <stdio.h>
char buf[10];
char max;
char min;
int main(){
	//����10��һλ��������ֵ 
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
	//�����ֵ
	printf("\nThe maximum value is ");
	putchar(max+'0');
	printf("\nThe minimum value is ");
	putchar(min+'0'); 
	putchar('\n');
	return 0;	
}