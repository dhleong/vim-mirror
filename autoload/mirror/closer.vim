func! s:extractSuffix(config)
    for suffix in a:config.suffixes
        let s = suffix.Extract()
        if s !=# ''
            return s
        endif
    endfor

    return ''
endfunc

func! mirror#closer#Close()
    " NOTE: returns keys to type

    let config = mirror#Config()
    if empty(config)
        return ''
    endif

    " if we aren't now on an empty line, we hit enter
    " in the middle of a line, and should not do anything
    if getline('.') !~# '^\s*$'
        return ''
    endif

    let line = mirror#line#Get()
    let indent = matchstr(line, '^\s*')

    let mirroredTags = mirror#extract#Extract(config, line)
    if mirroredTags ==# ''
        " no tags? do nothing
        return ''
    endif

    let nextLineNr = line('.') + 1
    let nextLine = getline(nextLineNr)
    if nextLine =~# '^' . indent . mirroredTags
        " don't create duplicate closing tag; just indent
        return "\<Tab>"
    endif

    " use <esc>a to go back to the 0'th column to avoid
    " dealing with other indent level config/plugins
    let keys = "\<Esc>a" . indent . mirroredTags . s:extractSuffix(config)

    " now go back 'inside' the context
    let keys .= "\<C-O>O"

    " indent as above
    let keys .= "\<Esc>a" . indent

    " new indent level
    let keys .= "\<Tab>"

    " fix inspired by vim-closer:
    let keys .= "\<Esc>A"

    return keys
endfunc
