%include "utils/asm.inc"

section .bss
    buf_size equ 1024
    buf resb buf_size

section .text

global _start

upper_one:
    ; param rsi - byte to make upper
    push rdx
    mov dl, "a"
    cmp byte[rsi + rcx - 1], dl ; less than a, can not be converted
    jl .err
    mov dl, "z"
    cmp byte[rsi + rcx - 1], dl ; more than z, can not be converted
    jg .err
    sub byte[rsi + rcx - 1], 020H ; sub 32, ('a' - 'A')
    .err:
        pop rdx
        ret

upper:
    ; param rsi - string
    ; param rcx - string len
    .loop_:
        call upper_one ; upper current
        dec rcx ; 
        jnz .loop_
    ret

print:
    ; param rsi - string to print
    ; param rdx - string len
    push rax
    push rdi
    mov rax, SYS_WRITE
    mov rdi, FD_STDOUT
    syscall ; call
    pop rdi
    pop rax
    ret

load:
    ; param rsi - buffer
    ; param rdx - buffer length
    push rdi

    mov rax, SYS_READ
    mov rdi, FD_STDIN
    syscall

    pop rdi
    ret

_start:
    nop
    mov rsi, buf

    .lloop:
        mov rdx, buf_size
        call load
        cmp rax, 0 
        jz .success 
        jl .error
        
        mov rcx, rax
        call upper

        mov rdx, rax
        call print

        jmp .lloop
 
    .success:
        mov rdi, 0
        jmp .done
    .error:
        mov rdi, -1
    .done:
        mov rax, SYS_EXIT
        syscall
