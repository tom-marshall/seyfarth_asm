;------------------------------------------------------------------------------;
; Ex 3                                                                         ;
;------------------------------------------------------------------------------;
; Write an assembly program to compute the Adler-32 checksum                   ;
; value for the sequence of bytes read using fgets to read 1 line              ;
; at a time until end of file. The prototype for fgets is                      ;
;                                                                              ;
;   char *fgets(char *s, int size, FILE *fp);                                  ;
;                                                                              ;
; The parameter s is a character array which should be in the bss              ;
; segment. The parameter size is the number of bytes in the array              ;
; s. The parameter fp is a pointer and you need stdin. Place the               ;
; following line in your code to tell the linker about stdin                   ;
;                                                                              ;
;   extern stdin                                                               ;
;                                                                              ;
; fgets will return the parameter s when it succeeds and will return 0         ;
; when it fails. You are to read until it fails. The Adler-32 checksum         ;
; is computed by                                                               ;
;                                                                              ;
;   long adler32 ( char *data , int len)                                       ;
;   {                                                                          ;
;       long a = 1, b = 0;                                                     ;
;       int i ;                                                                ;
;                                                                              ;
;       for (i = 0; i < len; i++) {                                            ;
;           a = (a + data [i]) % 65521;                                        ;
;           b = (b + a) % 65521;                                               ;
;                                                                              ;
;           return (b << 16) | a;                                              ;
;       }                                                                      ;
;   }                                                                          ;
;                                                                              ;
; Your code should compute 1 checksum for the entire file. If you use          ;
; the function shown for 1 line, it works for that line, but calling it        ;
; again restarts ...                                                           ;
;------------------------------------------------------------------------------;

%define MOD_ADLER 65521
%define BUFFSZ 1024


section .bss
    buffer   resb   BUFFSZ


section .data
    adler_a   dd   1
    adler_b   dd   0
    checksum  dd   0


section .text
    global main
    extern fgets, stdin, printf
    extern strlen

main:
    push rbp
    mov rbp, rsp


.loop:
    ; char *fgets(char *s, int size, FILE *fp);

    lea rdi, [buffer]           ; char *s
    mov rsi, BUFFSZ             ; int size
    mov rdx, [stdin]            ; FILE *fp
    call fgets

    test eax, eax
    jz .no_more_input

    mov rdi, buffer
    call strlen

    ;lea rdi, [buffer]
    mov esi, eax
    call adler32

    jmp .loop


.no_more_input:
    call adler32_finalize

    leave
    ret


;------------------------------------------------------------------------------;
; adler32                                                                      ;
;------------------------------------------------------------------------------;
; Computes running alder32 checksum and stores each half for continuation      ;
;                                                                              ;
; Arguments:                                                                   ;
;   rdi: data                                                                  ;
;   rsi: len                                                                   ;
;------------------------------------------------------------------------------;
adler32:
    push rbp
    mov rbp, rsp

    mov r8d, dword [adler_a]     ; r8 is running 'a' variable
    mov r9d, dword [adler_b]     ; r9 is running 'b' variable

    mov ecx, esi
    mov rsi, rdi

    mov edi, MOD_ADLER

.loop:
    ; a = (a + data [i]) % 65521
    xor eax, eax
    lodsb                       ; load next character

    add eax, r8d                ; continue with previes "a" calculation
    xor edx, edx                ; clear edx for division
    div edi                     ; divide (for mod)
    mov r8d, edx                ; move the result of mod to 'a'

    ; b = (b + a) % 65521
    mov eax, r8d                ; add a and b
    add eax, r9d
    xor edx, edx                ; clear edx for division
    div edi                     ; divide (for mod)
    mov r9d, edx                ; move the result of mod to 'b'

    dec ecx                     ; loop to next character
    jg .loop

    mov dword [adler_a], r8d    ; store running 'a' variable
    mov dword [adler_b], r9d    ; store running 'b' variable

    leave
    ret


;------------------------------------------------------------------------------;
; adler32_finalize                                                             ;
;------------------------------------------------------------------------------;
; Called to finalize Adler32 computation, since we're                          ;
;   running through a loop   ;                                                 ;
;------------------------------------------------------------------------------;
adler32_finalize:
    mov edi, dword [adler_b]    ; load 'b' variable
    shl edi, 16                 ; shift to the msb half
    or edi, dword [adler_a]     ; or with lsb half in 'a'

    mov [checksum], edi         ; store result in 'checksum'

    section .rodata
    pfmt db "Adler32: %x", 10, 0
    section .text

    ; Print result
    lea rdi, [pfmt]
    mov rsi, [checksum]
    xor eax, eax
    call printf

    ret

