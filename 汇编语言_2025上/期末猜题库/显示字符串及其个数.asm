data segment       ;ȫ�ֱ���
  prompt db "press any key to continue...$"
  key db  "Please enter a string: $" 
  str_buffer db 80, db 0, db 80 dup(0)

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
    
    mov dx,offset str_buffer
    call input_string  
    
    
    
    
    
    
    ;����
    mov ah,2
    mov dl,13
    int 21h
    mov dl,10
    int 21h
     
     
     mov bx,offset str_buffer+2
     call puts 
     
     mov bx,ax  
    
     mov ah,2
    
    
     mov dl,13
     int 21h
     mov dl,10
     int 21h
     
     
     dec bx        
     mov ax, bx 
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

