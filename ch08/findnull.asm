segment .rodata
    thestr   db   "This is a test of the emergency broadcast system. This is only a test.", 0
    notfnd   db   "Not found!", 0
    printffmt db  "found at byte %d", 10, 0


segment .text
    extern puts
    extern printf

    global main

main:
    push rbp
    mov rbp, rsp

    lea rdi, [thestr]
    mov rbx, rdi

    mov ecx, 1024

    xor eax, eax
    repne scasb
    sub rdi, rbx
    mov rbx, rdi

    test rcx, rcx
    jnz .found

    lea edi, [notfnd]
    call puts
    jmp .end

.found:
    lea edi, [printffmt]
    mov rsi, rbx
    xor eax, eax
    call printf

.end:
    leave
    ret
    
