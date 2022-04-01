%include "utils/asm.inc"

section .data
    snippet db "hello world",NEWLINE
    sn_len equ $-snippet

section .text

global _start

upper_one:
    ; param rbx - byte to make upper
    mov dl, "a"
    cmp byte[rbx], dl ; less than a, can not be converted
    jl err
    mov dl, "z"
    cmp byte[rbx], dl ; more than z, can not be converted
    jg err
    sub byte[rbx], 020H ; sub 32, ('a' - 'A')
    err:
        ret

upper:
    ; param rbx - string
    ; param rcx - string len
    loop_:
        call upper_one ; upper current
        inc rbx ; advance to next byte
        loop loop_ ; continue until rcx contains 0
    ret

print:
    ; param rsi - string to print
    ; param rdx - string len
    mov rax, SYS_WRITE
    mov rdi, FD_STDOUT
    syscall ; call
    ret

_start:
    nop
    mov rbx, snippet
    mov rcx, sn_len
    call upper

    mov rdx, sn_len
    mov rsi, snippet
    call print

    mov rax, SYS_EXIT
    mov rdi, 0
    syscall

section .bss