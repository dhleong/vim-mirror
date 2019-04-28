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

func! s:GetRange(config, currentLine)
    " Extract the 'context' of the current mirror/closing.
    " This is everything that might be part of the 'opening', starting
    " from the opening line and going back to include code on the same
    " indent level (that isn't part of a previous closing)

    let config = a:config
    let lineNr = a:currentLine
    let bottom = prevnonblank(lineNr)
    let targetIndent = indent(bottom)

    let top = lineNr
    while top > 1 &&
            \ indent(top - 1) >= targetIndent
            \ && !s:IsContextEnd(config, top - 1)
        let top -= 1
    endwhile

    return [ top, bottom ]
endfunc

func! mirror#context#GetAtLine(line)
    let [ top, bottom ] = s:GetRange(
        \ mirror#Config(),
        \ a:line
        \ )

    return join(getline(top, bottom), "\n")
endfunc

func! mirror#context#Get()
    return mirror#context#GetAtLine(
        \ line('.')
        \ )
endfunc

func! s:GetContainingLine()
    let [ currentLine, _ ] = s:GetRange(
        \ mirror#Config(),
        \ line('.')
        \ )

    let currentIndent = indent(currentLine)

    let containerLine = currentLine
    while containerLine > 0
        let containerLine = prevnonblank(containerLine - 1)
        if containerLine == 0
            return -1
        endif

        if indent(containerLine) < currentIndent
            return containerLine
        endif
    endwhile

    " no containing context
    return -1
endfunc

func! mirror#context#GetContaining()
    let containerLine = s:GetContainingLine()
    if containerLine == -1
        return ''
    endif

    return mirror#context#GetAtLine(
        \ containerLine
        \ )
endfunc
