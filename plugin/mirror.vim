" NOTE: semicolon can be used when there is no container (first branch),
" in a function container (first half of " second branch) or in an arrow
" lambda (second half of second branch)
let s:semicolon_suffix = mirror#suffix#Define(';', {
    \   'after': ')]}',
    \   'onlyIfPresent': 1,
    \   'neverIfContextMatches': 'function\|class\|interface\|if\|else',
    \   'whenContainerMatches': '^$\|)\(\s\|=>\)*{',
    \ })

let s:c_open = '([{'
let s:c_close = ')]}'
let s:c_suffixes = [ s:semicolon_suffix ]

let s:comma_suffix = mirror#suffix#Define(',', {
    \   'after': ']}',
    \   'neverIfContextMatches': 'function\|class\|interface\|if\|else',
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

