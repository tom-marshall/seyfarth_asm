;
; Ex 1
;
; Write an assembly program to count all the 1 bits in a
; byte stored in memory. Use repeated code rather than a loop.
;


section .data
    testbyte   db   0x7d
    sum        db   0


section .text

global _start

_start:
    xor edx, edx

    movzx eax, byte [testbyte]

    mov ecx, 7

.loop
    bt eax, ecx

    setc dl
    add [sum], dl

    dec ecx
    jge .loop

    nop

