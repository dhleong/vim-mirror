func! s:ContextMatches(regex)
    let context = mirror#context#Get()
    return context =~# a:regex
endfunc

func! s:ContainerMatches(regex)
    let context = mirror#context#GetContaining()
    if context ==# ''
        " no container? consider it a match
        return 1
    endif

    return context =~# a:regex
endfunc

func! s:FindMatchingSuffixUsage(usage)
    return search(a:usage . '$', 'nw') != 0
endfunc

func! s:CanUseSuffix(suffix, opts)
    let suffix = a:suffix
    let after = a:opts.after

    " try to find a matching use of after + suffix
    let onlyIfMatched = get(a:opts, 'onlyIfMatched', 0)
    if onlyIfMatched && !s:FindMatchingSuffixUsage(after . suffix)
        return 0
    endif

    " try to find a matching use of suffix
    let onlyIfPresent = get(a:opts, 'onlyIfPresent', 0)
    if onlyIfPresent && !s:FindMatchingSuffixUsage(suffix)
        return 0
    endif

    let neverIfContextMatches = get(a:opts, 'neverIfContextMatches', '')
    if neverIfContextMatches !=# '' && s:ContextMatches(neverIfContextMatches)
        return 0
    endif

    let whenContainerMatches = get(a:opts, 'whenContainerMatches', '')
    if whenContainerMatches !=# '' && !s:ContainerMatches(whenContainerMatches)
        return 0
    endif

    " No other restrictions; use it!
    return 1
endfunc

func! mirror#suffix#Define(suffix, opts)
    return { -> s:CanUseSuffix(a:suffix, a:opts) ? a:suffix : '' }
endfunc
