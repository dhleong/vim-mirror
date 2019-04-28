func! s:IsContextEnd(config, lineNr)
    let line = getline(a:lineNr)

    " blank line
    if line =~# '^\s*$'
        return 1
    endif

    " if a line ends with a closer character, that is not
    " part of this context
    for ch in split(a:config.close, '\zs')
        if line =~# ch . '$'
            return 1
        endif
    endfor

    return 0
endfunc

func! mirror#context#Get(...)
    " Extract the 'context' of the current mirror/closing.
    " This is everything that might be part of the 'opening', starting
    " from the opening line and going back to include code on the same
    " indent level (that isn't part of a previous closing)

    let config = a:0 ? a:1 : mirror#Config()
    let lineNr = line('.')
    let bottom = prevnonblank(lineNr)
    let targetIndent = indent(bottom)

    let top = lineNr
    while top > 1 &&
            \ indent(top - 1) >= targetIndent
            \ && !s:IsContextEnd(config, top - 1)
        let top -= 1
    endwhile

    return join(getline(top, bottom), "\n")
endfunc
