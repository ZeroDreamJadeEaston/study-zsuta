
;#include <stdio.h>
data segment
    prompt  db "press any key to continue...$"   
data ends    
code segment
    assume cs:code,ds:data   
;int main(){ 
main proc far
    ;mov ds,data
    mov ax,data
    mov ds,ax
    mov ax,0      ;ax=����sum
    mov si,1      ;si=����i
summation_entrance:
    cmp si,100
    jg  summation_exit
    add ax,si
    inc si
    jmp summation_entrance
    
summation_exit:
    
	mov si,0
	;	//�ۼӺ�sum����������ĸ�λ�����ַ�,������ջ 
	;	//ջ�д���������ַ��ĸ���   si=����count
	;//���ۼӺ�sum������������λ���֣�����������digits 
	;do{     
split_digit_etrance:
	mov bx,10 ;bl=16λ������ah=����dight
	cwd    ;convert word to douleworld ax����λ��չ��dx
	idiv bx   ;ax=�̣�dx=����    dx��ax=�߱�����
	add dl,'0'
	;push dl ;������ջ��push,popֻ�ܲ���һ���֣��������ֽ�
	push dx  ;dx��ֵ��ջ�����е�8λ���Ƿ���������ַ�����8λȫΪ0
	inc si
	;al=��
	cmp ax,0
	jne  split_digit_etrance
	
		
	;//���δ�ջ�е��������ַ�   
output_digit_entrance:
	dec si
	pop dx    ;ջ����һ���֣���8λ��Ҫ����������ַ���dl=Ҫ����������ַ�
	mov ah,2
	int 21h
	cmp si ,0          
	jg  output_digit_entrance
	mov dl,13  ;�س���ascll=13
	mov ah,2
	int 21h
	mov dl,10 ;���з�ascll=13
	int 21h  
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
main endp       
code ends
end main