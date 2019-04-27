func! s:CanUseSuffix(suffix, opts)
    let suffix = a:suffix
    let after = a:opts.after
    let onlyIfMatched = a:opts.onlyIfMatched

    if onlyIfMatched
        " TODO try to find a matching use of after + suffix
        return 0
    endif

    " No other restrictions; use it!
    return 1
endfunc

func! mirror#suffix#Define(suffix, opts)
    return { -> s:CanUseSuffix(a:suffix, a:opts) ? a:suffix : '' }
endfunc
