use std::ffi::{CStr, CString};

#[no_mangle]
pub extern "C" fn test_rust() {
    println!("calling Rust from asm")
}

#[no_mangle]
pub extern "C" fn rust_main() {
    println!("hello from Rust!");
    say("hello from Rust again, using C!\n");

    unsafe {
        hello::asm_example();
    }
}

#[no_mangle]
pub unsafe extern "C" fn say_with_rust(s: *const i8) {
    let s = unsafe { CStr::from_ptr(s).to_str().unwrap() };
    print!("{}", s);
}

fn say(msg: impl AsRef<str>) {
    unsafe {
        let msg = CString::new(msg.as_ref().as_bytes()).unwrap();
        hello::say(msg.as_ptr());
    }
}

mod hello {
    extern "C" {
        pub fn say(s: *const i8);
    }

    extern "C" {
        pub fn asm_example();
    }
}
