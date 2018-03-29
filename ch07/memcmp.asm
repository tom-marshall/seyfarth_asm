segment .text

global mememp

memcmp:
    mov rcx, rdx
    repe cmpsb                  ; compare until end or difference
    cmp rcx, 0
    jz equal                    ; reached the end
    movzx eax, byte [rdi - 1]
    movzx ecx, byte [rsi - 1]
    sub rax, rcx
    ret

equal:
    xor eax, eax
    ret    












