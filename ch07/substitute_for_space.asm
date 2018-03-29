section .data
    src   db   "The lodsb instruction moves the byte from the address specified " 
          db   "by rs i to the al register. The other variants move more bytes " 
          db   "of data into ax, eax8. 5. REPEAT STRING (ARRAY) INSTRUCTIONS "
          db   "or rax. No flags are affected. Repeated loading seems to be of " 
          db   "little use. However you can use lods instructions in other loops " 
          db   "taking advantage of the automatic source register updating.", 10, 0

    len EQU $-src

section .bss
    dst   resb   len


section .text

extern printf

global main
main:
    push rbp
    mov rbp, rsp

    jmp .end

    lea rsi, [src]
    lea rdi, [dst]
    mov ecx, len

    xor eax, eax
    mov ebx, '_'

.more:
    lodsb
    cmp al, 0x20
    cmovz ax, bx
    stosb
    jmp .skip

.skip:
    dec ecx
    jnz .more

    mov rdi, dst
    xor eax, eax
    call printf

.end
    leave

    xor eax, eax
    ret

