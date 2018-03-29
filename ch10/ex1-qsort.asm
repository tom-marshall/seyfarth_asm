;
; Ex 10-1a
;
; Write 2 test programs: one to sort an array of random 4 byte integers
; using bubble sort and a second program to sort an array of random 4 bytes
; integers using the qsort function from the C library.
;
; Your program should use the C library function atol to convert a number
; supplied on the command line from ASCII to long. This number is the size
; of the array ( number of 4 byte integers ) . Then your program can
; allocate the array using malloc and fill the array using random. You call
; qsort like this:
;
; qsort (array , n , 4 , compare ) ;
;
; The second parameter is the number of array elements to sort and the
;third is the size in bytes of each element . The fourth parameter is the
; address of a comparison function. Your comparison function will accept
; two parameters. Each will be a pointer to a 4 byte integer. The comparison
; function should return a negative, 0 or positive value based on the
; ordering of the 2 integers. All you have to do is subtract the second
; integer from the first.


%macro pc 1
    mov edi, %1
    call putchar
%endmacro


section .rodata
    errmsg     db  "Need to supply array length", 10, 0
    mallocerr  db  "Cannot allocate %ul bytes of memory", 10, 0


section .text
    extern fprintf, printf, putchar, puts, stderr   ; i/o:
    extern rand, srand, time    ; for randomization:
    extern malloc, qsort, atol  ; misc:

    ; exported functions
    global main, bubblesort, compare, fill

main:
    push rbp
    mov rbp, rsp
    sub rsp, 32

    .array equ 0
    .arrsz equ 8

    cmp edi, 2                  ; make sure we are passed 2 arguments
    jz .parseargs

    mov rdi, [stderr]           ; stderr pointer
    lea rsi, [errmsg]           ; the error message
    xor eax, eax
    call fprintf                ; print error

    mov eax, 1                  ; exit status 1
    jmp .end

.parseargs:
    mov rdi, [rsi+8]            ; argv[1]
    call atol                   ; convert to long
    mov [rsp+.arrsz], rax   ; store it on the stack

    mov rdi, rax                ; malloc length bytes for
    shl rdi, 2                  ; 4 byte ints
    call malloc
    mov [rsp+.array], rax     ; save malloc'd pointer

    test rax, rax               ; check for null pointer
    jne .postmalloc             ; returned from malloc

    mov rdi, [stderr]           ; stderr pointer
    lea rsi, [mallocerr]        ; the error message
    xor eax, eax
    call fprintf                ; print error

    mov eax, 1                  ; exit status 1
    jmp .end

.postmalloc:
    mov rdi, rax
    mov rsi, [rsp+.arrsz]
    call fill

    mov rdi, [rsp+.array]
    mov rsi, [rsp+.arrsz]
    call printarr

    .pattern equ 16
    mov qword [rsp+.pattern+0], '----' ;0x2d2d2d2d
    mov qword [rsp+.pattern+4], '----' ;0x2d2d2d2d
    mov byte  [rsp+.pattern+8], 0

    lea rdi, [rsp+.pattern]
    call puts

    mov rdi, [rsp+.array]
    mov rsi, [rsp+.arrsz]
    mov edx, 4
    mov rcx, compare
    call qsort

    ;print
    mov rdi, [rsp+.array]
    mov rsi, [rsp+.arrsz]
    call printarr

    ; done
    xor eax, eax

.end:
    leave
    ret


; Registers:
;
; rdi: pointer to array
; rsi: size of array
; ecx: counter
; rax: comparison and for swap
; rbx: flag for swapped this round

bubblesort:
    push rbp
    mov rbp, rsp

    mov rdx, rsi
    dec rdx

.doloop:
    xor ebx, ebx
    xor ecx, ecx

.loop:
    mov eax, [rdi+rcx*4]
    cmp eax, [rdi+(rcx+1)*4]
    jle .next

    ; swap
    mov r8d, [rdi+rcx*4]
    mov r9d, [rdi+(rcx+1)*4]
    mov [rdi+rcx*4], r9d
    mov [rdi+(rcx+1)*4], r8d

    inc rbx

.next:
    inc rcx
    cmp rcx, rdx
    jl .loop

.enddoloop
    dec rdx
    test ebx, ebx
    jg .doloop

    leave
    ret


; fill (int *array, size_t size)
fill:
    push rbp
    mov rbp, rsp

    sub rsp, 16

    .arr   equ 0
    .arrsz equ 8

    mov [rsp+.arr], rdi
    mov [rsp+.arrsz], rsi
    mov rbx, rsi

    xor edi, edi            ; seed random number generator
    call time               ; with time(NULL)

    mov rdi, rax            ; seed for srand
    call srand              ; randomize

    dec rbx
    mov r12, [rsp+.arr]


.fillloop:
    call rand
    mov [r12+rbx*4], eax

    dec rbx
    jl .loopfilled

    jmp .fillloop


.loopfilled:
    add rsp, 16

    leave
    ret


compare:
    mov eax, [rdi]
    sub eax, [rsi]

    ret


printarr:
    mov r12, rdi
    mov r13, rsi

    section .data
    .printfmt db "%.8x", 10, 0
    section .text

    xor ebx, ebx

.loop
    lea rdi, [.printfmt]
    mov esi, [r12+rbx*4]
    xor eax, eax
    call printf

    inc rbx
    cmp rbx, r13
    jl .loop

    ret

