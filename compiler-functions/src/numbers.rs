use std::error;

pub enum Base { 
    Bin = 2,
    Dec = 10,
    Hex = 16,
}


pub fn parse(str_value: &str, base: Base) -> Result<i128, ()> { 
    let base = base as u32;
    println!("Parsing {} with base {}", str_value, base);
    Ok(i128::from_str_radix(str_value, base).unwrap())
}