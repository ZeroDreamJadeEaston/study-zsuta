data segment
    input_prompt    db 13,10,'Please enter a binary number (eg:11111111B): $'
    output_prompt   db 13,10,'Decimal result: $'
    error_prompt    db 13,10,'Invalid input. Please use only 0, 1, and an optional B at the end. $'
    input_buffer    db 18, 0, 18 dup(0)
    output_buffer   db 6 dup(0)
    prompt          db 13,10,"Press any key to continue...$"
data ends

stack segment
    dw 128 dup(0)
stack ends

code segment
assume cs:code,ds:data,ss:stack

main proc
    mov ax, data
    mov ds, ax
    mov ax, stack
    mov ss, ax
    mov sp, 128

input_retry_loop:
    mov ah, 9
    mov dx, offset input_prompt
    int 21h

    mov ah, 0Ah
    mov dx, offset input_buffer
    int 21h

    mov ah, 2
    mov dl, 13
    int 21h
    mov dl, 10
    int 21h

    call bin_str_to_ax
    jnc conversion_ok

    mov ah, 9
    mov dx, offset error_prompt
    int 21h
    jmp input_retry_loop

conversion_ok:
    call ax_to_dec_str

    mov ah, 9
    mov dx, offset output_prompt
    int 21h

    mov bx, offset output_buffer
    call puts

    mov ah, 9
    mov dx, offset prompt
    int 21h

    mov ah, 1
    int 21h
    mov ax, 4c00h
    int 21h
main endp

bin_str_to_ax proc near
    push bx
    push cx
    push si
    push di

    mov si, offset input_buffer
    mov cl, [si+1]
    mov ch, 0
    cmp cx, 0
    je invalid_input


    lea di, [si+2+cx-1]
    mov al, [di]
    cmp al, 'B'
    je strip_b_suffix
    cmp al, 'b'
    je strip_b_suffix
    cmp cx, 0
    je validation_loop_start


strip_b_suffix:
    dec cx
    cmp cx, 0
je invalid_input


validation_loop_start:
    xor ax, ax
    lea si, [si+2]

validation_loop:
    mov bl, [si]
    cmp bl, '0'
    jb invalid_input
    cmp bl, '1'
    ja invalid_input

    shl ax, 1
    sub bl, '0'
    or al, bl

    inc si
    loop validation_loop

    clc
    jmp exit_proc

invalid_input:
    stc

exit_proc:
    pop di
    pop si
    pop cx
    pop bx
    ret
bin_str_to_ax endp

ax_to_dec_str proc near
    push ax
    push bx
    push cx
    push dx
    push di

    mov di, offset output_buffer
    mov cx, 0
    mov bx, 10

    cmp ax, 0
    jne push_loop
    mov byte ptr [di], '0'
    inc di
    inc cx
    jmp conversion_done

push_loop:
    xor dx, dx
    div bx
    push dx
    inc cx
    cmp ax, 0
    jne push_loop

pop_loop:
    pop dx
    add dl, '0'
    mov [di], dl
    inc di
    loop pop_loop

conversion_done:
    mov byte ptr [di], 0

    pop di
    pop dx
    pop cx
    pop bx
    pop ax
    ret
ax_to_dec_str endp

puts proc near
    push ax
    push dx

print_char_loop:
    cmp byte ptr [bx], 0
    je  puts_exit
    mov ah, 2
    mov dl, [bx]
    int 21h
    inc bx
    jmp print_char_loop

puts_exit:
    pop dx
    pop ax
    ret
puts endp

code ends
end main
