;#include <stdio.h>
data segment
;// ����ȫ�ֱ���
;short array[] = {10, 20, 30, 40, 50};  // word��������
array dw 10,20,30,40,50
length dw 5
output db "Sum: $"
;short sum;                            // �洢��ͽ��
sum dw 0  
key db 13,10,"press any key...$"

data ends
stack segment
    
stack ends
dw   128  dup(0)
code segment
assume cs:code,ds:data
   
                 
              
 ;  // ������
;int main() {
main proc far 
     mov ax,data
    mov ds,ax
    mov ax,stack
    mov ss,ax
    mov sp,128
    ;// �����ӹ���
    ;ArraySum();
    push offset array
    push sum
    call arraysum
    add sp,4
    mov bx,ax
    
    ;// ����������
    ;printf("Sum: %d\n", sum);
    
    mov ah,9
    mov dx,offset output
    int 21h
    
    mov ax,bx
    call print_unsigned
    add sp,2
    
    mov ah,9
    mov dx,offset key
    int 21h
    
    mov ah,1
    int 21h
    
    ;return 0;
    mov ax,4c00h
    int 21h
;}   
main endp
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

;// �ӹ��̣���������Ԫ��֮��
;void ArraySum() {
arraysum proc near
    ;// ʹ��ָ���������
      ;push offset array     [bp+6]
    ;push sum                [bp+4]
    push bp
    mov bp,sp
    
    push bx
    push dx
    push cx
     
    ;short *ptr = array;
    ;sum = 0;
    
    ;// ѭ�����������鳤�Ⱦ���
    ;for(int i = 0; i < sizeof(array)/sizeof(array[0]); i++) {  
    mov bx,offset length
    mov cx,[bx]
    mov di,[bp+6]
    ;mov ax,[di]
    mov si,[bp+4] 
    mov dx,si 
   
loop_start:
     mov ax,[di]
     add dx,ax
      
        ;sum += *ptr;  // �ۼӵ�ǰԪ��
        ;ptr++;        // �ƶ�ָ�뵽��һ��Ԫ��
   
     add di,2   
    loop loop_start  
    mov ax,dx  
  ;  } 
  pop cx
    pop dx
    pop bx
       
 mov sp,bp   
 pop bp
 ret   
;}
arraysum endp 



code ends
end main