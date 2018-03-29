section .text
    extern printf

    global main

main:
    push rbp
    mov rbp, rsp

    mov r13, rdi        ; argc
    mov r14, rsi        ; argv


section .data
    .fmt db "check it out: %s", 10, 0


section .text

.loop:
    lea rdi, [.fmt]
    mov rsi, [r14]
    xor eax, eax
    call printf

    add r14, 8

    dec r13
    jg .loop

    xor eax, eax
    leave
    ret

