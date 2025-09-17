
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
    mov ax,0      ;ax=变量sum
    mov si,1      ;si=变量i
summation_entrance:
    cmp si,100
    jg  summation_exit
    add ax,si
    inc si
    jmp summation_entrance
    
summation_exit:
    
	mov si,0
	;	//累加和sum整数分离出的各位数字字符,依次入栈 
	;	//栈中存入的数字字符的个数   si=变量count
	;//从累加和sum中逆序分离出各位数字，并存入数组digits 
	;do{     
split_digit_etrance:
	mov bx,10 ;bl=16位除数，ah=变量dight
	cwd    ;convert word to douleworld ax符号位扩展到dx
	idiv bx   ;ax=商，dx=余数    dx：ax=高被除数
	add dl,'0'
	;push dl ;余数入栈，push,pop只能操作一个字，不能是字节
	push dx  ;dx的值入栈，其中低8位就是分离的数字字符，高8位全为0
	inc si
	;al=商
	cmp ax,0
	jne  split_digit_etrance
	
		
	;//依次从栈中弹出各个字符   
output_digit_entrance:
	dec si
	pop dx    ;栈弹出一个字，低8位是要输出的数字字符，dl=要输出的数字字符
	mov ah,2
	int 21h
	cmp si ,0          
	jg  output_digit_entrance
	mov dl,13  ;回车符ascll=13
	mov ah,2
	int 21h
	mov dl,10 ;换行符ascll=13
	int 21h  
	;显示字符串“press any key to continue...”
	;等待输入任意字符
	mov ah,9
	mov dx,offset prompt
	int 21h
	mov ah,1
	int 21h
	mov ah,4ch ;4ch功能号,结束当前程序，返回操作系统dos
	mov al,0   ;al=返回dos的返回值
	int 21h
main endp       
code ends
end main