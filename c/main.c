#include <stdio.h>
#include "hello.h"

extern void rust_hello();
extern void rust_say(char* s);

int main() {
    char* message = "hello from C!\n";
    char* rust_message = "hello from C again, using Rust!\n";

    say(message);
    rust_hello();
    rust_say(rust_message);
}
