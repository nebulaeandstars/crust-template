#include <stdio.h>
#include "hello.h"

extern void rust_main();
extern void asm_example();
extern void say_with_rust(char* s);

void test_fn() {
    say_with_rust("hello from C again, using Rust!\n");
}

int main() {
    say("hello from C!\n");
    rust_main();
    say_with_rust("hello from C again, using Rust!\n");
    asm_example();
}
