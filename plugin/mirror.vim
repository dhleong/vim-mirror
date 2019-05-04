" NOTE: semicolon can be used when there is no container (first branch),
" in a function container (first part of second branch) or in an arrow
" lambda (second part of second branch).
" The third part of the second branch is for supporting Typescript
" functions/methods with a return type
let s:semicolon_suffix = mirror#suffix#Define(';', {
    \   'after': ')]}',
    \   'onlyIfPresent': 1,
    \   'neverIfContextMatches': 'function\|class\|interface\|if\|else\|for\|while',
    \   'whenContainerMatches': '^$\|)\(\s\|=>\|\:\s*\w\+\)*{',
    \ })

let s:c_open = '([{'
let s:c_close = ')]}'
let s:c_suffixes = [ s:semicolon_suffix ]

let s:comma_suffix = mirror#suffix#Define(',', {
    \   'after': ']}',
    \   'neverIfContextMatches': 'function\|class\|interface\|if\|else\|for\|while',
    \   'neverIfContainerMatches': 'class\|interface',
    \   'whenContainerMatches': '\s*\([\|{\)$',
    \ })

augroup mirror
  au!
  autocmd FileType javascript,typescript
        \ let b:mirror_open = s:c_open . '`' |
        \ let b:mirror_close= s:c_close . '`' |
        \ let b:mirror_suffixes = s:c_suffixes + [s:comma_suffix] |
        \ call mirror#Enable()
augroup END

