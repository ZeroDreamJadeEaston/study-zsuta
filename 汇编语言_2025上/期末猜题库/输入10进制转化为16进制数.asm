data segment
    input_prompt db 'Please enter a decimal number: $'
    output_prompt db 13,10,'Hexadecimal result: $'
    str_buffer db 6 dup(0)
    hex_number db 6 dup(0)
    prompt db "press any key to continue...$"
data ends

stack segment
    dw 128 dup(0)
stack ends

code segment
assume cs:code,ds:data,ss:stack

main proc
    mov ax, data
    mov ds, ax
    mov ax,stack
    mov ss,ax
    mov sp,128

    mov byte ptr [str_buffer], 5

    mov ah, 9
    mov dx, offset input_prompt
    int 21h

    mov dx,offset str_buffer
    call input_string

    call dec2hex

    mov ah,9
    mov dx,offset output_prompt
    int 21h

    mov bx, offset hex_number + 2
    call puts

    mov ah,2
    mov dl,13
    int 21h
    mov dl,10
    int 21h

    mov ah,9
    mov dx,offset prompt
    int 21h

    mov ah,1
    int 21h
    mov ax,4c00h
    int 21h
main endp

input_string proc near
    push ax
    push dx
    push bx
    push si

    mov ah,0Ah
    int 21h

    mov bx, dx
    mov cl, [bx + 1]
    mov ch, 0

    add bx, 2
    add bx, cx
    mov byte ptr [bx], 0

    pop si
    pop bx
    pop dx
    pop ax
    ret
input_string endp

puts proc near
    push bp
    mov bp,sp
    sub sp,2
    push dx
    push bx

    mov word ptr [bp-2],0
loop_entrance:
    cmp byte ptr [bx],0
    je  loop_exit
    mov ah,2
    mov dl,[bx]
    int 21h
    inc bx
    inc word ptr [bp-2]
    jmp loop_entrance
loop_exit:
    mov ax,[bp-2]
    pop bx
    pop dx
    mov sp,bp
    pop bp
    ret
puts endp

dec2hex proc near
    push ax
    push bx
    push cx
    push dx
    push si
    push di

    mov si, offset str_buffer + 2
    mov cl, [str_buffer+1]
    mov ch, 0
    xor ax, ax

convert_decimal_loop:
    cmp cx, 0
    je convert_to_hex

    mov bl, [si]
    sub bl, '0'
    mov bx, 10
    mul bx

    mov bh, 0
    mov bl, [si]
    sub bl, '0'
    mov bh, 0
    add ax, bx

    inc si
    dec cx
    jmp convert_decimal_loop

convert_to_hex:
    mov di, offset hex_number + 2
    mov cx, 0

    cmp ax, 0
    jne push_hex_digits_loop
    mov byte ptr [di], '0'
    inc di
    mov byte ptr [di], 'H'
    inc di
    mov byte ptr [di], 0
    mov byte ptr [hex_number+1], 2
    jmp end_dec2hex

push_hex_digits_loop:
    xor dx, dx
    mov bx, 16
    div bx
    push dx
    inc cx
    cmp ax, 0
    jne push_hex_digits_loop

pop_hex_digits:
    pop dx
    cmp dl, 9
    jbe digit_is_num
    add dl, 'A' - 10
    jmp store_digit
digit_is_num:
    add dl, '0'
store_digit:
    mov [di], dl
    inc di
    loop pop_hex_digits

    mov byte ptr [di], 'H'
    inc di
    mov byte ptr [di], 0

    mov bx, di
    sub bx, offset hex_number + 2
    mov [hex_number+1], bl

end_dec2hex:
    pop di
    pop si
    pop dx
    pop cx
    pop bx
    pop ax
    ret
dec2hex endp

code ends
end main
