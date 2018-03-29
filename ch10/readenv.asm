; Prints out environmental variables

section .rodata
    printfmt db "argv[%d] is %s", 10, 0


section .text
    extern printf

    global main


main:
    push rbp
    mov rbp, rsp

    mov ebx, edi
    mov r12, rsi

.loop:
    inc ebx                 ; one past argv

    mov rdx, [r12+rbx*8]    ; pointer into argv array
    test rdx, rdx
    jz .exit

    lea rdi, [printfmt]     ; print format argv[...] is ...
    mov esi, ebx            ; prints the index
    xor eax, eax            ; no xmm
    call printf             ; print

    jmp .loop

    xor eax, eax 

.exit
    leave
    ret


