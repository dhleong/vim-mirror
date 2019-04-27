if maparg('<Plug>MirrorClose') ==# ''
    inoremap <silent> <SID>MirrorClose <C-R>=mirror#closer#Close()<CR>
    imap <script> <Plug>MirrorClose <SID>MirrorClose
endif

func! mirror#Config()
    let open = get(b:, 'mirror_open', '')
    if open ==# ''
        " quick reject
        return {}
    endif

    let config = {}
    let config.open = open
    let config.close = get(b:, 'mirror_close', '')
    let config.suffixes = get(b:, 'mirror_suffixes', [])

    return config
endfunc

func! mirror#Enable()
    if get(b:, 'mirror_open', '') ==# ''
        return
    endif

    let oldmap = maparg('<CR>', 'i')

    if oldmap =~# 'MirrorClose'
        " already mapped. maybe the user was playing with `set ft`
    elseif oldmap !=# ''
        exe 'imap <CR> ' . oldmap . '<Plug>MirrorClose'
    else
        imap <CR> <CR><Plug>MirrorClose
    endif
endfunc
