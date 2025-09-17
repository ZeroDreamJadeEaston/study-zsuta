data segment
data ends

stack segment
stack ends

code segment
assume ds:data, ss:stack, cs:code

start:
    mov ax, data
    mov ds, ax
    
    call find        ; 调用主逻辑过程
    
    mov ah, 4ch      ; 程序退出
    int 21h

find proc
    mov cx, 2        ; 从2开始检查
    
check_num:
    cmp cx, 100      ; 检查是否超过100
    ja  exit         ; 超过则退出
    
    mov bl, 2        ; 除数从2开始
    
    ; 单独处理2（最小素数）
    cmp cx, 2
    je print_prime   ; 如果是2，直接打印
    
check_divisor:
    mov ax, cx       ; 被除数放入ax
    xor dx, dx       ; 清空dx高位，避免div溢出
    div bl           ; ax/bl，商在al，余数在ah
    
    cmp ah, 0        ; 发现因数则不是素数
    je next_num      ; 非素数，跳到下一个数
    
    inc bl           ; 增加除数
    mov al, bl       ; 判断是否超过sqrt(cx)
    mul al           ; AX = BL*BL
    cmp ax, cx       ; 只需检查到sqrt(n)
    jbe check_divisor
    
print_prime:
    ; 十位和个位转换
    mov ax, cx       ; 将当前素数加载到ax
    mov bl, 10       ; 除以10
    div bl           ; 商在al，余数在ah
    
    add al, 30h      ; 十位转ASCII
    add ah, 30h      ; 个位转ASCII
    mov dh, ah       ; 保存个位到DH

    ; 输出十位
    mov dl, al       ; 十位存入DL
    mov ah, 02h      ; DOS中断输出字符
    int 21h          ; 输出十位
    
    ; 输出个位
    mov dl, dh       ; 从DH恢复个位
    int 21h          ; 输出个位
    
    ; 输出空格分隔
    mov dl, ' '      ; 空格字符
    int 21h          ; 输出空格
    
next_num:
    inc cx           ; 检查下一个数
    jmp check_num
    
exit:
    ret              ; 返回
find endp

code ends
end start
