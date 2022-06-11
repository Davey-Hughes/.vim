" this file contains settings shared by the C family languages

" indenting
setlocal noexpandtab
setlocal copyindent
setlocal softtabstop=0
setlocal shiftwidth=8
setlocal tabstop=8

" enable highlighting of C++11 attributes
let g:cpp_attributes_highlight = 1

" highlight struct/class member variables (affects both C and C++ files)
let g:cpp_member_highlight = 1

" clang format
let g:clang_format#auto_format=1

" clang format style
" replace with default .clang-format possible when vim-clang-format allows
let g:clang_format#style_options={
    \ "IndentWidth": 8,
    \ "ContinuationIndentWidth": 8,
    \ "UseTab": "AlignWithSpaces",
    \ "IndentCaseLabels": "false",
    \
    \ "AllowShortIfStatementsOnASingleLine": "false",
    \
    \ "DerivePointerAlignment": "false",
    \ "PointerAlignment": "Right",
    \
    \ "AlwaysBreakAfterReturnType": "TopLevelDefinitions",
    \ "BreakBeforeBraces": "Custom",
    \ "BraceWrapping": {
        \ "AfterCaseLabel": "false",
        \ "AfterClass": "false",
        \ "AfterControlStatement": "false",
        \ "AfterEnum": "false",
        \ "AfterFunction": "true",
        \ "AfterNamespace": "false",
        \ "AfterStruct": "false",
        \ "AfterUnion": "false",
        \ "AfterExternBlock": "false",
        \ "BeforeCatch": "false",
        \ "BeforeElse": "false",
        \ "BeforeLambdaBody": "false",
        \ "BeforeWhile": "false"
    \ },
    \
    \ "AllowShortFunctionsOnASingleLine": "Inline",
    \
    \ "ColumnLimit": 120,
    \
    \ "AlignTrailingComments": "true",
    \ "ReflowComments": "true",
    \
    \ "EmptyLineBeforeAccessModifier": "Always",
    \ "AccessModifierOffset": -8,
    \
    \ "SpaceAfterCStyleCast": "true",
    \ "SpacesBeforeTrailingComments": 1,
    \ "SpaceBeforeRangeBasedForLoopColon": "false",
    \
    \ "SortIncludes": "CaseInsensitive",
\ }
