data segment       ;全局变量
  prompt db "press any key to continue...$" 
  str1 db "hello world!",13,10,0 
  str2 db "good morning!",13,10,0

data ends  
stack segment
    dw 128 dup(0)             
 ends
;#include <stdio.h>      
code segment 
assume cs:code,ds:data ，ss:stack


;int main() {
main proc far
    mov ax,data
    mov ds,ax
    mov ax,stack
    mov ss,ax
    mov sp,128
    ;char str1[] = "Hello, world!";
    ;char str2[] = "Assembly is powerful."; 
    
    ;输出两个字符串
    mov bx,offset str1   ;offset操作符：取变量名对应的地址
    call puts
    ;Puts(str1);   // 输出第一个字符串
    ;putchar('\n');
      mov ah,2 
   
   
     mov dl,13
     int 21h
     mov dl,10
     int 21h 
     
     mov bx, offset str2
     call puts
    ;Puts(str2);   // 输出第二个字符串
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
     ;等价于
     mov ax,4c00h
     int 21h 
    
    
;}
main endp 


      ;// Puts 函数：输出以 '\0' 结尾的字符串
;// 参数：const char* str（通过 BX 传地址）
;// 返回值：输出字符个数（返回在 AX 中）
;unsigned int Puts(char* str) {
puts proc near 
     ;建立栈帧
    push bp ;保存bp
    mov bp,sp
    
    
    ;unsigned int count = 0;
    sub sp,2 ;栈中留出两个字节存放局部变量 count 的值,[bp-2[访问内存中的局部变量count
    push dx 
    mov word ptr [bp-2],0   ;ptr操作符：显示重载操作数地址类型
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

