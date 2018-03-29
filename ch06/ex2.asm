;
; Ex 2
;
; If we could do floating point division, this exercise would have you
; compute the slope of the line segment connecting 2 points. Instead
; you are to store the difference in x coordinates in 1 memory location
; and the difference in y coordinates in another. The input points are
; integers stored in memory. Leave register rax with the value 1 if
; the line segment it vertical (infinite or undefined slope) and 0 if it
; is not. You should use a conditional move to set the value of rax.
;


section .data
    point1_x  dq   3    ; point 1 x
    point1_y  dq  10    ; point 1 y
    point2_x  dq   3    ; point 2 x
    point2_y  dq   7    ; point 2 y


section .bss
    diff_x    resq 1    ; difference in x
    diff_y    resq 1    ; difference in y


section .text
global _start

_start:
    mov rbx, [point1_x]
    sub rbx, [point2_x]

    mov rcx, 1
    cmovz rax, rcx

    mov rcx, rbx
    neg rbx
    cmovl rbx, rcx
    mov [diff_x], rbx

    mov rbx, [point1_y]
    sub rbx, [point2_y]
    mov rcx, rbx
    neg rbx
    cmovl rbx, rcx
    mov [diff_y], rbx

    nop

