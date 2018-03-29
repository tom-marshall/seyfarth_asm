;
; ex 8. Write an assembly "program" ( data only ) defining data values
; using dw and dd for all the numbers in exercises 1-4.
;

section .data

    var_1a: dd   37
    var_1b: dd  350
    var_1c: dd  -65
    var_1d: dd -427

    var_2a: dw 0000001010101010b
    var_2b: dw 1111111111101101b
    var_2c: dw 0x0101
    var_2d: dw 0xffcc

    var_3a: dw 0x015a
    var_3b: dw 0x0101
    var_3c: dw 0xacdc
    var_3d: dw 0xfedc

    var_4a: dd 1.375
    var_4b: dd 0.041015625
    var_4c: dd -571.3125
    var_4d: dd 4091.125


section .text
global _start

_start:
    nop
