use std::{collections::HashMap, sync::Mutex};

use lazy_static::lazy_static;

lazy_static! { 
    pub static ref FUNCTIONS: Mutex<HashMap<String, String>> = Default::default();
}

pub fn add_function(name: &str, function_code: &str) -> String {
    let mut functions = FUNCTIONS.lock().unwrap();
    functions.insert(name.to_string(), function_code.to_string());
    function_code.to_string();
    todo!();
}

// pub fn run_function(name: &str) -> i128 { 
//     *VARIABLES.lock().unwrap().get(&name.to_string()).unwrap_or(&0)
// }