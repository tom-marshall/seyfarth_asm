; A Pythagorean triple is a set of three integers a , b and c such
; that a^2 + b^2 = c^2. Print all the Pythagorean triples where c <= 500.

%define maxhyp       501

section .rodata
    printfmt   db   "%2d, %2d, %2d", 10, 0


;------------------------------------------------------------------------------;
; Registers:                                                                   ;
;                                                                              ;
; r12: 'a' (side1)                                                             ;
; r13: 'b' (side2)                                                             ;
; r14: 'c' (hypotenuse)                                                        ;
;------------------------------------------------------------------------------;

section .text
    extern printf
    global main
    global sumofsides

main:
    push rbp
    mov rbp, rsp

    xor r12, r12
    mov r14, 2          ; start with c = 2

.doloop:
    xor r12, r12        ; start of do loop, resets 'a'

.loop1
    inc r12             ; go to next 'a'
    mov r13, r12        ; start 'b' at 'a'

.loop2
    mov rdi, r12        ; 'a' is first arg to sumofsides
    mov rsi, r13        ; 'b' is second arg to sumofsides
    call sumofsides     ; compute sumofsides

    mov rbx, rax        ; store sum in rbx
    mov rax, r14        ; store c^2 in rax
    mul rax             ; compute square of c

    cmp rbx, rax        ; rbx is the sum, rax is c^2
    jnz .skipprint      ; if not a Pythagorean triple, don't print it

    lea rdi, [printfmt] ; 1st param is printf format
    mov rsi, r12        ; 2nd param is 'a' value
    mov rdx, r13        ; 3nd param is 'b' value
    mov rcx, r14        ; 4nd param is 'c' value
    call printf         ; printf

.skipprint
    inc r13             ; next 'b' iteration
    cmp r13, r14        ; compare to 'c'
    jl .loop2           ; repeat inner loop if 'b' is less than 'c'

    cmp r12, r14        ; 'b' is at 'c', so test 'a' for 'c'
    jl .loop1           ; if less, repeat outer loop

    inc r14             ; while 'c' < maxhyp
    cmp r14, maxhyp
    jl .doloop          ; back to beginning of do


.done
    leave               ; clean up stack
    ret                 ; return


; calculates sum of a^2 and b^2
sumofsides:
    mov rax, rdi        ; calculate a^2
    mul rax
    mov rbx, rax        ; move result to ebx

    mov rax, rsi        ; calculate b^2
    mul rax
    add rax, rbx        ; add a^2

    ret

