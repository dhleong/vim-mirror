func! s:ContextMatches(regex)
    let context = mirror#context#Get()
    return context =~# a:regex
endfunc

func! s:ContainerMatches(regex)
    let context = mirror#context#GetContaining()
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

    " forbid use based on context match
    let neverIfContextMatches = get(a:opts, 'neverIfContextMatches', '')
    if neverIfContextMatches !=# '' && s:ContextMatches(neverIfContextMatches)
        return 0
    endif

    " forbid use based unless container matches
    let whenContainerMatches = get(a:opts, 'whenContainerMatches', '')
    if whenContainerMatches !=# '' && !s:ContainerMatches(whenContainerMatches)
        return 0
    endif

    " forbid use *when* container matches
    let neverIfContainerMatches = get(a:opts, 'neverIfContainerMatches', '')
    if neverIfContainerMatches !=# '' && s:ContainerMatches(neverIfContainerMatches)
        return 0
    endif

    " No other restrictions; use it!
    return 1
endfunc

func! s:TryUseSuffix(suffix, opts)
    if s:CanUseSuffix(a:suffix, a:opts)
        return a:suffix
    endif

    return ''
endfunc

func! mirror#suffix#Define(suffix, opts)
    return function('s:TryUseSuffix', [a:suffix, a:opts])
endfunc
