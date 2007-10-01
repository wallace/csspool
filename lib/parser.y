class CSS::SAC::GeneratedParser

token FUNCTION INCLUDES DASHMATCH LBRACE HASH PLUS GREATER IDENT S STRING IDENT
token COMMA URI CDO CDC NUMBER PERCENTAGE LENGTH EMS EXS ANGLE TIME FREQ
token IMPORTANT_SYM IMPORT_SYM MEDIA_SYM PAGE_SYM CHARSET_SYM

rule
  stylesheet
    : s_cdo_cdc_0toN CHARSET_SYM STRING ';' import_0toN ruleset_media_page_0toN
    | s_cdo_cdc_0toN import_0toN ruleset_media_page_0toN
    ;
  ruleset_media_page_0toN
    : ruleset s_cdo_cdc_0toN ruleset_media_page_0toN
    | media s_cdo_cdc_0toN ruleset_media_page_0toN
    | page s_cdo_cdc_0toN ruleset_media_page_0toN
    | ruleset s_cdo_cdc_0toN
    | media s_cdo_cdc_0toN
    | page s_cdo_cdc_0toN
    |
    ;
  import
    : IMPORT_SYM s_0toN string_or_uri s_0toN medium_0toN ';' s_0toN {
        self.document_handler.import_style(val[2], val[4] || [])
      }
    ;
  ignorable_at
    : '@' IDENT s_0toN string_or_uri s_0toN medium_0toN ';' s_0toN {
        self.document_handler.ignorable_at_rule(val[1])
      }
    ;
  import_0toN
    : import s_cdo_cdc_0toN import_0toN
    : ignorable_at s_cdo_cdc_0toN import_0toN
    |
    ;
  media
    : MEDIA_SYM s_0toN medium_rollup LBRACE s_0toN ruleset_0toN '}' s_0toN {
        self.document_handler.end_media(val[2])
      }
    ;
  medium_rollup
    : medium_1toN { self.document_handler.start_media(val.first) }
    ;
  medium
    : IDENT s_0toN
    ;
  medium_0toN
    : medium_1toN
    |
    ;
  medium_1toN
    : medium COMMA s_0toN medium_1toN { result = [val.first, val.last].flatten }
    | medium { result = [val.first] }
    ;
  page
    : page_start s_0toN LBRACE s_0toN declaration_1toN '}' s_0toN {
        page_stuff = val.first
        self.document_handler.end_page(page_stuff[0], page_stuff[1])
      }
    ;
  page_start
    : PAGE_SYM s_0toN optional_page optional_pseudo_page {
        result = [val[2], val[3]]
        self.document_handler.start_page(val[2], val[3])
      }
    ;
  optional_page
    : IDENT
    |
    ;
  optional_pseudo_page
    : ':' IDENT { result = val[1] }
    |
    ;
  operator
    : '/' s_0toN
    | COMMA s_0toN
    |
    ;
  combinator
    : PLUS s_0toN
    | GREATER s_0toN
    | S
    ;
  unary_operator
    : '-' | PLUS
    ;
  property
    : IDENT s_0toN
    ;
  ruleset
    : selector_1toN LBRACE s_0toN declaration_1toN '}' s_0toN {
        self.document_handler.end_selector(val.first)
      }
    ;
  ruleset_0toN
    : ruleset ruleset_0toN
    | ruleset
    |
    ;
  selector
    : simple_selector_1toN { self.document_handler.start_selector(val.first) }
    ;
  selector_1toN
    : selector COMMA s_0toN selector_1toN
    | selector
    ;
  simple_selector
    : element_name hcap_0toN
    | hcap_1toN
    ;
  simple_selector_1toN
    : simple_selector combinator simple_selector_1toN {
        result = [val.first, val.last].flatten
      }
    | simple_selector { result = [val.first] }
    ;
  class
    : '.' IDENT
    ;
  element_name
    : IDENT | '*'
    ;
  attrib
    : '[' s_0toN IDENT s_0toN attrib_val_0or1 ']'
    ;
  pseudo
    : ':' FUNCTION s_0toN IDENT s_0toN ')'
    | ':' FUNCTION s_0toN s_0toN ')'
    | ':' IDENT
    ;
  declaration
    : property ':' s_0toN expr prio_0or1 {
        self.document_handler.property(val.first, val[3], !val[4].nil?)
      }
    |
    ;
  declaration_1toN
    : declaration ';' s_0toN declaration_1toN
    | declaration
    ;
  prio
    : IMPORTANT_SYM s_0toN
    ;
  prio_0or1
    : prio
    |
    ;
  expr
    : term operator expr { result = [val.first, val.last].flatten }
    | term { result = [val.first] }
    ;
  term
    : unary_operator num_or_length {
        result = val.last
        if val.first == '-' && !Number::NON_NEGATIVE_UNITS.include?(result.lexical_unit_type)
          result.float_value = (0 - result.float_value)
          result.integer_value = (0 - result.integer_value)
        end
      }
    | num_or_length
    | STRING s_0toN { result = LexicalString.new(val.first) }
    | IDENT s_0toN { result = LexicalIdent.new(val.first) }
    | URI s_0toN { result = LexicalURI.new(val.first) }
    | hexcolor { result = LexicalColor.new(val.first) }
    | function
    ;
  num_or_length
    : NUMBER s_0toN { result = Number.new(val.first, '', :SAC_INTEGER) }
    | PERCENTAGE s_0toN { result = Number.new(val.first) }
    | LENGTH s_0toN { result = Number.new(val.first) }
    | EMS s_0toN { result = Number.new(val.first) }
    | EXS s_0toN { result = Number.new(val.first) }
    | ANGLE s_0toN { result = Number.new(val.first) }
    | TIME s_0toN { result = Number.new(val.first) }
    | FREQ s_0toN { result = Number.new(val.first) }
    ;
  function
    : FUNCTION s_0toN expr ')' s_0toN { result = "#{val[0]}#{val[2]}#{val[3]}" }
    ;
  hexcolor
    : HASH s_0toN
    ;
  hcap_0toN
    : hcap_1toN
    |
    ;
  hcap_1toN
    : HASH hcap_1toN
    | class hcap_1toN
    | attrib hcap_1toN
    | pseudo hcap_1toN
    | HASH
    | class
    | attrib
    | pseudo
    ;
  attrib_val_0or1
    : eql_incl_dash s_0toN IDENT s_0toN
    | eql_incl_dash s_0toN STRING s_0toN
    |
    ;
  eql_incl_dash
    : '='
    | INCLUDES
    | DASHMATCH
    ;
  string_or_uri
    : STRING
    | URI
    ;
  s_cdo_cdc_0toN
    : S s_cdo_cdc_0toN
    | CDO s_cdo_cdc_0toN
    | CDC s_cdo_cdc_0toN
    | S
    | CDO
    | CDC
    |
    ;
  s_0toN
    : S s_0toN
    |
    ;
end
