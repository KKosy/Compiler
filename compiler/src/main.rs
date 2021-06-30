use std::io::{self, BufRead, Write};

use lrlex::lrlex_mod;
use lrpar::lrpar_mod;

// Using `lrlex_mod!` brings the lexer for `fort500.l` into scope. By default the module name
// will be `fort500_l` (i.e. the file name, minus any extensions, with a suffix of `_l`).
lrlex_mod!("fort500.l");
// Using `lrpar_mod!` brings the parser for `fort500.y` into scope. By default the module name
// will be `fort500_y` (i.e. the file name, minus any extensions, with a suffix of `_y`).
lrpar_mod!("fort500.y");

fn main() {
    // Get the `LexerDef` for the `fort500` language.
    let lexerdef = fort500_l::lexerdef();

    let stdin = io::stdin();
    loop {
        print!(">>> ");
        io::stdout().flush().ok();
        match stdin.lock().lines().next() {
            Some(Ok(ref l)) => {
                if l.trim().is_empty() {
                    continue;
                }
                // Now we create a lexer with the `lexer` method with which we can lex an input.
                let lexer = lexerdef.lexer(l);
                // Pass the lexer to the parser and lex and parse the input.
                let (res, errs) = fort500_y::parse(&lexer);
                for e in errs {
                    println!("{}", e.pp(&lexer, &fort500_y::token_epp));
                }
                match res {
                    Some(Ok(r)) => println!("Result: {}", r),
                    _ => eprintln!("Unable to evaluate expression.")
                }
            }
            _ => break
        }
    }
}