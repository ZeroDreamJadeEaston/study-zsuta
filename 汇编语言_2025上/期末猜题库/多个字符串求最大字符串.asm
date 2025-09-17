data segment       ;全局变量
  prompt db "press any key to continue...$"
  key db  "Please enter a string: $" 
  str_buffer db 80, db 0, db 80 dup(0)  
  max_str db 80 dup(0) 
  max_length dw 0
    empty_line_msg db 13, 10, "Empty line detected! $"
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
    
inpus_loop:    
    mov dx,offset str_buffer
    call input_string  
    
    
    ; 先判断是否空行
    call kong_inspect 
    cmp cx, 0 
    je inpus_exit

    ; 不是空行，正常继续处理
    mov bx,offset str_buffer+2
    call count 
    mov bx,ax  
    dec bx
    mov di, offset  max_length
    cmp bx,[di]
    jle kong
    mov [di],bx
    mov si, offset str_buffer + 2
    mov di, offset max_str
    call copy_string                         
                             
kong:
   ;换行
    mov ah,2
    mov dl,13
    int 21h
    mov dl,10
    int 21h 
    jmp inpus_loop
    

inpus_exit:     
         
        ;换行
    mov ah,2
    mov dl,13
    int 21h
    mov dl,10
    int 21h    
     
     mov bx,offset max_str
     call puts 
       ;换行
    mov ah,2
    mov dl,13
    int 21h
    mov dl,10
    int 21h 
    
    mov bx,offset  max_length    
     mov ax, [bx] 
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
 
 
count proc near 
 ;建立栈帧
    push bp ;保存bp
    mov bp,sp
    
    
    ;unsigned int count = 0;
    sub sp,2 ;栈中留出两个字节存放局部变量 count 的值,[bp-2[访问内存中的局部变量count
    push dx 
    mov word ptr [bp-2],0   ;ptr操作符：显示重载操作数地址类型
loop_entrance3:
    cmp byte ptr [bx],0
    ;while (*str != '\0') {
    je  loop_exit3
    ;putchar(*str);
    inc bx  
    ;str++;
     ;count++;
    inc word ptr [bp-2]
    jmp loop_entrance3
    ;} 
    
loop_exit3:    
    ;return count;
    mov ax,[bp-2]
    pop dx
    mov sp,bp
    pop bp
    ret
;}

count endp                    
   
kong_inspect proc near
    push ax
    push bx
    
    push si

    mov bx, offset str_buffer
    mov cl, [bx + 1]    ; 获取实际输入字符数
    mov ch, 0

    cmp cx, 0
    je is_empty_line    ; 直接空行

    mov si, bx
    add si, 2           ; SI 指向输入区

check_loop:
    cmp cl, 0
    je is_empty_line    ; 全检查完且全是空格 → 算空行

    mov al, [si]
    cmp al, ' '
    jne not_empty_line  ; 只要有非空格字符，算“非空行”

    inc si
    dec cl
    jmp check_loop      ; 继续检查下一个字符

is_empty_line:
    mov ah, 9
    mov dx, offset empty_line_msg
    int 21h

    mov cx, 0           ; 退出循环信号
    jmp end_kong_inspect

not_empty_line:
    mov cx, 1           ; 继续循环信号

end_kong_inspect:
    pop si
    pop bx
    pop ax
    ret
kong_inspect endp   
 
 
 copy_string proc near
    push ax    ; 保存用到的寄存器
    push si
    push di

copy_loop:
    mov al, [si]   ; 取源字符串当前字符
    mov [di], al   ; 存到目标地址
    cmp al, 0      ; 是否到 '\0' ？
    je copy_done   ; 是的话，完成

    inc si
    inc di
    jmp copy_loop  ; 否则继续复制

copy_done:
    pop di
    pop si
    pop ax
    ret
copy_string endp

                

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

