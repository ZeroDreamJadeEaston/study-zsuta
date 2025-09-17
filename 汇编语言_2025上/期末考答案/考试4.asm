stack_seg segment stack
    dw 1024 dup(?)      ; ����1024�ֵĶ�ջ�ռ�
stack_seg ends

data_seg segment
    summsg db 'sum of factorials from 1 to 6 is: $'
    result dw ?         ; �洢���ս��
data_seg ends

code_seg segment para 'code'

assume cs:code_seg, ds:data_seg, ss:stack_seg

; ������
main proc far
    ; ��ʼ���μĴ���
    mov ax, data_seg
    mov ds, ax

    ; ����1��6�Ľ׳�֮��
    call calculatefactorialsum

    ; ��������ʾ��Ϣ
    mov ah, 09h
    lea dx, summsg
    int 21h

    ; ���������
    mov bx, result
    call printdecimal

    ; �������
    mov ah, 4ch
    int 21h
main endp

;--------------------------------------------------
; �ݹ����׳˵Ĺ���
; ���룺ax = Ҫ����׳˵���(n)
; �����ax = n�Ľ׳�(n!)
;--------------------------------------------------
factorial proc near
    push cx
    push bx

    cmp ax, 1
    jbe factorialbasecase

    mov cx, ax      ; ���浱ǰ n
    dec ax          ; ax = n - 1
    call factorial  ; �ݹ���� factorial(n-1)
    mov bx, cx
    mul bx          ; ax = ax * n

    jmp factorialend

factorialbasecase:
    mov ax, 1

factorialend:
    pop bx
    pop cx
    ret
factorial endp

;--------------------------------------------------
; ����1��6�Ľ׳�֮�͵Ĺ���
; �����result = 1! + 2! + 3! + 4! + 5! + 6!
;--------------------------------------------------
calculatefactorialsum proc near
    push cx
    push ax
    push dx

    mov result, 0      ; ��ʼ�� result = 0

    mov cx, 1          ; ��1��ʼ
calcloop:
    mov ax, cx         ; ax = ��ǰ n
    call factorial     ; ���� n!
    add result, ax     ; result += n!
    inc cx
    cmp cx, 7          ; �Ƿ���㵽6��
    jnz calcloop

    pop dx
    pop ax
    pop cx
    ret
calculatefactorialsum endp

;--------------------------------------------------
; ���ʮ�������Ĺ���
; ���룺bx = Ҫ���������
;--------------------------------------------------
printdecimal proc near
    push ax
    push bx
    push cx
    push dx

    xor cx, cx         ; λ������
    mov ax, bx         ; ��������ŵ� ax
    mov bx, 10         ; ���� = 10

divideloop:
    xor dx, dx
    div bx             ; ax / 10������ -> dx
    push dx            ; ������ѹջ
    inc cx             ; λ�� +1
    cmp ax, 0
    jne divideloop

printloop:
    pop dx
    add dl, '0'
    mov ah, 02h
    int 21h
    loop printloop

    pop dx
    pop cx
    pop bx
    pop ax
    ret
printdecimal endp

code_seg ends
end main
