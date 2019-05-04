func! s:findClose(config, contextLine, consumed, mirror, at, direction)
    let end = len(a:contextLine)
    let didConsume = 0
    let matchIdx = a:at + a:direction
    while matchIdx < end && matchIdx >= 0 && !didConsume
        if a:contextLine[matchIdx] == a:mirror && !has_key(a:consumed, matchIdx)
            let a:consumed[matchIdx] = 1
            let didConsume = 1
            break
        endif
        let matchIdx += a:direction
    endwhile
    return didConsume
endfunc

func! mirror#extract#Extract(config, contextLine)
    " Given config and a line of context, extract all the
    " appropriate mirrored symbols

    let extractedMirror = ''
    let consumed = {}

    let end = len(a:contextLine)
    let idx = end - 1
    while idx >= 0
        " update idx for next loop early to ensure it happens
        let thisIdx = idx
        let idx -= 1

        if has_key(consumed, thisIdx)
            " already consumed, ignore
            continue
        endif

        let ch = a:contextLine[thisIdx]
        let mirrorType = stridx(a:config.open, ch)
        if mirrorType != -1
            let mirror = a:config.close[mirrorType]

            let direction = 1
            if mirror ==# ch
                " close == open is a special case; we have to search
                " *backward* in the string for a matching pair.
                let direction = -1
            endif

            let didConsume = s:findClose(
                \ a:config, a:contextLine,
                \ consumed,
                \ mirror,
                \ thisIdx, direction)

            if !didConsume
                let extractedMirror .= mirror
            endif
        endif
    endwhile

    return extractedMirror
endfunc
