data segment
    prime_msg      db 13, 10, "It's a prime.$"
    not_prime_msg  db 13, 10, "It's not a prime.$" 
    prompt         db "press any key to continue...$"   
data ends

code segment
    assume cs:code, ds:data
;#include <stdio.h>
;int main() { 
main proc far
    mov ax, data
    mov ds, ax ; 设置数据段寄存器 ds 为 data 段地址   

    ; unsigned int n;
    ; unsigned int i;
    ; int is_prime = 1;
    mov cx, 1           ; CX = is_prime 标志变量

    ; 输入十进制整数
    xor bx, bx          ; BX ← 输入结果，初始为 0
input_loop:
    mov ah, 1
    int 21h             ; 读取字符到 AL
    cmp al, 13          ; 回车？结束输入
    je  input_done

    cmp al, '0'
    jb  input_loop
    cmp al, '9'
    ja  input_loop

    sub al, '0'
    xor ah, ah          ; AL → AX
    push ax
    mov ax,bx
    mov si, 10
    mul si
    pop bx              ; AX = digit * 10
    add bx, ax          ; BX = BX * 10 + digit
    jmp input_loop

input_done:
    mov si, 2           ; SI = i = 2 每次判断前初始化
    cmp bx, 1
    jbe s1              ; 若 n <= 1，不是素数
    jmp loop_start

s1:
    mov cx, 0           ; CX = 0 表示不是素数
    jmp s3

; for (i = 2; i*i <= n; i++)
loop_start:
    mov ax, si
    mul si              ; AX = i * i
    cmp ax, bx
    ja  s3              ; i*i > n → 跳出循环

    mov ax, bx
    xor dx, dx          ; 清除除法高位
    div si              ; AX / SI，余数在 DX

    cmp dx, 0
    jne not_divisible

    ; n % i == 0 → 非素数
    mov cx, 0
    jmp s3

not_divisible:
    inc si
    jmp loop_start

s3:
    cmp cx, 1
    jne not_prime

    ; 输出：It's a prime.
    mov ah, 9
    mov dx, offset prime_msg
    int 21h
    jmp program_exit

not_prime:
    ; 输出：It's not a prime.
    mov ah, 9
    mov dx, offset not_prime_msg
    int 21h
    
    
      ;换行
    mov ah,2
    mov dl,13
    int 21h
    mov dl,10
    int 21h 
    ; 提示并等待按键
    mov ah, 9
    mov dx, offset prompt
    int 21h
    mov ah, 1
    int 21h
    mov ah, 4ch
    mov al, 0
    int 21h

program_exit:
   ;换行
    mov ah,2
    mov dl,13
    int 21h
    mov dl,10
    int 21h 
    ; 提示并等待按键
    mov ah, 9
    mov dx, offset prompt
    int 21h 
      mov ah,1
    int 21h
    mov ah, 4ch
    int 21h
main endp
code ends
end main
