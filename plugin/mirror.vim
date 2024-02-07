" TODO: is there a better way to handle this?
let s:toplevels = 'class\|interface\|struct\|trait\|impl'
let s:standardKeywordContext = s:toplevels . '\|function\|if\|else\|for\|while\|try\|catch\|finally\|enum'

" NOTE: semicolon can be used when there is no container (first branch),
" in a function container (first part of second branch) or in an arrow
" lambda (second part of second branch).
" The third part of the second branch is for supporting Typescript
" functions/methods with a return type
let s:semicolon_suffix = mirror#suffix#Define(';', {
    \   'after': ')]}',
    \   'onlyIfPresent': 1,
    \   'neverIfContextMatches': s:standardKeywordContext,
    \   'whenContainerMatches': '^$\|)\(\s\|=>\|\:\s*\w\+\)*{',
    \ })

let s:c_open = '([{'
let s:c_close = ')]}'
let s:c_suffixes = [ s:semicolon_suffix ]

let s:comma_suffix = mirror#suffix#Define(',', {
    \   'after': ']}',
    \   'neverIfContextMatches': s:standardKeywordContext,
    \   'neverIfContainerMatches': s:toplevels,
    \   'whenContainerMatches': '\s*\([\|{\)$',
    \ })

if maparg('<Plug>MirrorClose') ==# ''
    inoremap <silent> <SID>MirrorClose <C-R>=mirror#closer#Close()<CR>
    imap <script> <Plug>MirrorClose <SID>MirrorClose
endif

augroup mirror
  au!
  autocmd FileType javascript,javascript.jsx,typescript,typescript.tsx,typescript.jsx,typescriptreact
        \ let b:mirror_open = s:c_open . '`' |
        \ let b:mirror_close = s:c_close . '`' |
        \ let b:mirror_suffixes = s:c_suffixes + [s:comma_suffix] |
        \ call mirror#Enable()
  autocmd FileType c,cs,cpp,go,java,json,kotlin,objc,ruby,swift,css,less,scss,proto
        \ let b:mirror_open = s:c_open |
        \ let b:mirror_close = s:c_close |
        \ call mirror#Enable()
  autocmd FileType python
        \ let b:mirror_open = s:c_open |
        \ let b:mirror_close = s:c_close |
        \ let b:mirror_suffixes = [s:comma_suffix] |
        \ call mirror#Enable()
  autocmd FileType lua,rust
        \ let b:mirror_open = s:c_open |
        \ let b:mirror_close = s:c_close |
        \ let b:mirror_suffixes = s:c_suffixes + [s:comma_suffix] |
        \ call mirror#Enable()
augroup END

