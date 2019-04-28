func! mirror#context#Get()
    " FIXME this is wildly insufficient
    let lineNr = line('.')
    let bottom = prevnonblank(lineNr - 1)
    return getline(bottom)
endfunc
