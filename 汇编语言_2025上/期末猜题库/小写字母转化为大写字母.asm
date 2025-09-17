data segment
    input_prompt db 'Please enter a decimal number: $'
    output_prompt db 13,10,'Hexadecimal result: $'
    str_buffer db 60 dup(0)
    capital_str db 60 dup(0)
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
   
   
   
    mov byte ptr [str_buffer], 50

    mov ah, 9
    mov dx, offset input_prompt
    int 21h
    
    ;ÊäÈë×Ö·û´®
    mov dx,offset str_buffer
    call input_string

     call toupper_string  

    mov ah,9
    mov dx,offset output_prompt
    int 21h
    
    ;Êä³ö×Ö·û´®
    mov bx, offset capital_str + 2
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



toupper_string proc near
    push ax
    push si
    push di

    mov si, offset str_buffer + 2    ; Ô´×Ö·û´®
    mov di, offset capital_str + 2   ; Ä¿±ê×Ö·û´®

copy_loop:
    mov al, [si]
    cmp al, 0
    je end_copy

    cmp al, 'a'
    jb no_convert
    cmp al, 'z'
    ja no_convert

    sub al, 32   ; ×ª³É´óÐ´

no_convert:
    mov [di], al

    inc si
    inc di
    jmp copy_loop

end_copy:
    mov byte ptr [di], 0  ; ½áÊø·û

    pop di
    pop si
    pop ax
    ret
toupper_string endp



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

code ends
end main