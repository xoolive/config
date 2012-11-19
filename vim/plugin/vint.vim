
" http://code.google.com/p/conque/wiki/Usage

function VintGoDown()
    let i = line(".") + 1
    call cursor(i, 1)
    let curline = substitute(getline("."), "^\s*","","")
    let fc = curline[0]
    let lastLine = line("$")
    while i < lastLine && (fc == '#' || strlen(curline) == 0)
        let i = i + 1
        call cursor(i, 1)
        let curline = substitute(getline("."), "^\s*","","")
        lef fc = curline[0]
    endwhile
endfunction

function VintSendLineToCurrentConqueTerm()
    call conque_term#get_instance().writeln(getline("."))
    call conque_term#get_instance().read(50)
    call VintGoDown()
endfunction
