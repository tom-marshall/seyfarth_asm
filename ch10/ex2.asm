;*****************************************************************************;
; Ex 2                                                                        ;
;                                                                             ;
; Write a program to use qsort to sort an array of random integers            ;
; and use a binary search function to search for numbers in the array.        ;
; The size of the array should be given as a command line parameter.          ;
; Your program should use random 0 %1000 for values in the array.             ;
; This will make it simpler to enter values to search for. After building     ;
; the array and sorting it, your program should enter a loop reading          ;
; numbers with scanf until scanf fails to return a 1. For each number         ;
; read, your program should call your binary search function and              ;
; either report that the number was found at a particular index or            ;
; that the number was not found.                                              ;
;*****************************************************************************;


section .text
    extern fprintf, stderr, printf, putchar     ; output
    extern scanf                                ; input

    extern rand, srand, time                    ; for random numbers
    extern atol, malloc, qsort                  ; other

    ; exported symbols
    global main, compare


main:
    push rbp
    mov rbp, rsp

    sub rsp, 16

    .array equ 0
    .arrsz equ 8

    cmp edi, 2
    jl .needsargs

    call readsize           ; parse command line supplied long

    cmp rax, 0
    jle .exit

    mov rdi, rax            ; amount to malloc
    mov [rsp+.arrsz], rdi
    shl rdi, 2
    call malloc
    mov [rsp+.array], rax

    ; fill the array
    mov rdi, rax
    mov rsi, [rsp+.arrsz]
    call fill

    ; sort the array
    mov rdi, [rsp+.array]
    mov esi, [rsp+.arrsz]
    mov edx, 4
    mov rcx, compare
    call qsort

    ; search the array
    mov rdi, [rsp+.array]
    mov esi, [rsp+.arrsz]
    call get_num_to_search

    cmp rax, 0
    jl .exit

    mov rdi, [rsp+.array]
    mov esi, [rsp+.arrsz]
    call binsearch 

    xor eax, eax
    jmp main.exit

.needsargs:
    section .rodata
    .errmsg: db "Not enough arguments", 10, 0
    section .text

    mov rdi, [stderr]
    lea rsi, [.errmsg]
    call fprintf

    mov eax, 1

.exit:
    leave
    ret


;******************************************************************************;
; readsize:                                                                    ;
;   reads size converted to long from command line                             ;
;                                                                              ;
; input:                                                                       ;
;   n/a                                                                        ;
;                                                                              ;
; returns:                                                                     ;
;   argv[1] converted to a long                                                ;
;******************************************************************************;
readsize:
    push rbp

    mov rdi, [rsi+8]    ; pointer into argv array
    call atol

    pop rbp
    ret


fill:
    mov r12, rdi        ; pointer to array
    mov r13, rsi        ; size
    mov r14, 1000       ; divisor for modulo

    xor edi, edi        ; NULL
    call time           ; time(NULL) for random seed

    mov rdi, rax        ; input for srand = time(NULL)
    call srand          ; seed random number generator

    xor ebx, ebx        ; index

.loop:
    call rand

    xor edx, edx                ; clear high byte for division
    div r14

    mov [r12+rbx*4], edx

    inc rbx
    cmp rbx, r13
    jnz .loop

    ret


compare:
    mov eax, [rdi]
    sub eax, [rsi]

    ret


;******************************************************************************;
; get_num_to_search:                                                           ;
;   gets a number to search for with scanf                                     ;
;                                                                              ; 
; input:                                                                       ;
;   rdi: array pointer                                                         ; 
;   esi: array size                                                            ; 
;                                                                              ; 
; returns:                                                                     ; 
;   index of found number or -1                                                ; 
;******************************************************************************;
get_num_to_search:
    push rbp
    mov rbp, rsp

    sub rsp, 16

    .array equ 16
    .arrsz equ 24

    section .rodata
    .hintmsg db "Hint... the array contains the following numbers:", 10, 0
    section .text

    lea rdi, [.hintmsg]
    xor eax, eax
    call printf

    ; print array
    mov rdi, [rbp+.array]
    mov rsi, [rbp+.arrsz]
    call printarr

    ; print input prompt
    section .rodata
    .numprompt db "Enter a number to search for: ", 0
    section .text

    lea rdi, [.numprompt]
    xor eax, eax
    call printf

    section .rodata
    .scanfmt db "%d", 0
    section .text

    lea rdi, [.scanfmt]
    lea rsi, [rsp]
    xor eax, eax
    call scanf

    test eax, eax               ; test return value of scanf
    jz .done                    ; if zero, there was no parsable input

    mov rbx, [rsp]


;******************************************************************************;
; binsearch:                                                                   ;
;   binary search                                                              ;
;                                                                              ;
; input:                                                                       ;
;   rdi: array pointer                                                         ;
;   esi: array size                                                            ;
;                                                                              ;
; returns:                                                                     ;
;   index of found number or -1                                                ;
;******************************************************************************;
binsearch:
    mov rcx, [rbp+.arrsz]       ; rcx is index

    mov rdi, [rbp+.array]       ; rdi is low
    lea rsi, [rdi+rcx*4] ; rsi is high

    shr rcx, 1                  ; rcs is now mid

    mov eax, [rdi+rcx*4]
    cmp eax, [rsp]

    jl .lessthan
    jg .morethan

    ; must be equal!

.lessthan:
.morethan:

.done
    leave
    ret


;******************************************************************************;
; printarr:                                                                    ;
;   prints array                                                               ;
;                                                                              ;
; input:                                                                       ;
;   rdi: array pointer                                                         ;
;   esi: array size                                                            ;
;                                                                              ;
; returns:                                                                     ;
;   index of found number or -1                                                ;
;******************************************************************************;
printarr:
    mov r12, rdi
    mov r13, rsi

    section .rodata
    .pfmt db "%.3d", 0
    section .text

    xor rbx, rbx

.loop:
    nop

    lea rdi, [.pfmt]
    mov esi, [r12+rbx*4]
    xor eax, eax
    call printf

    ; compute x & (x - 1)
    mov dl, bl          ; copy current index to dl
    add dl, 5           ; start one past 4
    mov dh, dl          ; duplicate dl to dh
    neg dl              ; -x
    and dl, dh          ; x & (-x)

    and dl, 0x04        ; only interested in bit 2
    shr dl, 2           ; convert from 4 to 1 if bit 2 set

    mov edi, 0x09       ; load tab character for putchar
    add dil, dl         ; add 1 to tab, makes it a newline (0x09 to 0x0a)
    call putchar        ; print tab or newline

    inc rbx             ; next interation
    cmp rbx, r13
    jl .loop

    cmp al, 0x0a        ; if we've just printed a carriage return
    jz .done            ; then we're done

    mov rdi, 0x0a       ; else print a carriage return
    call putchar

.done:
    ret


