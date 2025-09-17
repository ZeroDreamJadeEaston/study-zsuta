data segment       ;ȫ�ֱ���
  prompt db "press any key to continue...$"
  key db  "Please enter a string: $" 
  str_buffer db 80, db 0, db 80 dup(0)  
  max_str db 80 dup(0) 
  max_length dw 0
    empty_line_msg db 13, 10, "Empty line detected! $"
data ends  
stack segment
    dw 128 dup(0)             
 ends     
code segment 
assume cs:code,ds:data ��ss:stack


;int main() {
main proc far
    mov ax,data
    mov ds,ax
    mov ax,stack
    mov ss,ax
    mov sp,128
   
    
    mov ah,9
    mov dx,offset key
    int 21h 
    
inpus_loop:    
    mov dx,offset str_buffer
    call input_string  
    
    
    ; ���ж��Ƿ����
    call kong_inspect 
    cmp cx, 0 
    je inpus_exit

    ; ���ǿ��У�������������
    mov bx,offset str_buffer+2
    call count 
    mov bx,ax  
    dec bx
    mov di, offset  max_length
    cmp bx,[di]
    jle kong
    mov [di],bx
    mov si, offset str_buffer + 2
    mov di, offset max_str
    call copy_string                         
                             
kong:
   ;����
    mov ah,2
    mov dl,13
    int 21h
    mov dl,10
    int 21h 
    jmp inpus_loop
    

inpus_exit:     
         
        ;����
    mov ah,2
    mov dl,13
    int 21h
    mov dl,10
    int 21h    
     
     mov bx,offset max_str
     call puts 
       ;����
    mov ah,2
    mov dl,13
    int 21h
    mov dl,10
    int 21h 
    
    mov bx,offset  max_length    
     mov ax, [bx] 
       call print_unsigned        
      ;����
    mov ah,2
    mov dl,13
    int 21h
    mov dl,10
    int 21h        
              
              
     mov ah,9
     mov dx,offset prompt
     int 21h
      
      ;return 0;
     mov ah,1
     int 21h
     ;mov ah,4ch
     ;mov al,0
     ;�ȼ���
     mov ax,4c00h
     int 21h 
    
    
;}
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
 
 
count proc near 
 ;����ջ֡
    push bp ;����bp
    mov bp,sp
    
    
    ;unsigned int count = 0;
    sub sp,2 ;ջ�����������ֽڴ�žֲ����� count ��ֵ,[bp-2[�����ڴ��еľֲ�����count
    push dx 
    mov word ptr [bp-2],0   ;ptr����������ʾ���ز�������ַ����
loop_entrance3:
    cmp byte ptr [bx],0
    ;while (*str != '\0') {
    je  loop_exit3
    ;putchar(*str);
    inc bx  
    ;str++;
     ;count++;
    inc word ptr [bp-2]
    jmp loop_entrance3
    ;} 
    
loop_exit3:    
    ;return count;
    mov ax,[bp-2]
    pop dx
    mov sp,bp
    pop bp
    ret
;}

count endp                    
   
kong_inspect proc near
    push ax
    push bx
    
    push si

    mov bx, offset str_buffer
    mov cl, [bx + 1]    ; ��ȡʵ�������ַ���
    mov ch, 0

    cmp cx, 0
    je is_empty_line    ; ֱ�ӿ���

    mov si, bx
    add si, 2           ; SI ָ��������

check_loop:
    cmp cl, 0
    je is_empty_line    ; ȫ�������ȫ�ǿո� �� �����

    mov al, [si]
    cmp al, ' '
    jne not_empty_line  ; ֻҪ�зǿո��ַ����㡰�ǿ��С�

    inc si
    dec cl
    jmp check_loop      ; ���������һ���ַ�

is_empty_line:
    mov ah, 9
    mov dx, offset empty_line_msg
    int 21h

    mov cx, 0           ; �˳�ѭ���ź�
    jmp end_kong_inspect

not_empty_line:
    mov cx, 1           ; ����ѭ���ź�

end_kong_inspect:
    pop si
    pop bx
    pop ax
    ret
kong_inspect endp   
 
 
 copy_string proc near
    push ax    ; �����õ��ļĴ���
    push si
    push di

copy_loop:
    mov al, [si]   ; ȡԴ�ַ�����ǰ�ַ�
    mov [di], al   ; �浽Ŀ���ַ
    cmp al, 0      ; �Ƿ� '\0' ��
    je copy_done   ; �ǵĻ������

    inc si
    inc di
    jmp copy_loop  ; �����������

copy_done:
    pop di
    pop si
    pop ax
    ret
copy_string endp

                

      ;// Puts ����������� '\0' ��β���ַ���
;// ������const char* str��ͨ�� BX ����ַ��
;// ����ֵ������ַ������������� AX �У�
;unsigned int Puts(char* str) {
puts proc near 
     ;����ջ֡
    push bp ;����bp
    mov bp,sp
    
    
    ;unsigned int count = 0;
    sub sp,2 ;ջ�����������ֽڴ�žֲ����� count ��ֵ,[bp-2[�����ڴ��еľֲ�����count
    push dx 
    mov word ptr [bp-2],0   ;ptr����������ʾ���ز�������ַ����
loop_entrance:
    cmp byte ptr [bx],0
    ;while (*str != '\0') {
    je  loop_exit
   mov ah,2
   mov dl,[bx]
    int 21h
    ;putchar(*str);
    inc bx  
    ;str++;
     ;count++;
    inc word ptr [bp-2]
    jmp loop_entrance
    ;} 
    
loop_exit:    
    ;return count;
    mov ax,[bp-2]
    pop dx
    mov sp,bp
    pop bp
    ret
;}
puts endp 
             
print_unsigned proc near
    push bp
    mov bp, sp
    push ax
    push bx
    push dx
    push cx

    xor cx, cx          ; λ��ͳ����
    mov bx, 10          ; ���� = 10

.divide_loop:
    xor dx, dx
    div bx              ; AX �� 10 �� ��AX������DX
    push dx             ; ���������棬����ջ������
    inc cx              ; ͳ��λ��
    cmp ax, 0
    jne .divide_loop

.output_loop:
    pop dx
    add dl, '0'         ; ����ת�ַ�
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
end main

