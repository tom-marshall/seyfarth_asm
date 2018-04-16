;
; Ex 4
;
; Write a test program t o evaluate how well the hashing function
; below works.
;
;   int multipliers[] = {
;       123456789,
;       234567891,
;       345678912,
;       456789123,
;       567891234,
;       678912345,
;       789123456,
;       891234567
;   };
;
;   int hash (unsigned char *s)
;   {
;       unsigned long h = 0;
;       int i = 0;
;
;       while (s[i]) {
;           h + s[i] * multipliers[i % 8];
;           i++;
;       }
;
;       return h % 99991;
;   }
;
;
; Your test program should read a collection of strings using scan£
; with the format string "%79s" where you are reading into a charac­
; ter array of 80 bytes. Your program should read until scan£ fails
; to return 1 . As it reads each string it should call hash (written in
; assembly) to get a number h from 0 to 99990. It should increment
; location h of an array of integers of size 9999 1 . After entering all
; the data, this array contains a count of how many words mapped
; to a particular location in the array. What we want to know is how
; many of these array entries have 0 entries, how many have 1 entry,
; how many have 2 entries, etc. When multiple words map to the
; same location, it is called a "collision" . So the next step is to go
; through the array collision counts and increment another array by
; the index there. There should be no more than 1000 collisions, so
; this could be done using
;
;    for (i = 0; i < 99991; i++) {
;        k = collisions[i];
;        if (k > 999) k = 999;
;        count[k] ++;
;
; After the previous loop the count array has interesting data. Use a
; loop to step through this array and print the index and the value
; for all non-zero locations.
;
; An interesting file to test is "/usr /share/diet/words" .
;


section .rodata
    multipliers: dd   123456789, 234567891, 345678912, 456789123,
                 dd   567891234, 678912345, 789123456, 891234567


section .bss
    hashes      resd  99991


section .text
    extern printf, scanf

    global main

main:
    push rbp
    mov rbp, rsp

    sub rsp, 80

    section .rodata
    .inputfmt   db   "Enter a 79 character string: ", 0
    .scanffmt   db   "%79s", 0
    section .text

.nextinput
    lea rdi, [.inputfmt]
    xor eax, eax
    call printf

.processloop:
    lea rdi, [.scanffmt]
    mov rsi, rsp
    call scanf

    cmp al, 1                     ; make sure we have valid input
    jnz .printresults

    lea rdi, [rsp]
    call hash

    inc dword [hashes+rax*4]
    jmp .processloop

.printresults:
    section .rodata
    .resultfmt  db   "Element %d, count %d", 10, 0
    section .text

    xor ebx, ebx

; @ 603dec

.printloop:
    mov edx, dword [hashes+rbx*4]
    test edx, edx
    jz .skipprint

    lea rdi, [.resultfmt]
    mov esi, ebx
    xor eax, eax
    call printf

.skipprint:
    inc ebx
    cmp ebx, 99991
    jb .printloop


.done:
    xor eax, eax
    leave
    ret


;-------------------------------------------------------------------------------
; hash:
; prototype: hash (unsigned char *s)
;
; input:
;   rdi: pointer to c-style string
;
; registers used:
;   rdx: hash
;   ecx: index
;
; returns 32 bit hash
;-------------------------------------------------------------------------------
hash:
    xor eax, eax
    xor ecx, ecx
    xor edx, edx

    mov rsi, rdi

.loop:
    lodsb                   ; grab next character
    test al, al             ; test for null terminator
    jz .endloop             ; if so, end

    and ecx, 0x07           ; mod 8
    imul eax, [multipliers+rcx*4]   ; multiply by constant in array
    add rdx, rax

    xor eax, eax            ; reset eax for next lodsb
    inc ecx
    jmp .loop

.endloop:
    mov rax, rdx            ; running has is in rdx
    xor edx, edx            ; clear rdx for divide

    mov rcx, 99991          ; 99990 buckets
    div rax, rcx            ; take mod
    mov eax, edx            ; move the remainder into eax for return

    ret

