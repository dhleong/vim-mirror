func! s:syntaxAt(line, col)
    " NOTE: col will be given in string-indexes, not col-indexes
    let ids = synstack(a:line, a:col + 1)
    let syntax = ''
    for id in ids
        if len(syntax)
            let syntax .= ','
        endif
        let syntax .= synIDattr(id, 'name')
    endfor

    return syntax
endfunc

func! mirror#line#Get()
    let initialLineNr = line('.') - 1
    let line = getline(initialLineNr)

    let filtered = ''
    let rangeStart = 0
    let inString = 0
    for end in range(len(line))
        let syn = s:syntaxAt(initialLineNr, end)
        let nowInString = syn =~# 'String'
        if nowInString == inString
            continue
        endif

        if !inString
            let filtered .= line[rangeStart : end - 1]
        endif

        let rangeStart = end
        let inString = nowInString
    endfor

    if inString
        " if we ended in a string, just add the *start* in
        " case it's a mirror
        let filtered .= line[rangeStart]
    else
        " add the last range
        let filtered .= line[rangeStart : len(line)]
    endif

    return filtered
endfunc
