; multi-segment executable file template.

data segment
    tip_input db "Please enter the number of disks for the Hanoi Tower:$"
    error_data db "Error: The number of disks must be greater than 0.",13,10,0
    main_str1 db 13,10,"Hanoi Tower Solution (%d disks):",13,10,0
    main_str2 db "==========================",13,10,"$" 
    
    pkey db 13,10,"press any key...$"
    constant_string1 db "Move disk %d from %c to %c",13,10,0 
    main_str3 db "Total moves:  $"
    
data ends

stack segment
    dw   128  dup(0)
stack ends

code segment
    assume cs:code,ds:data,ss:stack
main proc far
; set segment registers:
    mov ax, data
    mov ds, ax
    mov ax,code
    mov ax,stack
    mov ss,ax
    mov sp,128
;#include <stdio.h>
;int main() {
    mov ah,9  
    mov dx,offset tip_input
    int 21h
    ;printf("Please enter the number of disks for the Hanoi Tower:");
    mov bx,0  
    ;int n;
    ;scanf("%d", &n);  
xor bx, bx

input_loop:
    mov ah, 1         ; AH=1: ��ȡһ���ַ�������ʽ��
    int 21h
    cmp al, 13        ; �ж��Ƿ�Ϊ�س���Enter ����
    je input_done     ; ���ǣ��������

    cmp al, '0'
    jb  input_loop    ; С�� '0'���Ƿ�������
    cmp al, '9'
    ja  input_loop    ; ���� '9'���Ƿ�������

    sub al, '0'       ; �ַ�ת��ֵ��0~9��
    xor ah, ah        ; ���λ��AL �� AX
    push ax
    mov ax,bx
    ; BX = BX * 10 + AX
    mov cx, 10
    mul cx
    pop bx            ; AX = AX * 10
    add ax,bx
    mov bx,ax
    jmp input_loop

input_done:
    cmp bx,1
    jge step_entrance

    ;// ��֤������Ч��
    ;if (n < 1) {  
     mov ah,9
     mov dx,offset error_data
     int 21h
     mov ax,4c01h
     int 21h
      
        ;printf("Error: The number of disks must be greater than 0.\n");
       ;return 1;
   ;}
step_entrance:
    ;printf("\nHanoi Tower Solution (%d disks):\n", n);
    push bx
    push offset main_str1 
    call printf2
    add sp,4
    ;printf("==========================\n"); 
    mov ah,9
    mov dx, offset main_str2
    int 21h
    

    ;// ���õݹ麯��
    ;// A: ��ʼ��, C: Ŀ����, B: ������ 
    ;short count=hanoi(n, 'A', 'C', 'B');
     
     mov ax,'B'
     push ax
     mov ax,'C'
     push ax
     mov ax,'A'
     push ax
     push bx
     call hanoi
     add sp,8
     mov bx,ax
     
    
    ;printf("==========================\n"); 
     mov ah,9
    mov dx, offset main_str2
    int 21h
	;printf("Total moves: %d\n",count );   
	mov ah,9
    mov dx, offset main_str3
    int 21h
     mov ax, bx        ; �� BX ����ֵ���� AX��AX �� print_unsigned ������
     call print_unsigned

    ;return 0;
;}  

exit_program:     
     mov ah, 9
    mov dx, offset pkey
    int 21h

    mov ah, 1
    int 21h

    mov ax, 4C00h
    int 21h
main endp


;// ��ŵ���ݹ麯��
;short hanoi(short n, char from, char to, char aux) { 
hanoi proc near
    ;// ��׼�����ֻ��һ������ʱֱ���ƶ� 
    ;����ջ֡
    push bp
    mov bp,sp
    sub sp,2 ;ջ�������ֲ������ռ� 
    ;�Ĵ�������
    push ax
    push bx
    push cx
    push dx
    
    
    cmp word ptr [bp+4],1
    jne disk_number_greater_than_1
        ;if (n == 1) {
         push word ptr [bp+8]
         push word ptr [bp+6]
         push word ptr [bp+4]
         mov ax,offset constant_string1
         push ax
         call printf2 
         ;��ջ���ͷŲ����ռ�
         add sp,8
         
        ;printf("Move disk %d from %c to %c\n", n, from, to);
        ;return 1;����main,����ֵ=1
         mov ax,1 
         
         pop dx
         pop cx
          pop bx
         pop ax
         mov sp,bp
         pop bp
         ret
   ; }
disk_number_greater_than_1:

	;short count;
   ; // �ݹ鲽��1����n-1�����Ӵ���ʼ���ƶ���������
    ;count=hanoi(n - 1, from, aux, to);
     push word ptr [bp+8]
     push word ptr [bp+10]
     push word ptr [bp+6]
     mov ax,[bp+4]
     dec ax
     push ax
     call hanoi
     add sp,8
     mov word ptr [bp-2],ax
     
     
    ;// �ƶ���n�����ӣ��������ӣ�
    ;printf("Move disk %d from %c to %c\n", n, from, to);  
    push word ptr [bp+8]
         push word ptr [bp+6]
         push word ptr [bp+4]
         mov ax,offset constant_string1
         push ax
         call printf2 
         ;��ջ���ͷŲ����ռ�
         add sp,8 
     inc word ptr [bp-2]
    ;count++;

    ;// �ݹ鲽��2����n-1�����ӴӸ������ƶ���Ŀ����
    push word ptr [bp+6]
    push word ptr [bp+8]
    push word ptr [bp+10]
    mov ax,[bp+4]
    dec ax
    push ax
    call hanoi
    add sp,8 
    add word ptr [bp-2],ax
    ;count+=hanoi(n - 1, aux, to, from);   
    
    ;return count;  
        mov ax, word ptr [bp-2]
     pop dx
    pop cx
    pop bx                   ; �� SI ��ֵ���ܲ��������� AX ��Ϊ����ֵ
    ;pop ax
    mov sp, bp
    pop bp
    ret

;}
hanoi endp 
printf2 proc near
    push bp
    mov bp, sp
    sub sp, 2               ; <<< Ϊ�ֲ�����"����ָ��"���ٿռ� [bp-2]
    push di
    push bx                 ; (DI������ʵ��û���ˣ��������Ǻ�ϰ��)

    mov si, [bp+4]          ; SI <- ��ʽ�ַ�����ַ, �ⲿ�ֲ���
    mov word ptr [bp-2], 6  ; <<< ��ʼ��"����ָ��", ָ���һ���������(n)��ƫ����

next_char:
    mov al, [si]
    cmp al, 0
    je done_printf

    cmp al, '%'
    jne print_normal_char

    ; �� '%' -> ����ʽ����
    inc si
    mov al, [si]
    cmp al, 'd'
    je output_integer
    cmp al, 'c'
    je output_char
    jmp continue_loop      ; ����� %% ��������֧�ֵģ�ֱ������

output_integer:
    
    mov bx, [bp-2]          ; 1. ��"����ָ��"�ĵ�ǰƫ����(����6)���ص� bx
    mov di,bx         ; 2.  ��ջ����ȷ��ȡ������ֵ
    mov ax,[bp+di]
    
    push ax                 ; (�ݴ�ax,��Ϊprint_unsigned���޸���)
    call print_unsigned
    pop ax

    add word ptr [bp-2], 2  ; 3. ��"����ָ��"��ǰ�ƶ�2�ֽ�,ָ����һ������
    jmp continue_loop

output_char:
 
    mov bx, [bp-2]          ; 1. ��ȡ��ǰ������ƫ����
    mov di,bx
    mov dl, byte ptr [bp+di] ; 2. ��ջ����ȷ��ȡ������(�ֽ�)
    mov ah, 2
    int 21h

    add word ptr [bp-2], 2  ; 3. "����ָ��"ǰ��
    jmp continue_loop

print_normal_char:
    mov dl, al
    mov ah, 2
    int 21h
    jmp continue_loop

continue_loop:
    inc si
    jmp next_char

done_printf: 
    pop bx
    pop di
    pop si
    mov sp, bp      ; �ָ�sp, ���վֲ������ռ�
    pop bp
    ret
printf2 endp
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
end main ; set entry point and stop the assembler.
