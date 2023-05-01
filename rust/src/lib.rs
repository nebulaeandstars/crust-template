use std::ffi::CStr;

#[no_mangle]
pub extern "C" fn rust_hello() {
    println!("hello from Rust!");
}

#[no_mangle]
pub extern "C" fn rust_say(s: *const i8) {
    let s = unsafe {
        CStr::from_ptr(s)
            .to_str()
            .expect(&format!("input is not valid UTF-8: {:?}", s))
    };
    println!("{}", s);
}
