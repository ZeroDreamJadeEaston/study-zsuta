; 程序功能是显示字符串 "hello world."
data SEGMENT    ; 定义数据段 
    ; 定义变量 message和pkey
    message DB "hello world.",0dh,0ah,"$"
    pkey DB "press any key...$"
data ENDS
stack SEGMENT stack   ; 定义堆栈段
    DW   128  dup(0)
stack ENDS
code SEGMENT   ; 定义代码段
    assume CS:code,DS:data,SS:stack   ;关联段寄存器和段名
start:
    ; data段名表示该段的段地址，赋值给数据段寄存器DS
    MOV AX, data
    MOV DS, AX
    ; 利用21H中断的9号功能，输出字符串message
    LEA DX, message
    MOV AH, 9
    INT 21h
    ; 利用21H中断的9号功能，输出字符串pkey        
    LEA DX, pkey
    MOV AH, 9
    INT 21h  
    ; 利用21H中断的1号功能，从键盘读取一个字符  
    MOV AH, 1
    INT 21h
    ; 利用21H中断的4CH号功能，结束程序运行并返回操作系统
    MOV AL, 0
    MOV AH, 4ch 
    INT 21h    
code ENDS
END start ; END伪指令指明此为源程序末尾，并指定程序入口是start标号