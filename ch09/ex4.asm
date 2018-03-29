;
; Ex 4
;
; Write an assembly program to keep track of 10 sets of size 1000000.
; Your program should accept the following commands: add,
; union, print and quit. The program should have a function to
; read the command string and determine which it is and return 0, 1,
; 2, or 3 depending on the string read. After reading add your program
; should read a set number from 0 to 9 and an element number from
; 0 to 999999 and insert the element into the proper set. You need
; to have a function to add an element to a set. After reading union,
; your program should read 2 set numbers and make the first set be
; equal to the union of the 2 sets. You need a set union function.
; After reading print your program should print all the elements of
; the set. You can assume that the set has only a few elements. After
; reading quit your program should exit.


%define SETSIZE 1000000

; %macro flush 0
;     xor edi, edi
;     call fflush
; %endmacro

section .bss
setdata:
    set0   resd   SETSIZE
    set1   resd   SETSIZE
    set2   resd   SETSIZE
    set3   resd   SETSIZE
    set4   resd   SETSIZE
    set5   resd   SETSIZE
    set6   resd   SETSIZE
    set7   resd   SETSIZE
    set8   resd   SETSIZE
    set9   resd   SETSIZE

    setidx resd   10


section .rodata
    addprompt   db   "Enter a set number and an element number: ", 0
    cmdprompt   db   "Enter a command (add, union, print, or quit): ", 0
    prtprompt   db   "Which set shall I print for you, sir? ", 0

    prtformat   db   "Set: %2d, element: %d", 10, 0

    sprtformat  db   "%d", 0
    scmdformat  db   "%8s", 0
    saddformat  db   "%d %d", 0

commands:
    cmdadd    db   "add    "       ; name of command    (7 bytes)
              db   3               ; size of cmd string (1 byte)
              dq   fnadd           ; function to call   (8 bytes)

    structsz equ $ - cmdadd        ; size of command "struct"

    cmdunion  db   "union  "
              db   5
              dq   fnunion

    ; print command
    cmdprint  db   "print  "
    lenprint  db   5
              dq   fnprint

    ; quit command
    cmdquit   db   "quit   "
    lenquit   db   4


section .text
    ; extern fflush
    extern scanf
    extern printf

    global main
    global getcommand

    global fnadd
    global fnunion
    global fnprint

main:
    push rbp
    mov rbp, rsp

.loop
    call getcommand

    cmp rax, 3                          ; first test for quit command
    jz .quit

    imul rbx, rax, structsz             ; multiply cmd # by size of
                                        ;   "struct"
    call [commands + rbx + 8]           ; call function for jump table

    jmp .loop

.quit
    xor eax, eax
    leave
    ret


getcommand:
    sub rsp, 16

    mov qword [rsp], 0

    mov rdi, cmdprompt
    xor eax, eax
    call printf
    ; flush

    mov rdi, scmdformat
    mov rsi, rsp
    xor eax, eax
    call scanf

    mov bl, byte [rsp]                  ; test first byte of input

    xor eax, eax                        ; add command starts at 0
    cmp bl, 'a'                         ; test first letter
    jz .testcmd                         ; if it's a match, test the rest

    inc eax                             ; union command starts at 1
    cmp bl, 'u'                         ; test first letter
    jz .testcmd                         ; if it's a match, test the rest

    inc eax                             ; print command starts at 2
    cmp bl, 'p'                         ; test first letter
    jz .testcmd                         ; if it's a match, test the rest

    inc eax
    cmp bl, 'q'
    jz .testcmd

    jmp .notfound


.testcmd
    imul rbx, rax, structsz
    lea rdi, [rsp + 1]                  ; start comparison from
    lea rsi, [commands+rbx+1]           ;   the 2nd letter
    movzx ecx, byte [commands+rbx+7]    ; number of characters to
    dec ecx                             ;   compare, minus 1
    repe cmpsb                          ; compare string bytes

    test ecx, ecx                       ; see if all bytes matched
    jnz .notfound

    jmp .done

.notfound:
    mov rax, -1                         ; not found returns -1

.done

    add rsp, 16                         ; clean up stack
    ret                                 ; return


fnadd:
    sub rsp, 16                         ; set up some stack space
    setnum  equ 0                       ; rsp offset for setnum
    element equ 8                       ; rsp offset for element

    ; Print "Enter set # and element msg" prompt
    lea rdi, [addprompt]
    xor eax, eax
    call printf

    ; scanf for set number and element to enter
    lea rdi, [saddformat]
    lea rsi, [rsp + setnum]
    lea rdx, [rsp + element]
    xor eax, eax
    call scanf

    mov rcx, [rsp + setnum]             ; rcx holds setnum from input
    lea rbx, [setidx + rcx * 4]         ; rbx points to setidx array

    mov rdx, rcx                        ; start rdx off with setnum
    imul rdx, 4 * SETSIZE               ; rdx is the byte offset to the
                                        ;   arrays

    mov rax, [rbx]                      ; rax will hold byte offset into
    shl rax, 2                          ;   array, adjusted for dword
    add rdx, rax                        ; add offset to index

    lea rdi, [setdata + rdx]            ; rdi points to exact dword to
                                        ;   write to

    movsxd rax, dword [rsp + element]   ; load element into rax for
    mov [rdi], rax                      ;   writing and write it

    inc byte [rbx]                      ; increment setidx (count) for
                                        ;   this set

    add rsp, 16
    ret


fnunion:
    nop

    ret


fnprint:
    sub rsp, 16

    lea rdi, [prtprompt]
    xor eax, eax
    call printf

    lea rdi, [sprtformat]
    mov rsi, rsp
    xor eax, eax
    call scanf

    add rsi, rbx

    ; movzx rcx, byte [rdi]
    ; movzx r12, byte [rsp]               ; put set number in a register

    ; lea r13, [setnum]                   ; address of
    ; mov rcx, [rsp + setnum]             ; rcx holds setnum from input

    ; total equ rsp + setnum

    ; xor ecx, ecx

.printloop
    lea rdi, [prtformat]
    mov rsi, [rsp]
    xor eax, eax
    call printf

    ; imul rdx, 4 * SETSIZE               ; rdx is the byte offset to the

    add rsp, 16

    ret

