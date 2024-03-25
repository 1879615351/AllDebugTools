#[flutter_rust_bridge::frb(sync)] // Synchronous mode for simplicity of the demo
pub fn greet(name: String) -> String {
    format!("Hello World!!!!!!!!!!!, {name}!")
}
#[flutter_rust_bridge::frb(sync)]
pub fn start_client1(id:String){
    println!("111");
    println!("id:{:?}",id);
}
#[flutter_rust_bridge::frb(init)]
pub fn init_app() {
    // Default utilities - feel free to customize
    flutter_rust_bridge::setup_default_user_utils();
}
