;
; Ex 1
;
; Write an assembly program to produce a billing report for an electric
; company. It should read a series of customer records using scanf
; and print one output line per customer giving the customer details
; and the amount of the bill. The customer data will consist of a name
; (up to 64 characters not including the terminal 0) and a number
; of kilowatt hours per customer. The number of kilowatt hours is
; an integer. The cost for a customer will be $20.00 if the number of
; kilowatt hours is less than or equal to 1000 or $20.00 plus 1 cent
; per kilowatt hour over 1000 if the usage is greater than 1000. Use
; quotient and remainder after dividing by 100 to print the amounts
; as normal dollars and cents. Write and use a function to compute
; the bill amount (in pennies).


section .data


section .bss
    ; name     resb   65
    ; hrs      resd   1


section .rodata
    basecost   dd   200000
    scanfmsg   db   "enter ur nfo (hrs and name): ", 0
    scanffmt   db   "%d %64c: ", 0
    printffmt  db   "You entered: %d %s", 10, 0
    header     db   "here's ur bill", 10, 0


section .text
    extern printf
    extern scanf

    global main

main:
    push rbp
    mov rbp, rsp

    sub rsp, 80             ; set aside 80 bytes for one record

    lea rdi, [scanfmsg]
    xor eax, eax
    call printf

    name   equ   4
    hrs    equ   0

    xor eax, eax
    lea rdi, [rsp + name]
    mov ecx, 65
    rep stosb

    lea rdi, [scanffmt]
    lea rsi, [rsp + hrs]
    lea rdx, [rsp + name]
    xor eax, eax
    call scanf

    lea rdi, [printffmt]

    movsxd rsi, dword [rsp + hrs]
    lea rdx, [rsp + name]

    xor eax, eax
    call printf

    ; lea rdi, [header]
    ; xor eax, eax
    ; call printf

    leave
    ret

