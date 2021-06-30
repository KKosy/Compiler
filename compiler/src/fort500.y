%start Expr
%avoid_insert "FUNCTION"
%avoid_insert "SUBROUTINE"
%avoid_insert "END"
%avoid_insert "INTEGER"  
%avoid_insert "REAL"
%avoid_insert "LOGICAL"
%avoid_insert "CHARACTER"
%avoid_insert "RECORD"
%avoid_insert "ENDRECORD"
%avoid_insert "DATA"
%avoid_insert "CONTINUE"
%avoid_insert "GOTO"
%avoid_insert "CALL"
%avoid_insert "READ"
%avoid_insert "WRITE"
%avoid_insert "IF"
%avoid_insert "THEN"
%avoid_insert "ELSE"
%avoid_insert "ENDIF"
%avoid_insert "DO"
%avoid_insert "ENDDO"
%avoid_insert "STOP"
%avoid_insert "RETURN"
%avoid_insert "ID"
%avoid_insert "CONST_INTEGER"
%avoid_insert "CONST_BINARY"
%avoid_insert "CONST_HEX"
%avoid_insert "CONST_REAL_INTEGER_FULL"
%avoid_insert "CONST_REAL_INTEGER_LEFT"
%avoid_insert "CONST_REAL_INTEGER_RIGHT"
%avoid_insert "CONST_REAL_BINARY_FULL"
%avoid_insert "CONST_REAL_BINARY_LEFT"
%avoid_insert "CONST_REAL_HEX_FULL"
%avoid_insert "CONST_REAL_HEX_LEFT"
%avoid_insert "LCONST_TRUE"
%avoid_insert "LCONST_FALSE"
%avoid_insert "CCONST_ASCII"
%avoid_insert "CCONST_CHAR"
%avoid_insert "OROP"
%avoid_insert "ANDOP"
%avoid_insert "NOTOP"
%avoid_insert "COMMENT"

%%
// THE CODE HERE IS FOR A BASIC EXAMPLE AS PROOF OF CONCEPT
// THIS IS NOT THE FORT500 LANGUAGE DEFINITION!

Expr -> Result<i128, ()>:
      Assign         { $1 }
    | Numeric_Expr   { $1 }
    ;

Assign -> Result<i128, ()>:
      'ID' '=' Numeric_Expr   { let v = $1.map_err(|_| ())?; Ok(variables::add_variable($lexer.span_str(v.span()), $3?)) }
    ;

Numeric_Expr -> Result<i128, ()>:
      Number '+' Numeric_Expr { Ok($1? + $3?) }
    | Number '-' Numeric_Expr { Ok($1? - $3?) }
    | Number '*' Numeric_Expr { Ok($1? * $3?) }
    | Number '/' Numeric_Expr { Ok($1? / $3?) } 
    | '(' Numeric_Expr ')'    { $2 }
    | Number { $1 }
    ;

Number -> Result<i128, ()>:
      'CONST_BINARY'   { let v = $1.map_err(|_| ())?; numbers::parse($lexer.span_str(v.span()), numbers::Base::Bin) }
    | 'CONST_INTEGER'  { let v = $1.map_err(|_| ())?; numbers::parse($lexer.span_str(v.span()), numbers::Base::Dec) }
    | 'CONST_HEX'      { let v = $1.map_err(|_| ())?; numbers::parse($lexer.span_str(v.span()), numbers::Base::Hex) }
    | 'ID'             { let v = $1.map_err(|_| ())?; Ok(variables::get_variable($lexer.span_str(v.span()))) }
    ;

%%
// Any functions here are in scope for all the grammar actions above.

use compiler_functions::*;
use std::error;