" Highlight for SMT2 files
" syntax/smt2.vim

syn match   smtComment  contains=@Spell "\v\s*;.*"
syn match   smtTypes    /\v[A-Z][a-z\-\.]*/
syn match   smtLogic    contains=@Spell "\vQF_.*"
syn match   smtOption   contains=@Spell "\v\:[A-Za-z\-\.]*"
syn match   smtSymbols  /\v[=><~&|+\-\*\/%@#]+/

syn match   smtNumber   /\v[0-9]*\.[0-9]+([eE][\-+]?[0-9]+)?/
syn match   smtNumber   /\v0[xX][0-9a-fA-F]+/
syn match   smtNumber   /\v#[xX][0-9a-fA-F]+/
syn match   smtNumber   /\v#b[0-1]+/
syn match   smtNumber   /\v<[0-9]+/

syn keyword smtKeywords define-fun define-const assert push pop apply !
syn keyword smtKeywords check-sat declare-const declare-fun get-model
syn keyword smtKeywords get-value declare-sort declare-datatypes reset
syn keyword smtKeywords set-logic help get-assignment exit get-proof eval
syn keyword smtKeywords get-unsat-core echo let forall exists define-sort
syn keyword smtKeywords set-option get-option set-info check-sat-using
syn keyword smtKeywords simplify elim-quantifiers display as get-info
syn keyword smtKeywords declare-map declare-rel declare-var rule query
syn keyword smtKeywords get-user-tactics minimize maximize assert-soft

syn keyword smtBuiltins mod div rem ^ to_real and or not distinct to_int is_int
syn keyword smtBuiltins ~ xor if ite true false root-obj sat unsat const map
syn keyword smtBuiltins store select sat unsat bit1 bit0 bvneg bvadd bvsub bvmul
syn keyword smtBuiltins bvsdiv bvudiv bvsrem bvurem bvsmod bvule bvsle bvuge
syn keyword smtBuiltins bvsge bvult bvslt bvugt bvsgt bvand bvor bvnot bvxor
syn keyword smtBuiltins bvnand bvnor bvxnor concat sign_extend zero_extend
syn keyword smtBuiltins extract repeat bvredor bvredand bvcomp bvshl bvlshr
syn keyword smtBuiltins bvashr rotate_left rotate_right get-assertions

syn region  smtString   contains=@Spell start=/"/ skip=/\\\\\|\\"/ end=/"/

if version >= 508 || !exists("did_smt2_syntax_inits")

  if version < 508
    let did_smt2_syntax_inits = 1
    command -nargs=+ HiLink hi link <args>
  else
    command -nargs=+ HiLink hi def link <args>
  endif

  HiLink smtBuiltins  Statement
  HiLink smtComment   Comment
  HiLink smtKeywords  Function
  HiLink smtLogic     Special
  HiLink smtNumber    Number
  HiLink smtOption    Special
  HiLink smtString    String
  HiLink smtSymbols   Special
  HiLink smtTypes     Identifier

  delcommand HiLink

endif

let b:current_syntax = "smt2"


