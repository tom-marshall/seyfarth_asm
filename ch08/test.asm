section .data

%define COUNT 1024
section .bss
    src   resb   COUNT
    dst   resb   COUNT

section .text
global _start

_start:
    mov al, 0xcc
    mov ecx, COUNT
    lea rdi, [src]
    rep stosb

    lea rsi, [src]
    lea rdi, [dst]
    mov rcx, COUNT

    rep movsb

    nop

