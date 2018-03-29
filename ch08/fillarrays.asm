;
; Ex 1
;
; Write an assembly program to compute the dot product of 2 arrays.


%define SIZE 100


section .bss
    arr1      resq   SIZE
    arr2      resq   SIZE
    product   resq   SIZE


section .data
    iter      db   2


section .text

extern rand
extern srand
extern time

global main

main:
    push rbp
    mov rbp, rsp

    mov edi, 0          ; call time with NULL
    call time           ; time is seed for srand
    mov rdi, rax        ; rdi holds time call
    call srand          ; call srand

    lea r12, [arr1]     ; saves state of rdi (arr1) to r12,
                        ;    which is a callee save register

    mov r13, SIZE       ; fill 100 array locations.  use callee save
                        ; register for counter

.loop:
    call rand           ; generate random # for low 32 bits
    mov rbx, rax        ; store in rbx
    call rand           ; generate random # for high 32 bits
    shl rbx, 32         ; now shift low to high bits
    or rax, rbx         ; combine rax and rbx for 64 bits

    mov rdi, r12        ; restore rdi from saved value
    stosq               ; store qword
    mov r12, rdi        ; store rdi for later

    dec r13             ; restore ecx
    jnz .loop

    dec byte [iter]
    jz .done

    lea rdi, [arr2]     ; r8: saves state of rdi (arr1)
    mov r13, SIZE       ; fill 100 array locations

    jmp .loop

.done:
    leave

    xor eax, eax
    ret


