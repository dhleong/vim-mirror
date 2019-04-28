let s:c_open = '([{'
let s:c_close = ')]}'
let s:c_suffixes = [
    \   mirror#suffix#Define(';', {
    \     'after': ')]}',
    \     'onlyIfPresent': 1,
    \     'neverIfContextMatches': 'function\|class\|interface\|if\|else',
    \     'whenContainerMatches': ')\s*{',
    \   })
    \ ]

augroup mirror
  au!
  autocmd FileType javascript,typescript
        \ let b:mirror_open = s:c_open . '`' |
        \ let b:mirror_close= s:c_close . '`' |
        \ let b:mirror_suffixes = s:c_suffixes |
        \ call mirror#Enable()
augroup END

