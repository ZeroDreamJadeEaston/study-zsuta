; ����������ʾ�ַ��� "hello world."
data SEGMENT    ; �������ݶ� 
    ; ������� message��pkey
    message DB "hello world.",0dh,0ah,"$"
    pkey DB "press any key...$"
data ENDS
stack SEGMENT stack   ; �����ջ��
    DW   128  dup(0)
stack ENDS
code SEGMENT   ; ��������
    assume CS:code,DS:data,SS:stack   ;�����μĴ����Ͷ���
start:
    ; data������ʾ�öεĶε�ַ����ֵ�����ݶμĴ���DS
    MOV AX, data
    MOV DS, AX
    ; ����21H�жϵ�9�Ź��ܣ�����ַ���message
    LEA DX, message
    MOV AH, 9
    INT 21h
    ; ����21H�жϵ�9�Ź��ܣ�����ַ���pkey        
    LEA DX, pkey
    MOV AH, 9
    INT 21h  
    ; ����21H�жϵ�1�Ź��ܣ��Ӽ��̶�ȡһ���ַ�  
    MOV AH, 1
    INT 21h
    ; ����21H�жϵ�4CH�Ź��ܣ������������в����ز���ϵͳ
    MOV AL, 0
    MOV AH, 4ch 
    INT 21h    
code ENDS
END start ; ENDαָ��ָ����ΪԴ����ĩβ����ָ�����������start���