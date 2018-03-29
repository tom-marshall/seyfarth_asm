;
; Ex 4
;
; Write an assembly language program to compute the cost of elec-
; tricity for a home. The cost per kilowatt hour will be an integer
; number of pennies stored in a memory location. The kilowatt hours
; used will also be an integer stored in memory. The bill amount will
; be $5.00 plus the cost per kilowatt hour times the number of kilo-
; watt hours over 1000. You can use a conditional move to set the
; number of hours over 1000· to 0 if the number of hours over 1000
; is negative. Move the number of dollars into one memory location
; and the number of pennies into another.


section .bss
    dollars   resd   1
    cents     resd   1


section .rodata
    base   dd   500
    cpkh   dd   50
    kwh    dd   1257


section .text

global _start

_start:
    mov rax, [kwh]

    mov rbx, 0
    sub rax, 1000
    cmovl rax, rbx

    mul dword [cpkh]
    add eax, [base]

    mov ebx, 100
    idiv ebx

    mov [dollars], eax
    mov [cents], edx

    nop

