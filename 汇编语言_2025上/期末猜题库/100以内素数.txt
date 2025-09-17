data segment
     prompt  db 13,10,"press any key to continue...$"     
     output_key db "Plese output the prime numbers between 0 and 100:$"
     
data ends
stack segment
    dw 128 dup(0)
stack ends 
 
code segment
      assume cs:code,ds:data
    
      
main proc far  
      mov ax,data
      mov ds,ax 
      mov ax,stack
      mov ss,ax
      mov sp,128
      
                    
     mov ah,9
     mov dx,offset output_key
     int 21h
     
     ;换行
     mov ah,2
    mov dl,13
    int 21h
    mov dl,10
    int 21h               
                    
                    
      mov bx,2
loop_entrance: 
      cmp bx,100 
      ja loop_exit
      mov si,2
      mov ax,bx 
      mov dx,0  
      ;错误，div不支持立即数
      mov di,2
      ;div 2       ;ax商，dx余数
      div di   
      mov cx,ax
loop2_entrance: 
      cmp si,cx
      ja loop3_entrance
      ;mov ax,cx      错误，是num与si进行取余
      mov ax,bx
      mov dx,0
      div si
      cmp dx,0
      je loop3_entrance
      inc si
      jmp loop2_entrance
loop3_entrance:
      cmp si,cx
      jna loop3_exit
      mov ax, bx 
       call print_unsigned
       mov ah,2
       mov dl,' '
       int 21h
           

       
loop3_exit:   
       mov dl,0
       inc bx           
       jmp loop_entrance     ;总循环一定要加
loop_exit:
  
mov ah,9 
mov dx,offset prompt
int 21h
mov ah,1
int 21h

mov ax,4c00h
int 21h       
      
main endp 


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