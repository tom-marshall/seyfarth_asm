;
; Ex 2
;
; Write an assembly program to swap 2 quad-words in memory using
; xor. Use the following algorithm:
;
;   a = a - b
;   b = a - b
;   a = a - b


section .data
    num1   dq   12362363524
    num2   dq   791923682


section .text

global _start

_start:
    mov rax, [num1]
    mov rbx, [num2]

    mov r8, [num1]
    mov r9, [num2]

    xor rax, rbx
    xor rbx, rax
    xor rax, rbx

    mov [num1], rax
    mov [num2], rbx

    nop

