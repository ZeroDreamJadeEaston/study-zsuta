data segment       ;ȫ�ֱ���
  prompt db "press any key to continue...$" 
  str1 db "hello world!",13,10,0 
  str2 db "good morning!",13,10,0

data ends  
stack segment
    dw 128 dup(0)             
 ends
;#include <stdio.h>      
code segment 
assume cs:code,ds:data ��ss:stack


;int main() {
main proc far
    mov ax,data
    mov ds,ax
    mov ax,stack
    mov ss,ax
    mov sp,128
    ;char str1[] = "Hello, world!";
    ;char str2[] = "Assembly is powerful."; 
    
    ;��������ַ���
    mov bx,offset str1   ;offset��������ȡ��������Ӧ�ĵ�ַ
    call puts
    ;Puts(str1);   // �����һ���ַ���
    ;putchar('\n');
      mov ah,2 
   
   
     mov dl,13
     int 21h
     mov dl,10
     int 21h 
     
     mov bx, offset str2
     call puts
    ;Puts(str2);   // ����ڶ����ַ���
    ;putchar('\n');
     mov ah,2
    
    
     mov dl,13
     int 21h
     mov dl,10
     int 21h
      
      
     mov ah,9
     mov dx,offset prompt
     int 21h
      
      ;return 0;
     mov ah,1
     int 21h
     ;mov ah,4ch
     ;mov al,0
     ;�ȼ���
     mov ax,4c00h
     int 21h 
    
    
;}
main endp 


      ;// Puts ����������� '\0' ��β���ַ���
;// ������const char* str��ͨ�� BX ����ַ��
;// ����ֵ������ַ������������� AX �У�
;unsigned int Puts(char* str) {
puts proc near 
     ;����ջ֡
    push bp ;����bp
    mov bp,sp
    
    
    ;unsigned int count = 0;
    sub sp,2 ;ջ�����������ֽڴ�žֲ����� count ��ֵ,[bp-2[�����ڴ��еľֲ�����count
    push dx 
    mov word ptr [bp-2],0   ;ptr����������ʾ���ز�������ַ����
loop_entrance:
    cmp byte ptr [bx],0
    ;while (*str != '\0') {
    je  loop_exit
    mov ah,2
    mov dl,[bx]
    int 21h
    ;putchar(*str);
    inc bx  
    ;str++;
     ;count++;
    inc word ptr [bp-2]
    jmp loop_entrance
    ;} 
    
loop_exit:    
    ;return count;
    mov ax,word ptr[bp-2]
    pop dx
    mov sp,bp
    pop bp
    ret
;}
puts endp 

code ends
end main

