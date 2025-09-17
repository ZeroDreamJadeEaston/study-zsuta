; multi-segment executable file template.

data segment
    tip_input db "Please enter the number of disks for the Hanoi Tower:$"
    error_data db "Error: The number of disks must be greater than 0.",13,10,0
    main_str1 db 13,10,"Hanoi Tower Solution (%d disks):",13,10,0
    main_str2 db "==========================",13,10,"$" 
    
    pkey db 13,10,"press any key...$"
    constant_string1 db "Move disk %d from %c to %c",13,10,0 
    main_str3 db "Total moves:  $"
    
data ends

stack segment
    dw   128  dup(0)
stack ends

code segment
    assume cs:code,ds:data,ss:stack
main proc far
; set segment registers:
    mov ax, data
    mov ds, ax
    mov ax,code
    mov ax,stack
    mov ss,ax
    mov sp,128
;#include <stdio.h>
;int main() {
    mov ah,9  
    mov dx,offset tip_input
    int 21h
    ;printf("Please enter the number of disks for the Hanoi Tower:");
    mov bx,0  
    ;int n;
    ;scanf("%d", &n);  
xor bx, bx

input_loop:
    mov ah, 1         ; AH=1: 读取一个字符（阻塞式）
    int 21h
    cmp al, 13        ; 判断是否为回车（Enter 键）
    je input_done     ; 若是，输入完成

    cmp al, '0'
    jb  input_loop    ; 小于 '0'，非法，忽略
    cmp al, '9'
    ja  input_loop    ; 大于 '9'，非法，忽略

    sub al, '0'       ; 字符转数值（0~9）
    xor ah, ah        ; 清高位，AL → AX
    push ax
    mov ax,bx
    ; BX = BX * 10 + AX
    mov cx, 10
    mul cx
    pop bx            ; AX = AX * 10
    add ax,bx
    mov bx,ax
    jmp input_loop

input_done:
    cmp bx,1
    jge step_entrance

    ;// 验证输入有效性
    ;if (n < 1) {  
     mov ah,9
     mov dx,offset error_data
     int 21h
     mov ax,4c01h
     int 21h
      
        ;printf("Error: The number of disks must be greater than 0.\n");
       ;return 1;
   ;}
step_entrance:
    ;printf("\nHanoi Tower Solution (%d disks):\n", n);
    push bx
    push offset main_str1 
    call printf2
    add sp,4
    ;printf("==========================\n"); 
    mov ah,9
    mov dx, offset main_str2
    int 21h
    

    ;// 调用递归函数
    ;// A: 起始柱, C: 目标柱, B: 辅助柱 
    ;short count=hanoi(n, 'A', 'C', 'B');
     
     mov ax,'B'
     push ax
     mov ax,'C'
     push ax
     mov ax,'A'
     push ax
     push bx
     call hanoi
     add sp,8
     mov bx,ax
     
    
    ;printf("==========================\n"); 
     mov ah,9
    mov dx, offset main_str2
    int 21h
	;printf("Total moves: %d\n",count );   
	mov ah,9
    mov dx, offset main_str3
    int 21h
     mov ax, bx        ; 把 BX 的数值传给 AX，AX 是 print_unsigned 的输入
     call print_unsigned

    ;return 0;
;}  

exit_program:     
     mov ah, 9
    mov dx, offset pkey
    int 21h

    mov ah, 1
    int 21h

    mov ax, 4C00h
    int 21h
main endp


;// 汉诺塔递归函数
;short hanoi(short n, char from, char to, char aux) { 
hanoi proc near
    ;// 基准情况：只有一个盘子时直接移动 
    ;建议栈帧
    push bp
    mov bp,sp
    sub sp,2 ;栈中留出局部变量空间 
    ;寄存器保存
    push ax
    push bx
    push cx
    push dx
    
    
    cmp word ptr [bp+4],1
    jne disk_number_greater_than_1
        ;if (n == 1) {
         push word ptr [bp+8]
         push word ptr [bp+6]
         push word ptr [bp+4]
         mov ax,offset constant_string1
         push ax
         call printf2 
         ;清栈，释放参数空间
         add sp,8
         
        ;printf("Move disk %d from %c to %c\n", n, from, to);
        ;return 1;返回main,返回值=1
         mov ax,1 
         
         pop dx
         pop cx
          pop bx
         pop ax
         mov sp,bp
         pop bp
         ret
   ; }
disk_number_greater_than_1:

	;short count;
   ; // 递归步骤1：将n-1个盘子从起始柱移动到辅助柱
    ;count=hanoi(n - 1, from, aux, to);
     push word ptr [bp+8]
     push word ptr [bp+10]
     push word ptr [bp+6]
     mov ax,[bp+4]
     dec ax
     push ax
     call hanoi
     add sp,8
     mov word ptr [bp-2],ax
     
     
    ;// 移动第n个盘子（最大的盘子）
    ;printf("Move disk %d from %c to %c\n", n, from, to);  
    push word ptr [bp+8]
         push word ptr [bp+6]
         push word ptr [bp+4]
         mov ax,offset constant_string1
         push ax
         call printf2 
         ;清栈，释放参数空间
         add sp,8 
     inc word ptr [bp-2]
    ;count++;

    ;// 递归步骤2：将n-1个盘子从辅助柱移动到目标柱
    push word ptr [bp+6]
    push word ptr [bp+8]
    push word ptr [bp+10]
    mov ax,[bp+4]
    dec ax
    push ax
    call hanoi
    add sp,8 
    add word ptr [bp-2],ax
    ;count+=hanoi(n - 1, aux, to, from);   
    
    ;return count;  
        mov ax, word ptr [bp-2]
     pop dx
    pop cx
    pop bx                   ; 把 SI 的值（总步数）放入 AX 作为返回值
    ;pop ax
    mov sp, bp
    pop bp
    ret

;}
hanoi endp 
printf2 proc near
    push bp
    mov bp, sp
    sub sp, 2               ; <<< 为局部变量"参数指针"开辟空间 [bp-2]
    push di
    push bx                 ; (DI在这里实际没用了，但保留是好习惯)

    mov si, [bp+4]          ; SI <- 格式字符串地址, 这部分不变
    mov word ptr [bp-2], 6  ; <<< 初始化"参数指针", 指向第一个额外参数(n)的偏移量

next_char:
    mov al, [si]
    cmp al, 0
    je done_printf

    cmp al, '%'
    jne print_normal_char

    ; 是 '%' -> 检查格式类型
    inc si
    mov al, [si]
    cmp al, 'd'
    je output_integer
    cmp al, 'c'
    je output_char
    jmp continue_loop      ; 如果是 %% 或其他不支持的，直接跳过

output_integer:
    
    mov bx, [bp-2]          ; 1. 将"参数指针"的当前偏移量(比如6)加载到 bx
    mov di,bx         ; 2.  从栈上正确地取出参数值
    mov ax,[bp+di]
    
    push ax                 ; (暂存ax,因为print_unsigned会修改它)
    call print_unsigned
    pop ax

    add word ptr [bp-2], 2  ; 3. 将"参数指针"向前移动2字节,指向下一个参数
    jmp continue_loop

output_char:
 
    mov bx, [bp-2]          ; 1. 获取当前参数的偏移量
    mov di,bx
    mov dl, byte ptr [bp+di] ; 2. 从栈上正确地取出参数(字节)
    mov ah, 2
    int 21h

    add word ptr [bp-2], 2  ; 3. "参数指针"前移
    jmp continue_loop

print_normal_char:
    mov dl, al
    mov ah, 2
    int 21h
    jmp continue_loop

continue_loop:
    inc si
    jmp next_char

done_printf: 
    pop bx
    pop di
    pop si
    mov sp, bp      ; 恢复sp, 回收局部变量空间
    pop bp
    ret
printf2 endp
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
end main ; set entry point and stop the assembler.
