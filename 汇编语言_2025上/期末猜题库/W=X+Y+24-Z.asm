data segment
    input_promptx db 'Please enter a X number (0-65535): $'
    input_prompty db 13,10,'Please enter a Y number (0-65535): $'
    input_promptz db 13,10,'Please enter a Z number (0-65535): $'
    output_prompt db 13,10,'Result (X + Y + 24 - Z): $'

    x_str db 6, 0, 6 dup(0)
    y_str db 6, 0, 6 dup(0)
    z_str db 6, 0, 6 dup(0)
    w_out_str db 7 dup(0)

    x_val dw 0
    y_val dw 0
    z_val dw 0
    w_val dw 0

    prompt db 13,10,"press any key to continue...$"
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

    mov ah, 9
    mov dx, offset input_promptx
    int 21h
    mov dx, offset x_str
    call input_string
    call str_to_word_int
    mov [x_val], ax

    mov ah, 9
    mov dx, offset input_prompty
    int 21h
    mov dx, offset y_str
    call input_string
    call str_to_word_int
    mov [y_val], ax

    mov ah, 9
    mov dx, offset input_promptz
    int 21h
    mov dx, offset z_str
    call input_string
    call str_to_word_int
    mov [z_val], ax

    call calculate_w

    mov ah,9
    mov dx,offset output_prompt
    int 21h

    mov ax, [w_val]
    mov di, offset w_out_str
    call word_int_to_str

    mov dx, offset w_out_str
    call puts

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
    mov ah,0Ah
    int 21h
    pop dx
    pop ax
    ret
input_string endp

puts proc near
    push ax
    push dx
    push si
    mov si, dx
loop_puts:
    mov dl, [si]
    cmp dl, 0
    je  end_puts
    mov ah, 2
    int 21h
    inc si
    jmp loop_puts
end_puts:
    pop si
    pop dx
    pop ax
    ret
puts endp

str_to_word_int proc near
    push bx
    push cx
    push dx
    push si

    mov si, dx
    mov cl, [si + 1]
    mov ch, 0
    add si, 2

    xor ax, ax
    mov bx, 10

convert_loop:
    cmp cl, 0
    je  convert_done
    mul bx
    mov dl, [si]
    sub dl, '0'
    mov dh, 0
    add ax, dx
    inc si
    dec cl
    jmp convert_loop

convert_done:
    pop si
    pop dx
    pop cx
    pop bx
    ret
str_to_word_int endp

calculate_w proc near
    push ax
    push bx

    mov ax, [x_val]
    mov bx, [y_val]
    add ax, bx
    add ax, 24
    mov bx, [z_val]
    sub ax, bx
    mov [w_val], ax

    pop bx
    pop ax
    ret
calculate_w endp

word_int_to_str proc near
    push ax
    push bx
    push cx
    push dx

    xor cx, cx
    mov bx, 10

    cmp ax, 0
    jne convert_loop_str
    push 0
    inc cx
    jmp create_string

convert_loop_str:
    xor dx, dx
    div bx
    push dx
    inc cx
    cmp ax, 0
    jne convert_loop_str

create_string:
    pop dx
    add dl, '0'
    mov [di], dl
    inc di
    loop create_string

    mov byte ptr [di], 0

    pop dx
    pop cx
    pop bx
    pop ax
    ret
word_int_to_str endp

code ends
end main
