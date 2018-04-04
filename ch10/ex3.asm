;
; Ex 3
;
; Write an assembly program to compute the Adler-32 checksum
; value for the sequence of bytes read using fgets to read 1 line
; at a time until end of file. The prototype for fgets is
;
;    char *fgets (char *s, int size, FILE *fp);


section .data
    rega dq 1
    regb dq 0

section .bss
    buffer resb 8192


section .text
    extern fgets, printf, puts, stdin
    extern strlen

    global main


main:
.loop:
    lea rdi, [buffer]
    mov rsi, 8192 
    mov rdx, [stdin]
    call fgets

    test eax, eax
    jz .printadler

    lea rdi, [buffer]
    call strlen

    lea edi, [buffer]
    mov esi, eax
    call adler32

    jmp .loop


.printadler:
    section .rodata
    .fmt db "Adler-32 sum is %d (%x)", 10, 0
    section .text

    lea rdi, [.fmt]
    shl r14d, 16
    or  r14d, r13d
    mov esi, r14d

    mov edx, esi
    xor eax, eax
    call printf


.done
    xor eax, eax
    ret


;------------------------------------------------------------------------------;
; adler32                                                                      ;
;   Computes Adler-32 checksum for file                                        ;
;                                                                              ;
; inputs:                                                                      ;
;   rdi: current line                                                          ;
;   rsi: length                                                                ;
;                                                                              ;
; registers used:                                                              ;
;   r12d: running checksum                                                     ;
;------------------------------------------------------------------------------;
adler32:
    xor ecx, ecx                ; index
    mov r8d, 65521

    mov r13, qword [rega]       ; a reg
    mov r14, qword [regb]       ; b reg


.loop:
    mov eax, [rdi+rcx]          
    add eax, r13d
    xor edx, edx                ; clear edx for divide
    div r8d                     ; div for modulo
    mov r13d, edx

    mov eax, r13d
    add eax, r14d
    xor edx, edx                ; clear edx for divide
    div r8d                     ; div for modulo
    mov r14d, edx

    inc ecx
    cmp ecx, esi
    jnz .loop

    mov [rega], r13
    mov [regb], r14

.done:
    ret


