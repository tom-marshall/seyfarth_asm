section .data
    num   dq   0x123f386af236266e


section .text

global _start
_start:
    mov rax, [num]  ; number to bit count

    xor ebx, ebx    ; clear ebx for carry bit status
    xor edx, edx    ; total count of 1 bits

    mov ecx, 63     ; test 64 bits

    times 5 xor eax, eax

.loop
    bt rax, rcx     ; check next bit for 1
    setc bl         ; if set, store in bl
    add rdx, rbx    ; bl is 1 if set, so add to total

    dec rcx         ; next iteration
    jl .done        ; if all done, go to end

    jmp .loop       ; go again

.done
    nop             ; make gdb happy



