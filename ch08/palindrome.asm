;
; Ex 4
;
; Write an assembly program to determine if a string stored in memory is a
; palindrome. A palindrome is a string which is the same after being reversed,
; like "refer" . Use at least one repeat instruction.


%define LCBIT 0x20


section .rodata
    ;thestr   db   "refer", 0
    ;thestr   db   "racercar", 0
    ;thestr   db   "foobarbaz", 0

    thestr  db  "A man, a plan, a cat, a ham, a yak, a yam, a hat, a canal-Panama!", 0
    strlen  EQU $-thestr - 1    ; -1 because we're null terminated


section .data
    notpal db 0         ; boolean for is palindrome
    diff   dq 0         ; pointer to the location of the difference
                        ;   a value of zero is a null pointer
                        ;   i.e. it's a palindrome


section .text
global _start

_start:
    lea rdi, [thestr]           ; rdi points to the start of the string
    lea rsi, [thestr+strlen-1]  ; rdi points to the end of the string

    mov rdx, rdi        ; rdx stores the address of the halfway point
    add rdx, strlen>>1  ;   for comparison

    xor ebx, ebx        ; for using setting boolean palindrome bit

.loop
    mov al, [rdi]       ; store first byte in al
    mov ah, [rsi]       ; store last byte in ah
    or al, LCBIT        ; convert to lower case
    or ah, LCBIT        ; convert to lower case


; note: we want bytes between between 0x61 and 0x7a
;   (lower case letters in ascii)

; "start of string" test
.sostest:
    cmp al, 0x61        ; if it's greater than 0x61, test next byte
    jge .nsbyte
    jmp .incstart       ; increment the start index

; test the "next start byte"
.nsbyte                 
    cmp al, 0x7a        ; if it's less than 0x7a, jump to test end of string
    jle .eostest        

; increment start index
.incstart:
    inc rdi             ; go to next start byte
    cmp rdi, rdx        ; compare start index to half way address
    jge .done           ; if we've hit the half way point, end

    mov al, [rdi]       ; mov next byte into al
    jmp .sostest        ; test next start byte


; "end of string" test
.eostest                
    cmp ah, 0x61        ; if it's greater than 0x61, test previous byte
    jge .nebyte

    jmp .decend

; test the "next end byte"
.nebyte
    cmp ah, 0x7a        ; if it's less than 0x7a, test the characters
    jle .testchars

; decrement end index
.decend
    dec rsi             ; go to previous end byte
    cmp rsi, rdx        ; compare start index to half way address
    jle .done           ; if we've hit the half way point, end

    mov ah, [rsi]       ; mov previous byte into ah
    jmp .eostest        ; test next start byte


; test the characters
.testchars
    cmp al, ah          ; compare bytes
    setnz bl            ; set bl if the letters are different
    jnz .done           ; if different, we're done

    inc rdi             ; from start
    dec rsi             ; from end

    cmp rdi, rdx        ; test if start index is at the halfway point
    jle .loop           ; if not, go again

.done
    xor rax, rax        ; clear a for pointer value
    cmp bl, 1           ; if we have a palindrome...
    cmove rax, rdi      ; copy the pointer to rax
    mov [diff], rax     ; and store in diff

    mov eax, 60
    movzx rdi, bl
    syscall

