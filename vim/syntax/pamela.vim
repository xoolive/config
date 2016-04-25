syn match   elaComment contains=@Spell "\s*//.*"
syn region  elaComment contains=@Spell start="/\*" end="\*/"

syn keyword elaStructure include class extends reference attribute method
syn keyword elaStructure objects set add define property
syn match   elaCardinality contains=@Spell "\v\[([0-9]+|*)..([0-9]+|*)\]"
syn keyword elaAttribute unknown attribute
syn keyword elaStatement constraint optimize
syn keyword elaConstraint same opposite segregation collocation symmetry
syn keyword elaConstraint allowed mandatory minCard maxCard
syn keyword elaConstraint sumMinCard sumMaxCard sumMaxCapacity
syn keyword elaConstraint packagingCapacity path used
syn keyword elaObjective MinMappings MaxMappings MinConstraint MaxConstraints
syn keyword elaObjective MinWeight MaxWeight CableWeight RdcWeight TotalWeight
syn keyword elaBoolean true false
syn keyword elaLogical and or not
syn region  elaString contains=@Spell start=/"/ skip=/\\\\\|\\"/ end=/"/


if version >= 508 || !exists("did_gm_syntax_inits")

  if version < 508
    let did_gm_syntax_inits = 1
    command -nargs=+ HiLink hi link <args>
  else
    command -nargs=+ HiLink hi def link <args>
  endif

  HiLink elaStructure   Structure
  HiLink elaComment     Comment
  HiLink elaAttribute   Function
  HiLink elaStatement   Statement
  HiLink elaBoolean     Special
  HiLink elaCardinality Number
  HiLink elaConstraint  Identifier
  HiLink elaObjective   Identifier
  HiLink elaLogical     Function

  delcommand HiLink

endif

let b:current_syntax = "pamela"
