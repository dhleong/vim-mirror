func! mirror#extract#Extract(config, contextLine)
    " Given config and a line of context, extract all the
    " appropriate mirrored symbols

    let extractedMirror = ''
    let consumed = {}

    let end = len(a:contextLine)
    let idx = end - 1
    while idx >= 0
        let ch = a:contextLine[idx]
        let mirrorType = stridx(a:config.open, ch)
        if mirrorType != -1
            let mirror = a:config.close[mirrorType]

            " check if this has already been closed later on the line
            let didConsume = 0
            let matchIdx = idx + 1
            while matchIdx < end && !didConsume
                if a:contextLine[matchIdx] == mirror && !has_key(consumed, matchIdx)
                    let consumed[matchIdx] = 1
                    let didConsume = 1
                    break
                endif
                let matchIdx += 1
            endwhile

            if !didConsume
                let extractedMirror .= mirror
            endif
        endif

        let idx -= 1
    endwhile

    return extractedMirror
endfunc
