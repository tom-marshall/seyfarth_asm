;
; Ex 3
;
; Write an assembly program to move a quad-word stored in memory
; into a register and then compute the exclusive-or of the 8 bytes
; of the word. Use either ror or rol to manipulate the bits of the
; register so that the original value is retained.


section .data
    num   dq   0x1127FE69A3FAC515

section .text

global _start

_start:
    mov rax, [num]

    mov rbx, rax

    xor rbx, 0xff
    mov r8b, bl

    ror rbx, 8

    xor rbx, 0xff
    mov r9b, bl

    ror rbx, 8

    xor rbx, 0xff
    mov r10b, bl

    ror rbx, 8

    xor rbx, 0xff
    mov r11b, bl

    ror rbx, 8

    xor rbx, 0xff
    mov r12b, bl

    ror rbx, 8

    xor rbx, 0xff
    mov r13b, bl

    ror rbx, 8

    xor rbx, 0xff
    mov r14b, bl

    ror rbx, 8

    xor rbx, 0xff
    mov r15b, bl

    nop

