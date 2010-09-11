" Vim color file
" Maintainer:   Kamil Wojcicki

set background=dark
if version > 580
    hi clear
    if exists("syntax_on")
	syntax reset
    endif
endif

let g:colors_name="booyah"

hi MoreMsg         term=bold ctermfg=2 gui=bold guifg=SeaGreen
hi ModeMsg         term=bold cterm=bold gui=bold
hi Question        term=standout ctermfg=2 gui=bold guifg=SeaGreen
hi WarningMsg      term=standout ctermfg=1 guifg=Red
hi WildMenu        term=standout ctermfg=0 ctermbg=3 guifg=Black guibg=Yellow
hi DiffAdd         term=bold ctermbg=4 guibg=LightBlue
hi DiffChange      term=bold ctermbg=5 guibg=LightMagenta
hi DiffDelete      term=bold cterm=bold ctermfg=4 ctermbg=6 gui=bold guifg=Blue guibg=LightCyan
hi DiffText        term=reverse cterm=bold ctermbg=1 gui=bold guibg=Red
hi SignColumn      term=standout ctermfg=4 ctermbg=7 guifg=DarkBlue guibg=Grey
hi Cursor          guifg=bg guibg=fg
hi lCursor         guifg=bg guibg=fg
hi Underlined      term=underline cterm=underline ctermfg=5 gui=underline guifg=SlateBlue
hi Ignore          cterm=bold ctermfg=7 guifg=bg

hi Normal	       guibg=#0E0E0E   guifg=#969696

hi Visual          term=reverse cterm=none ctermfg=7 gui=reverse guifg=#122F42 guibg=fg
hi VisualNOS       term=bold,underline cterm=bold,underline gui=bold,underline


hi Title           term=bold cterm=none ctermfg=2 gui=bold guifg=#277725
"#A46B00

"hi Folded          term=standout ctermfg=2 ctermbg=none guifg=#277725 guibg=#0E0E0E
"hi FoldColumn      term=standout ctermfg=2 ctermbg=none guifg=#277725 guibg=#0E0E0E
hi Folded          term=standout ctermfg=Blue ctermbg=none guifg=#1E4D71 guibg=#0E0E0E
hi FoldColumn      term=standout ctermfg=Blue ctermbg=none guifg=#1E4D71 guibg=#0E0E0E
hi VertSplit       term=none cterm=none ctermbg=none ctermfg=Blue  gui=none guifg=#0E0E0E guibg=#0E0E0E
hi Identifier      term=underline cterm=bold ctermfg=2 guifg=#277725

hi IncSearch       term=reverse cterm=reverse gui=reverse
hi Search          term=reverse cterm=underline ctermbg=none ctermfg=white  gui=underline guibg=#0E0E0E guifg=white

hi SpecialKey      term=bold ctermfg=4 guifg=#2A6FA2
hi Directory       term=bold ctermfg=4 guifg=#2A6FA2
hi ErrorMsg        term=standout cterm=bold ctermfg=7 ctermbg=1 guifg=#969696 guibg=#550000
hi Error           term=reverse cterm=bold ctermfg=7 ctermbg=1 guifg=#969696 guibg=#550000
hi Todo            term=standout ctermfg=0 ctermbg=3 guifg=#2A6FA2 guibg=Yellow

hi NonText         term=bold cterm=bold ctermfg=4 gui=bold guifg=#1E4D71
hi LineNr          term=underline ctermfg=Blue guifg=#1D4968
"#1E4D71
hi Constant        term=underline ctermfg=1 guifg=#993311
hi Comment         term=bold cterm=bold ctermfg=Blue guifg=#2A6FA2
hi String          term=underline ctermfg=1 guifg=#993311
hi Number          term=underline ctermfg=1 guifg=#840000
hi Keyword         term=bold ctermfg=3 gui=bold guifg=#B1A611
hi Statement       term=bold ctermfg=3 gui=none guifg=#B1A611
hi Type            term=underline ctermfg=2 gui=none guifg=#34AD32
hi Special         term=bold ctermfg=5 guifg=#B218B2
hi PreProc         term=underline ctermfg=5 guifg=#7737C5
hi Include         term=underline ctermfg=5 guifg=#B218B2

hi StatusLine      term=bold cterm=reverse ctermfg=7 ctermbg=black gui=reverse guifg=#777777 guibg=#030303
hi StatusLineNC    term=bold cterm=reverse ctermfg=7 ctermbg=black gui=reverse guifg=#777777 guibg=#030303
"hi StatusLineNC    term=bold cterm=none ctermfg=12 ctermbg=black gui=none guifg=#A4A4A4 guibg=#222222


hi cCommentL       term=bold cterm=bold ctermfg=Blue guifg=#2A6FA2
hi cCommentStart   term=bold cterm=bold ctermfg=Blue guifg=#1E4D71
hi cComment        term=bold cterm=bold ctermfg=Blue guifg=#2A6FA2

"cCommentError   links to cError

hi Structure       term=underline cterm=none ctermfg=6 guifg=#5D9FBC

"Character       links to Constant
"Boolean         links to Constant
"Float           links to Number
"Function        links to Identifier
"Conditional     links to Statement
"Repeat          links to Statement
"Label           links to Statement
"Operator        links to Statement
"Exception       links to Statement
"Include         links to PreProc
"Define          links to PreProc
"Macro           links to PreProc
"PreCondit       links to PreProc
"Tag             links to Special
"SpecialChar     links to Special
"Delimiter       links to Special
"SpecialComment  links to Special
"Debug           links to Special
"cStatement      links to Statement
"cLabel          links to Label
"cConditional    links to Conditional
"cRepeat         links to Repeat
"cTodo           links to Todo
"cSpecial        links to SpecialChar
"cFormat         links to cSpecial
"cString         links to String
"cCppString      links to cString
"cCharacter      links to Character
"cSpecialError   links to cError
"cSpecialCharacter  links to cSpecial
"cParenError     links to cError
"cIncluded       links to cString
"cCommentSkip    links to cComment
"cCommentString  links to cString
"cComment2String  links to cString
"cCommentStartError  links to cError
"cUserLabel      links to Label
"cOctalZero      links to PreProc
"cCppOut         links to Comment
"cCppOut2        links to cCppOut
"cCppSkip        links to cCppOut
"cNumber         links to Number
"cFloat          links to Float
"cOctal          links to Number
"cOctalError     links to cError
"cErrInBracket   links to cError
"cErrInParen     links to cError
"cSpaceError     links to cError
"cOperator       links to Operator
"cType           links to Type
"cStructure      links to Structure
"cStorageClass   links to StorageClass
"cConstant       links to Constant
"cPreCondit      links to PreCondit
"cInclude        links to Include
"cDefine         links to Macro
"cPreProc        links to PreProc
"cError          links to Error
"cppStatement    links to Statement



"vim:ts=4:tw=4

