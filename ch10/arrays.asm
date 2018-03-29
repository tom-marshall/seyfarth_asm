section .text
    extern malloc
    extern free

    global main

main:
    push rbp
    mov rbp, rsp

    sub rsp, 16

    mov rdi, 1024 * 1024
    call malloc
    mov [rsp], rax

    mov ecx, (1024 * 1024) / 8

    mov rdi, rax
    mov rax, 0xcccccccccccccccc
    rep stosq

    mov rdi, [rsp]
    call free

    leave

    ret

