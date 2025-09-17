data segment
    input_prompt db 'Please enter up to 10 decimal digits (ENTER to finish): $'
    output_prompt db 13,10,'Encrypted result: $'
    prompt db "press any key to continue...$"
    BUFFER db 10 dup(0)
    ENCRYPT_TABLE db 7,5,9,1,3,6,8,0,2,4
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

    mov ah, 9
    mov dx, offset input_prompt
    int 21h

    call encrypt_input

    mov cx, ax

    mov ah, 9
    mov dx, offset output_prompt
    int 21h

    mov bx, offset BUFFER
    call puts

    mov ah, 2
    mov dl, 13
    int 21h
    mov dl, 10
    int 21h

    mov ah, 9
    mov dx, offset prompt
    int 21h

    mov ah, 1
    int 21h

    mov ax, 4c00h
    int 21h
main endp

encrypt_input proc near
    push bx
    push cx
    push dx
    push si

    mov cx, 10
    mov si, offset BUFFER

input_loop:
    cmp cx, 0
    je encrypt_done

    mov ah, 1
    int 21h

    cmp al, 13
    je encrypt_done

    cmp al, '0'
    jb input_loop
    cmp al, '9'
    ja input_loop

    sub al, '0'
    mov bx, offset ENCRYPT_TABLE
    xlatb
    mov [si], al

    inc si
    dec cx
    jmp input_loop

encrypt_done:
    mov ax, 10
    sub ax, cx

    pop si
    pop dx
    pop cx
    pop bx
    ret
encrypt_input endp

puts proc near
    push ax
    push bx
    push cx
    push dx

    cmp cx,0
    je loop_exit

print_loop:
    mov ah, 2
    mov dl, [bx]
    add dl, '0'
    int 21h
    inc bx
    loop print_loop

loop_exit:
    pop dx
    pop cx
    pop bx
    pop ax
    ret
puts endp

code ends
end main
