%include "utils/asm.mac"

section .data
    snippet db "hello world"
    sn_len equ $-snippet

section .text

global _start

upper_one:
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
    loop_:
        call upper_one ; upper current
        inc rbx ; advance to next byte
        dec rcx ; decrement loop counter
        jnz loop_ ; continue until rcx contains 0
    ret

print:
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