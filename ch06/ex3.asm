;
; Ex 3
; 
; Write an assembly language program to compute the average of 4
; grades. Use memory locations for the 4 grades. Make th e grades all
; different numbers from 0 to 100. Store the average of the 4 grades in
; memory and also store the remainder from the division in memory.
;


section .data
    grade1   dd   86
    grade2   dd   52
    grade3   dd   92
    grade4   dd   83


section .bss
    avg   resd   1
    rem   resd   1


section .text

global _start

_start:
    mov eax, [grade1]
    add eax, [grade2]
    add eax, [grade3]
    add eax, [grade4]

    xor edx, edx
    mov ebx, 4
    idiv ebx

    mov [avg], eax
    mov [rem], edx

    nop

