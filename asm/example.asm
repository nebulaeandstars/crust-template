extern say
extern say_with_rust
extern test_rust

NULL equ 0
NEWLINE equ 10

SECTION .DATA
    hello_c: db 'hello from NASM, using C!', NEWLINE, NULL
    hello_rs: db 'hello from NASM, using Rust!', NEWLINE, NULL

SECTION .text
    global asm_example

asm_example:
    mov rdi, hello_c
    call say

    call test_rust
    ret
