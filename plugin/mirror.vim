augroup mirror
  au!
  autocmd FileType javascript,typescript
        \ let b:mirror_open = '([{`' |
        \ let b:mirror_close= ')]}`' |
        \ call mirror#Enable()
augroup END

