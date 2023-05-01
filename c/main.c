#include <stdio.h>
#include "hello.h"

extern void run();
extern void say_with_rust(char* s);

int main() {
    say("hello from C!\n");
    run();
    say_with_rust("hello from C again, using Rust!\n");
}
