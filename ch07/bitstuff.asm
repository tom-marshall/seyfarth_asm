section .data
    var times 8 db 0xcc

section .text

global _start

_start:
    ;xor rax, rax
    mov rax, [var]

    ; mov ecx, 2

; .loopit
    ; shr rax, cl
    ; jnz .loopit

    bts rax, 4

