;#include <stdio.h> 
data segment 
;  char buf[10];
    buf db 10 dup(0)
    max db 0
    min db 0 
    string1  db 13,10,"The maximum value is $" 
    string2  db 13,10,"The minimum value is $" 
    prompt  db "press any key to continue...$"   
;char max;           
;char min;
data ends
code segment
    assume cs:code,ds:data
main proc far
    mov ax,data
    mov ds,ax ;�������ݶμĴ���dsΪdata�εĶε�ַ   
;int main(){
	;//����10��һλ��������ֵ 
	;short i=0;
	mov si,0  ;si=����i
	;while(i<10){  
loop1:	
	cmp si,10
	jnl loop_exit
	;char ch;  al=����ch   
input_digit_entrance:	
    ;while((ch=getchar())<'0' || ch>'9');
	mov ah,1
	int 21h
	cmp al,'0'
	jb input_digit_entrance
	cmp al,'9'
	ja input_digit_entrance
	sub al,'0'
	mov buf[si],al
	cmp si,0
	;ch-='0';
	;buf[i]=ch;
	jne less_than_min
	;if(i==0){
	;		max=ch;
	;		min=ch;
	;	}
	mov max,al
	mov min,al
	jmp branch_exit		
less_than_min:
		;else if(ch<min){
	cmp al,min
	jnb greater_than_max
	mov min,al
	jmp branch_exit	
			;min=ch;
		;}
greater_than_max:
    cmp al,max
    jna branch_exit
    mov max,ch
		;else if(ch>max){
		;	max=ch;
		;} 
	jmp branch_exit	
branch_exit:		
		;i++;
	inc si	
	;}    
	jmp  loop1
loop_exit:	
	;//�����ֵ
	
	;printf("\nThe maximum value is ");
	mov ah,9
	mov dx,offset string1
	int 21h
	mov ah,2
	mov dl,max
	add dl,'0'
	;putchar(max+'0');
	int 21h
	mov ah,9
	mov dx,offset string2
	int 21h
	mov ah,2
	mov dl,min
	add dl,'0'
	int 21h 
	;printf("\nThe minimum value is ");
	;putchar(min+'0');   
	mov dl,13   ;����س���
	int 21h
	mov dl,10   ;������з�
	int 21h
	;putchar('\n');
	;��ʾ�ַ�����press any key to continue...��
	;�ȴ����������ַ�
	mov ah,9
	mov dx,offset prompt
	int 21h
	mov ah,1
	int 21h
	mov ah,4ch ;4ch���ܺ�,������ǰ���򣬷��ز���ϵͳdos
	mov al,0   ;al=����dos�ķ���ֵ
	int 21h

	
	;return 0;	
;}
main endp  
code ends  
end main