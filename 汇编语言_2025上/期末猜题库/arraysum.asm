;#include <stdio.h>
data segment
;// 定义全局变量
;short array[] = {10, 20, 30, 40, 50};  // word类型数组
array dw 10,20,30,40,50
length dw 5
output db "Sum: $"
;short sum;                            // 存储求和结果
sum dw 0  
key db 13,10,"press any key...$"

data ends
stack segment
    
stack ends
dw   128  dup(0)
code segment
assume cs:code,ds:data
   
                 
              
 ;  // 主过程
;int main() {
main proc far 
     mov ax,data
    mov ds,ax
    mov ax,stack
    mov ss,ax
    mov sp,128
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
    add sp,2
    
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