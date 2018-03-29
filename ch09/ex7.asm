section .rodata
    inputfmt    db  "Enter a bunch of parenthesis: ", 0
    ; outputfmt   db  "You entered: %s", 10, 0
    ; toparse     db  "Will parse: %s", 10, 0
    scanffmt    db  "%79[()]%s", 0

    equalmsg    db  "Parenthesis are balanced", 10, 0
    notequalmsg db  "Parenthesis are unbalanced", 10, 0


section .bss
    buffer  resb    80 
    thestr  resb    80 


section .text
    extern sscanf
    extern fgets
    extern printf
    extern stdin
    extern fflush

    global main


%macro print 1
    lea rdi, [%1]
    xor eax, eax
    call printf
%endmacro

%macro print 2
    lea rdi, [%1]
    lea rsi, [%2]
    xor eax, eax
    call printf
%endmacro


; Registers
;
; r12: open parenthesis count

main:
    nop

    sub rsp, 16

.fgetspart:
    ; char *fgets(char *s, int size, FILE *stream);

    print inputfmt

    lea rax, [rsp]
    lea rdi, [buffer]
    mov esi, 79
    mov rdx, [stdin]
    call    fgets

    ; int sscanf(const char *str, const char *format, ...);
    lea rdi, [buffer]
    lea rsi, [scanffmt]
    lea rdx, [thestr]
    xor eax, eax
    call sscanf

    ; print outputfmt, buffer
    ; print toparse, thestr

    ; count number of open and closed parens
    ; '(' is ascii 40 - 0x28
    ; ')' is ascii 41 - 0x29

    xor r12d, r12d
    xor ecx, ecx

.countloop
    movzx esi, byte [thestr+ecx]
    test sil, sil
    jz .done

    and sil, 0x01
    shl sil, 1
    sub rsi, 1
    neg rsi

    add r12, rsi
    test r12, r12
    jl .notequal

    inc ecx
    jmp .countloop

.done:
    test r12, r12
    jz .equal

.notequal:
    ; not equal
    print notequalmsg

    jmp .end

.equal:
    print equalmsg

.end:
    add rsp, 16

    xor eax, eax
    ret

