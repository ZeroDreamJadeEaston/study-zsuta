data segment
length dw 0
array dw 256 dup(0)
output db "Sum: $"   
input_buffer db "$" 
key1 db  "Please enter the array length: $"  
key db 13,10,"press any key...$"
key2 db  "Please enter the elements of the array sequentially: $" 
;short sum;                            // 存储求和结果
sum dw 0  


data ends
stack segment
    
stack ends
dw   128  dup(0)
code segment
assume cs:code,ds:data
   
                 
main proc far 
     mov ax,data
    mov ds,ax
    mov ax,stack
    mov ss,ax
    mov sp,128  
    
    mov ah,9
    mov dx,offset key1
    int 21h
    
    
    push offset length
    call input_stack 
    
    
     ;换行
    mov ah,2
    mov dl,13
    int 21h
    mov dl,10
    int 21h   
     
   ;验证输入的length正确性
   mov bx,offset length
   mov ax,[bx]
   call print_unsigned  
   
   
     ;换行
    mov ah,2
    mov dl,13
    int 21h
    mov dl,10
    int 21h   
    
    
    mov ah,9
    mov dx,offset key2
    int 21h   
    
    
    
    mov si,offset length
    mov cx,[si]
    mov bx, offset array
input_loop:
     push bx
     call input_array
     add bx,2 
       mov ah,2
       mov dl,' '
       int 21h 
     loop input_loop
     

      ;换行
    mov ah,2
    mov dl,13
    int 21h
    mov dl,10
    int 21h   

     
        
    
    
    ;// 调用子过程
    ;ArraySum();
    push offset array
    push sum
    call arraysum
    add sp,4
    mov bx,ax
    
    ;// 测试输出结果
    ;printf("Sum: %d\n", sum);
    
    mov ah,9
    mov dx,offset output
    int 21h
    
    mov ax,bx
    call print_unsigned
    
    mov ah,9
    mov dx,offset key
    int 21h
    
    mov ah,1
    int 21h
    
    ;return 0;
    mov ax,4c00h
    int 21h
;}   
main endp  
input_stack proc near
    push bp
    mov bp,sp
    
    push bx
    push cx
    push dx
    push si
    sub sp,32
    mov di,sp
    mov byte ptr [di],30
    
    mov ah,0ah
    mov dx,di
    int 21h
    
    mov ch,0
    mov cl,[di+1]
    cmp cx,0
    je conversion_done
    
    mov si,di
    add si,2
    
    xor ax,ax 
conversion_loop:
    mov bx,10
    mul bx
    
    mov bl,[si]
    and bx,00ffh
    sub bl,'0'
    add ax,bx
    
    inc si
    loop conversion_loop
    
conversion_done:

     mov di,[bp+4]
     mov [di],ax
     
     add sp,32
     pop si
     pop dx
     pop cx
     pop bx
     pop bp
     ret 2
input_stack endp    
            
            
            
input_array proc near
    ; --- setup standard stack frame ---
    push bp
    mov bp, sp

    ; --- save registers we will use ---
    push ax
    push bx
    push cx
    push dx
    push si
    push di

   
    mov ah, 0ah
    mov dx, offset input_buffer
    int 21h

     ; --- convert the ascii string to an integer ---
    mov si, offset input_buffer
    mov ch, 0
    mov cl, [si+1]      ; get actual number of characters typed
    cmp cx, 0           ; if user just pressed enter, result is 0
    je .conversion_done2

    add si, 2           ; point si to the start of the actual characters

    xor ax, ax          ; ax will accumulate the final integer result

.conversion_loop2:
    mov bx, 10
    mul bx              ; ax = ax * 10

    mov bl, [si]        ; get the next character digit (e.g., '2')
    sub bl, '0'         ; convert ascii char to numeric value (e.g., '2' -> 2)
    mov bh, 0           ; clear bh, so bx just has the digit value
    add ax, bx          ; add the new digit to our result

    inc si
    loop .conversion_loop2
                         
.conversion_done2:
    ; --- store the result in the memory address passed by the caller ---
    mov di, [bp+4]      ; get destination address (e.g., offset array[i]) from stack
    mov [di], ax        ; store the final result into that address

    ; --- clean up and return ---
              ; deallocate local buffer
    pop di
    pop si
    pop dx
    pop cx
    pop bx
    pop ax
    mov sp,bp 
    pop bp
    ret 2               ; return and clean up the 2-byte parameter from the stack
input_array endp            
            
            
            

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

;// 子过程：计算数组元素之和
;void ArraySum() {
arraysum proc near
    ;// 使用指针遍历数组
      ;push offset array     [bp+6]
    ;push sum                [bp+4]
    push bp
    mov bp,sp
    
    push bx
    push dx
    push cx
     
    ;short *ptr = array;
    ;sum = 0;
    
    ;// 循环次数由数组长度决定
    ;for(int i = 0; i < sizeof(array)/sizeof(array[0]); i++) {  
    mov bx,offset length
    mov cx,[bx]
    mov di,[bp+6]
    ;mov ax,[di]
    mov si,[bp+4] 
    mov dx,si 
   
loop_start:
     mov ax,[di]
     add dx,ax
      
        ;sum += *ptr;  // 累加当前元素
        ;ptr++;        // 移动指针到下一个元素
   
     add di,2   
    loop loop_start  
    mov ax,dx  
  ;  } 
  pop cx
    pop dx
    pop bx
       
 mov sp,bp   
 pop bp
 ret   
;}
arraysum endp 



code ends
end main