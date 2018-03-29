section .data
    var1:   db  42
    var2:   dw  -1327
    var3:   dd  1236252
    var4:   dq  2352326362

section .bss
    sum:    resq    1

section .text

global _start

_start:
    movsx rax, byte [var1]
    movzx rbx, word [var2]
    movsx rbx, word [var2]
    movsxd rcx, dword [var3]
    mov rdx, [var4]

    mov [sum], rax
    add [sum], rbx
    add [sum], rcx
    add [sum], rdx

    mov eax, 60
    xor edi, edi
    syscall
