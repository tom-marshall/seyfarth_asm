;
; Ex 5
;
; Write an assembly program to perform a "find and replace" operation
; on a string in memory. Your program should have an input array and an
; output array. Make your program replace every occurrence of "amazing"
; with "incredible".

; This is an incredible way to view an incredible sunset on this incredible day in May

section .data
    srcstr   db   "This is an amazing way to view an amazing sunset on this amazing day in May!", 10, 0
    len     EQU  $-srcstr

    sstring      db   "amazing"
    sstringlen   EQU  $ - sstring

    rstring      db   "incredible"
    rstringlen   EQU  $ - rstring

    endoftest EQU srcstr + len - sstringlen


section .bss
    dststr  resb 8192


section .text
    extern printf
    global main


;------------------------------------------------------------------------------;
; Registers:                                                                   ;
;                                                                              ;
; r9:  saves state for dststr                                                  ;
; r10: saves state for srcstr                                                  ;
; r11: saves state for srcstr copy operation                                   ;
; rdx: saves index into string
;------------------------------------------------------------------------------;

main:
    push rsp

    ; print our source string
    mov rdi, srcstr             ; first param is location of srcstr
    xor eax, eax                ; no xmm registers
    call printf                 ; print it

    lea r9,  [dststr]
    lea rdi, [srcstr]           ; rdi is used for scasb
    mov r11, rdi                ; save current rdi

    mov al, byte [sstring]      ; seaches for the first letter in sstring

    mov rbx, rdi                ; bookmark rdi

.loop
    mov rcx, len                ; start with length
    repne scasb                 ; letter in replacement

    cmp rdi, endoftest          ; make sure we have enough characters
                                ;   left to check for a replacement
    jge .finishstring           ; if not, end the program

    mov rcx, sstringlen         ; check for search character length
    lea rsi, [sstring + 1]      ; rsi is for matching source string
    repe cmpsb                  ; check srcstr for replacement text

    lea r10, [rdi - 1]          ; save state of srcstr

    test rcx, rcx               ; see if we used up all characters (i.e. matched)
    jnz .loop                   ; if not, go again

.copytodst
    sub rbx, rdi                ; store difference in rbx
    neg rbx                     ; diff is negative, so negate
    sub rbx, sstringlen + 1     ; rdi is one past where we want to be

    mov rdi, r9                 ; set rdi to dststr (r9)
    mov rcx, rbx
    mov rsi, r11                ; start from previous spot
    rep movsb                   ; copy characters

    lea rsi, [rstring]          ; append 'incredible'
    mov rcx, rstringlen
    rep movsb                   ; copy characters

    mov r9, rdi                 ; save current dststr position

    mov rdi, r10                ; restore rdi to previous state
    mov rbx, r10                ; rbx will hold rdi for difference
    mov r11, r10                ; save current position is start of
                                ;   string to copy in .copytodst

    jmp .loop                   ; keep going

.finishstring:
    mov rdi, r9                 ; set rdi to dststr (r9)
    mov ecx, len                ; copy the rest
    mov rsi, r11                ; start at saved position in dststr
    repnz movsb                 ; copy bytes

    ; print our string
    mov rdi, dststr             ; first param is location of dststr
    xor eax, eax                ; no xmm registers
    call printf                 ; print it

    pop rsp                     ; clean up stack

    ret                         ; return

