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

    if get(g:, 'mirror_no_mappings', 0) == 1
        return
    endif

    let oldmap = maparg('<CR>', 'i')

    if oldmap =~# '^<Lua '
        " Mapping has been set by a lua fn. We can't do anything about
        " that at this time without possibly clobbering other <CR> mappings.
    elseif oldmap =~# 'MirrorClose'
        " Already mapped. maybe the user was playing with `set ft`
    elseif oldmap !=# ''
        exe 'imap <CR> ' . oldmap . '<Plug>MirrorClose'
    else
        imap <CR> <CR><Plug>MirrorClose
    endif
endfunc
