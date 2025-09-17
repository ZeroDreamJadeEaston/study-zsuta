data segment       ;全局变量
  prompt db "press any key to continue...$"
  key db  "Please enter a string: $" 
  str_buffer db 80, db 0, db 80 dup(0)

data ends  
stack segment
    dw 128 dup(0)             
 ends     
code segment 
assume cs:code,ds:data ，ss:stack


;int main() {
main proc far
    mov ax,data
    mov ds,ax
    mov ax,stack
    mov ss,ax
    mov sp,128
   
    
    mov ah,9
    mov dx,offset key
    int 21h 
    
    mov dx,offset str_buffer
    call input_string  
    
    
    
    
    
    
    ;换行
    mov ah,2
    mov dl,13
    int 21h
    mov dl,10
    int 21h
     
     
     mov bx,offset str_buffer+2
     call puts 
     
     mov bx,ax  
    
     mov ah,2
    
    
     mov dl,13
     int 21h
     mov dl,10
     int 21h
     
     
     dec bx        
     mov ax, bx 
       call print_unsigned        
      ;换行
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
                

input_string proc near
    push ax
    push dx  
    mov ah,0Ah
    int 21h
    pop dx
    pop ax
    ret
input_string endp
                
                

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
    mov ax,[bp-2]
    pop dx
    mov sp,bp
    pop bp
    ret
;}
puts endp 
             
print_unsigned proc near
    push bp
    mov bp, sp
    push ax
    push bx
    push dx
    push cx

    xor cx, cx          ; 位数统计器
    mov bx, 10          ; 除数 = 10

.divide_loop:
    xor dx, dx
    div bx              ; AX ÷ 10 → 商AX，余数DX
    push dx             ; 把余数保存，先入栈（反序）
    inc cx              ; 统计位数
    cmp ax, 0
    jne .divide_loop

.output_loop:
    pop dx
    add dl, '0'         ; 数字转字符
    mov ah, 2
    int 21h
    loop .output_loop

    pop cx
    pop dx
    pop bx
    pop ax
    pop bp
    ret
print_unsigned endp
             
code ends
end main

