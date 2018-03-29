; 
; Ex 1
; 
; Write an assembly language program to compute the distance squared
; between 2 points in the plane identified as 2 integer coordinates
; each, stored in memory.
;
; Remember the Pythagorean Theorem!

section .data
    point1_x  dq   2    ; x is first, y is second
    point1_y  dq  10    ; x is first, y is second
    point2_x  dq   5    ; x is first, y is second
    point2_y  dq   7    ; x is first, y is second


section .text
global _start

; a^2 + b^2 = c^2
_start:
    mov rax, [point1_x]
    sub rax, [point1_y]
    imul rax

    mov rbx, [point2_x]
    sub rbx, [point2_y]
    imul rbx, rbx

    mov rcx, rax
    add rcx, rbx

    mov rax, 60
    xor edi, edi
    syscall

