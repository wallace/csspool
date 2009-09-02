class CSSPool::CSS::Parser

token CHARSET_SYM IMPORT_SYM STRING SEMI IDENT S COMMA

rule
  document
    : { @document.start_document }
      stylesheet
      { @document.end_document }
    ;
  stylesheet
    : charset import
    ;
  charset
    : CHARSET_SYM STRING SEMI { @document.charset val[1][1..-2] }
    |
    ;
  import
    : IMPORT_SYM STRING S medium SEMI
      {
        @document.import_style [val[3]].flatten, val[1][1..-2]
      }
    | IMPORT_SYM STRING SEMI { @document.import_style [], val[1][1..-2] }
    |
    ;
  medium
    : medium COMMA IDENT { result = [val.first, val.last] }
    | IDENT
    ;