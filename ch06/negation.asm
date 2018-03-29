section .data
    total   dq  0

section .text

global _start

_start:

.loop
    inc qword [total]
    jmp .loop


