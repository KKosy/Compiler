use std::{collections::HashMap, sync::Mutex};

use lazy_static::lazy_static;

lazy_static! { 
    pub static ref VARIABLES: Mutex<HashMap<String, i128>> = Default::default();
}

pub fn add_variable(name: &str, value: i128) -> i128 {
    let mut variables = VARIABLES.lock().unwrap();
    variables.insert(name.to_string(), value);
    value
}

pub fn get_variable(name: &str) -> i128 { 
    *VARIABLES.lock().unwrap().get(&name.to_string()).unwrap_or(&0)
}