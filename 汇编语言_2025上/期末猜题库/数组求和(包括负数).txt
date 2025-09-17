data segment
    length dw 0
    array dw 256 dup(0)
    output db "Sum: $"
    key1 db "Please enter the array length: $"
    key db 13,10,"press any key...$"
    key2 db 13,10,"Please enter the elements of the array sequentially: $"
    sum dw 0
    input_buffer db 10, 0, 10 dup(0)
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
    mov dx,offset key1
    int 21h

    call input_signed
    mov [length], ax

    mov ah,9
    mov dx,offset key2
    int 21h

    mov cx, [length]
    mov si, offset array
input_loop:
    call input_signed
    mov [si], ax
    add si, 2
    mov ah, 2
    mov dl, ' '
    int 21h
    loop input_loop

    mov ah,2
    mov dl,13
    int 21h
    mov dl,10
    int 21h

    push offset array
    push [length]
    call arraysum
    add sp, 4
    mov [sum], ax

    mov ah,9
    mov dx,offset output
    int 21h

    mov ax, [sum]
    call print_signed

    mov ah,9
    mov dx,offset key
    int 21h
    mov ah,1
    int 21h

    mov ax,4c00h
    int 21h
main endp

input_signed proc near
    push bx
    push cx
    push dx
    push si

    mov ah, 0Ah
    mov dx, offset input_buffer
    int 21h

    mov ah,2
    mov dl,13
    int 21h
    mov dl,10
    int 21h

    xor ax, ax
    xor cx, cx
    mov si, offset input_buffer + 2
    mov cl, [input_buffer + 1]
    jcxz conversion_done

    mov bl, 1
    cmp byte ptr [si], '-'
    jne start_conversion
    mov bl, -1
    inc si
    dec cl

start_conversion:
    xor dx, dx
conversion_loop:
    mov ch, 0
    mov ch, [si]
    sub ch, '0'
    mov ax, dx
    mov dl, 10
    mul dl
    add al, ch
    mov dx, ax
    inc si
    dec cl
    jnz conversion_loop

    mov ax, dx
    cmp bl, -1
    jne conversion_done
    neg ax

conversion_done:
    pop si
    pop dx
    pop cx
    pop bx
    ret
input_signed endp

print_signed proc near
    push ax
    push bx
    push dx
    push cx

    cmp ax, 0
    jge print_positive
    push ax
    mov ah, 2
    mov dl, '-'
    int 21h
    pop ax
    neg ax

print_positive:
    xor cx, cx
    mov bx, 10
divide_loop:
    xor dx, dx
    div bx
    push dx
    inc cx
    cmp ax, 0
    jne divide_loop

output_loop:
    pop dx
    add dl, '0'
    mov ah, 2
    int 21h
    loop output_loop

    pop cx
    pop dx
    pop bx
    pop ax
    ret
print_signed endp

arraysum proc near
    push bp
    mov bp, sp
    push bx
    push cx
    push si
    push dx

    mov si, [bp+6]
    mov cx, [bp+4]
    xor ax, ax

sum_loop:
    add ax, [si]
    add si, 2
    loop sum_loop

    pop dx
    pop si
    pop cx
    pop bx
    mov sp, bp
    pop bp
    ret
arraysum endp

code ends
end main
