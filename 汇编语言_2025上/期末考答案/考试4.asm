stack_seg segment stack
    dw 1024 dup(?)      ; 定义1024字的堆栈空间
stack_seg ends

data_seg segment
    summsg db 'sum of factorials from 1 to 6 is: $'
    result dw ?         ; 存储最终结果
data_seg ends

code_seg segment para 'code'

assume cs:code_seg, ds:data_seg, ss:stack_seg

; 主过程
main proc far
    ; 初始化段寄存器
    mov ax, data_seg
    mov ds, ax

    ; 计算1到6的阶乘之和
    call calculatefactorialsum

    ; 输出结果提示信息
    mov ah, 09h
    lea dx, summsg
    int 21h

    ; 输出计算结果
    mov bx, result
    call printdecimal

    ; 程序结束
    mov ah, 4ch
    int 21h
main endp

;--------------------------------------------------
; 递归计算阶乘的过程
; 输入：ax = 要计算阶乘的数(n)
; 输出：ax = n的阶乘(n!)
;--------------------------------------------------
factorial proc near
    push cx
    push bx

    cmp ax, 1
    jbe factorialbasecase

    mov cx, ax      ; 保存当前 n
    dec ax          ; ax = n - 1
    call factorial  ; 递归调用 factorial(n-1)
    mov bx, cx
    mul bx          ; ax = ax * n

    jmp factorialend

factorialbasecase:
    mov ax, 1

factorialend:
    pop bx
    pop cx
    ret
factorial endp

;--------------------------------------------------
; 计算1到6的阶乘之和的过程
; 输出：result = 1! + 2! + 3! + 4! + 5! + 6!
;--------------------------------------------------
calculatefactorialsum proc near
    push cx
    push ax
    push dx

    mov result, 0      ; 初始化 result = 0

    mov cx, 1          ; 从1开始
calcloop:
    mov ax, cx         ; ax = 当前 n
    call factorial     ; 计算 n!
    add result, ax     ; result += n!
    inc cx
    cmp cx, 7          ; 是否计算到6？
    jnz calcloop

    pop dx
    pop ax
    pop cx
    ret
calculatefactorialsum endp

;--------------------------------------------------
; 输出十进制数的过程
; 输入：bx = 要输出的数字
;--------------------------------------------------
printdecimal proc near
    push ax
    push bx
    push cx
    push dx

    xor cx, cx         ; 位数计数
    mov ax, bx         ; 处理的数放到 ax
    mov bx, 10         ; 除数 = 10

divideloop:
    xor dx, dx
    div bx             ; ax / 10，余数 -> dx
    push dx            ; 将余数压栈
    inc cx             ; 位数 +1
    cmp ax, 0
    jne divideloop

printloop:
    pop dx
    add dl, '0'
    mov ah, 02h
    int 21h
    loop printloop

    pop dx
    pop cx
    pop bx
    pop ax
    ret
printdecimal endp

code_seg ends
end main
