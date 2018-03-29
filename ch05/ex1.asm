section .data

    var1:   dd   0x12b3
    var2:   dd   23622
    var3:   dd  -1286236
    var4:   dd  -42

section .text

global _start

_start:
    mov eax, [var1]
    add eax, [var2]
    add eax, [var3]
    add eax, [var4]

    mov eax, 60
    mov edi, 0
    syscall

