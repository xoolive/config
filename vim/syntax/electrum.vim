
syn match   eleComment contains=@Spell "\s*//.*"
syn match   eleComment contains=@Spell "\s*--.*"
syn region  eleComment contains=@Spell start="/\*" end="\*/"
syn region  eleString contains=@Spell start=/"/ skip=/\\\\\|\\"/ end=/"/

syn keyword eleType fact sig var fun enum pred

syn keyword eleAttribute init private abstract

syn keyword eleStatement assert extends module open as run for check

syn keyword eleConstraint expect exactly but univ iden after always eventually
syn keyword eleConstraint sometime until

syn keyword eleBoolean true false none _static

syn keyword eleLogical all some one not set no lone let disj this iff
syn keyword eleLogical implies else or and in not


if version >= 508 || !exists("did_gm_syntax_inits")

  if version < 508
    let did_gm_syntax_inits = 1
    command -nargs=+ HiLink hi link <args>
  else
    command -nargs=+ HiLink hi def link <args>
  endif


  HiLink eleAttribute   Function
  HiLink eleBoolean     Special
  HiLink eleComment     Comment
  HiLink eleConstraint  Identifier
  HiLink eleLogical     Function
  HiLink eleStatement   Statement
  HiLink eleType        Identifier

  delcommand HiLink

endif

let b:current_syntax = "electrum"
