/*����1+2+3+��+100�����������ʾ����Ļ�ϡ�
  �ڻ�������У�21H�ж���û��������������Ĺ��ܣ�ֻ��������������ַ���
  Ϊ����ӳ�䵽�����򣬴�C���������������ʱֻ��ʹ��getchar��putchar������ 
*/ 
#include <stdio.h>
int main(){
	short sum=0;	//�ۼӺͳ�ʼ�� 
	short i=1;		//�ۼ����ʼ�� 
	//����1+2+3+��+100 
	while(i<=100){
		sum+=i;
		i++;
	}
	char digits[5];	//����digits����ۼӺ�sum����������ĸ�λ�����ַ� 
	short count=0;	//digits�д���������ַ��ĸ���
	//���ۼӺ�sum������������λ���֣�����������digits 
	do{
		char digit=sum%10;
		digit+='0';
		digits[count]=digit;
		count++;
		sum/=10;
	}while(sum!=0);
	//�����������digits�еĸ����ַ� 
	do{
		count--;
		putchar(digits[count]);
	}while(count>0);
	//����س��� 
	putchar('\n');
	return 0;	
}