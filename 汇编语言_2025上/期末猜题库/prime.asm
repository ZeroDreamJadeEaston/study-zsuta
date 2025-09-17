data segment
data ends

stack segment
stack ends

code segment
assume ds:data, ss:stack, cs:code

start:
    mov ax, data
    mov ds, ax
    
    call find        ; �������߼�����
    
    mov ah, 4ch      ; �����˳�
    int 21h

find proc
    mov cx, 2        ; ��2��ʼ���
    
check_num:
    cmp cx, 100      ; ����Ƿ񳬹�100
    ja  exit         ; �������˳�
    
    mov bl, 2        ; ������2��ʼ
    
    ; ��������2����С������
    cmp cx, 2
    je print_prime   ; �����2��ֱ�Ӵ�ӡ
    
check_divisor:
    mov ax, cx       ; ����������ax
    xor dx, dx       ; ���dx��λ������div���
    div bl           ; ax/bl������al��������ah
    
    cmp ah, 0        ; ����������������
    je next_num      ; ��������������һ����
    
    inc bl           ; ���ӳ���
    mov al, bl       ; �ж��Ƿ񳬹�sqrt(cx)
    mul al           ; AX = BL*BL
    cmp ax, cx       ; ֻ���鵽sqrt(n)
    jbe check_divisor
    
print_prime:
    ; ʮλ�͸�λת��
    mov ax, cx       ; ����ǰ�������ص�ax
    mov bl, 10       ; ����10
    div bl           ; ����al��������ah
    
    add al, 30h      ; ʮλתASCII
    add ah, 30h      ; ��λתASCII
    mov dh, ah       ; �����λ��DH

    ; ���ʮλ
    mov dl, al       ; ʮλ����DL
    mov ah, 02h      ; DOS�ж�����ַ�
    int 21h          ; ���ʮλ
    
    ; �����λ
    mov dl, dh       ; ��DH�ָ���λ
    int 21h          ; �����λ
    
    ; ����ո�ָ�
    mov dl, ' '      ; �ո��ַ�
    int 21h          ; ����ո�
    
next_num:
    inc cx           ; �����һ����
    jmp check_num
    
exit:
    ret              ; ����
find endp

code ends
end start
