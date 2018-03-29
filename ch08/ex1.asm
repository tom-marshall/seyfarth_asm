;
; Ex 1
;
; Write an assembly program to compute the dot product of 2 arrays.


%define SIZE 64


section .bss
    arr1      resd   SIZE
    arr2      resd   SIZE
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

    lea r12, [arr1]     ; saves state of rdi (arr1) to r12,
                        ;    which is a callee save register

    mov edi, 0          ; call time with NULL
    call time           ; time is seed for srand
    mov rdi, rax        ; rdi holds time call
    call srand          ; call srand

    mov r13, SIZE       ; fill SIZE array locations.  use callee save
                        ;    register for counter

.loop:
    call rand           ; generate random # and store in eax

    mov rdi, r12        ; restore rdi from saved value
    stosd               ; store qword
    mov r12, rdi        ; store rdi for later

    dec r13             ; restore ecx
    jg .loop

    dec byte [iter]     ; check to see if both iterations
    jz .computedot      ;    have executed

    lea r12, [arr2]     ; move on to fill arr2 with random data
    mov r13, SIZE       ; SIZE elements

    jmp .loop

.computedot:
    mov rcx, SIZE

.computeloop:
    movsxd rax, dword [arr1 + (rcx - 1) * 4]
    movsxd rbx, dword [arr2 + (rcx - 1) * 4]
    mul rbx
    mov [product + (rcx - 1) * 8], rax

    dec rcx
    jnz .computeloop

.done:
    leave

    xor eax, eax
    ret


