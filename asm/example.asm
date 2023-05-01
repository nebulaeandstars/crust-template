extern say
extern say_with_rust

NULL equ 0
NEWLINE equ 10

SECTION .DATA
    hello_c: db 'hello from NASM, using C!', NEWLINE, NULL
    hello_rs: db 'hello from NASM, using Rust!', NEWLINE, NULL

SECTION .text
    global asm_example

asm_example:
    ; make sure that the stack is aligned
    push 0

    mov rdi, hello_c
    call say
    mov rdi, hello_rs
    call say_with_rust

    pop rax
    ret
