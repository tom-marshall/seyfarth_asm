section .rodata
    prtfmt  db  "%d", 10, 0


section .text
    extern printf
    extern srandom
    extern time.h
    extern random
    global main

main:

.loop
    call random

    mov rsi, rax
    lea rdi, [prtfmt]
    xor rax, rax
    call printf

    jmp .loop

    

