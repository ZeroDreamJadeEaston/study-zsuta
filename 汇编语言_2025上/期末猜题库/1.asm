; multi-segment executable file template.
MAX_SIZE=50        ;汇编里=:伪命令   

data segment        ;数据段
    ; add your data here! 全局变量    
    
    prime dw MAX_SIZE dup(0) ;?代表随机值： prime dw ?  ;short prime[MAX_SIZE] = {0};
    count dw 0               ;short count = 0
    pkey db "press any key...$"
data ends

stack segment        ;堆栈段
    dw   128  dup(0)
stack ends

code segment            ;代码段
start:                   
; set segment registers:
    mov ax, data
    mov ds, ax
    mov es, ax

    ; add your code here
    mov si ,0     
    mov bx ,2;short num = 2 
outer_loop_entrance:
    cmp bx ,100   ;while (num <= 100)
    jg  outer_loop_exit
    mov cx,2      ;short i = 2  
    mov di,bx
    sar di,1      ;num_2 = num_2/2相当于算术右移一位
inner_loop_entrance:
    cmp cx,di     ;while (i <= num_2)
    jg inner_loop_exit     ;jump  
    ;if (num % i == 0)  bx % cx
    mov ax,bx
    cwd                 ;扩展
    idiv cx             ;ax=商，dx=余数
    cmp dx,0
    jne i_plus1
    ;break
    jmp inner_loop_exit  
i_plus1:
    ;i++
    inc cx 
    jmp inner_loop_entrance
inner_loop_exit:
    cmp cx,di
    jng num_plus1
    ;
    mov prime[si],bx  
    add si,2 
    ;count++
    inc count
num_plus1:
    ;num++
    inc bx
    jmp outer_loop_entrance  
    
outer_loop_exit:          
    lea dx, pkey    ;print("%s",pkey)
    mov ah, 9
    int 21h        ; output string at ds:dx
    
    ; wait for any key....    
    mov ah, 1
    int 21h
    
    mov ax, 4c00h ; exit to operating system.      retuen 0
    int 21h    
code ends

end start ; set entry point and stop the assembler.