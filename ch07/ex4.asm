;
; Ex 4
;
; Write an assembly program to dissect a double stored in memory.
; This is a 64 bit floating point value. Store the sign bit in one
; memory location. Store the exponent after subtracting the bias
; value into a second memory location. Store the fraction field with
; the implicit 1 bit at the front of the bit string into a third memory
; location.


section .rodata
    num   dq   -1236.23124734


section .bss
    sign        resb   1
    exponent    resw   1
    fraction    resq   1


section .text

global _start
_start:
    mov rax, [num]

    bt rax, 63      ; sign bit
    setc [sign]     ; store in sign variable

    mov rbx, rax
    mov rdx, 0xfffffffffffff
    and rbx, rdx

    bts rbx, 52
    mov [fraction], rbx

    shr rax, 52
    and rax, 0x7ff
    sub rax, 1023

    mov [exponent], ax

    nop

