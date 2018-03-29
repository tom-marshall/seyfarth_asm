segment .data
    ; thestr   db   "This is a test of the emergency broadcast system. This is only a test.", 0
    thestr   db   "x"

segment .text
    global _start

_start:
    cld

    mov rcx, -1
    xor al, al
    lea rdi, [thestr]

    repne scasb
    mov rax, -2
    sub rax, rcx

    nop

