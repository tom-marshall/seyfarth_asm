section .data
    msg1   db   "This is a test of the emergency broadcast system. This is only a test!", 0
    msg2   db   "This is a test of the emergency bullshit system. This is only a test!", 0


section .text

global _start
_start:
    mov rcx, 0x100

    lea rdi, [msg1]
    lea rsi, [msg2]

    repe cmpsb
    cmp rcx, 0
    jz .equal

    movzx eax, byte[rdi - 1]
    movzx ecx, byte[rsi - 1]

    mov rdi, rax
    mov eax, 60
    syscall

