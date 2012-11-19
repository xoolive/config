" Highlight for GAMME files
" syntax/gamme.vim

if version >= 508 || !exists("did_gm_syntax_inits")

  if version < 508
    let did_gm_syntax_inits = 1
    command -nargs=+ HiLink hi link <args>
  else
    command -nargs=+ HiLink hi def link <args>
  endif

  syntax match   gmComment     contains=@Spell "\s*--.*"
  syntax match   gmComment     contains=gmComment,@Spell "\s*//.*"
  syntax match   gmInstruction contains=@Spell "@[A-Za-z]*"

  syntax region  gmString contains=@Spell start=/"/ skip=/\\\\\|\\"/ end=/"/
  syntax region  gmSQuote contains=@Spell start=/'/ skip=/\\\\\|\\"/ end=/'/

  syntax keyword gmStructure model class enum type
  syntax keyword gmAttribute DateTime DTime String Double Integer DSpeed DLength DMass Boolean
  syntax keyword gmStatement import is in with extends attr val tree unique ref

  HiLink gmStructure     Structure
  HiLink gmStatement     Statement
  HiLink gmAttribute     Function
  HiLink gmInstruction   Identifier
  HiLink gmComment       Comment
  HiLink gmString        String
  HiLink gmSQuote        Normal
  HiLink gmAttrName      Special

  delcommand HiLink

endif

let b:current_syntax = "gamme"


