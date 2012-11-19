" EnhancedCommentify.vim
" Maintainer:	Meikel Brandmeyer <Brandels_Mikesh@web.de>
" Version:	2.0
" Last Change:	Thursday, 22nd August 2002

" License:
" Copyright (c) 2002 Meikel Brandmeyer, Kaiserslautern.
" All rights reserved.
"
" Redistribution and use in source and binary forms, with or without
" modification, are permitted provided that the following conditions are met:
"
"   * Redistributions of source code must retain the above copyright notice,
"     this list of conditions and the following disclaimer.
"   * Redistributions in binary form must reproduce the above copyright notice,
"     this list of conditions and the following disclaimer in the documentation
"     and/or other materials provided with the distribution.
"   * Neither the name of the author nor the names of its contributors may be
"     used to endorse or promote products derived from this software without
"     specific prior written permission.
"
" THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
" IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
" DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE LIABLE
" FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
" DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
" SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER
" CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY,
" OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
" OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

" Description: 
" This is a (well... more or less) simple script to comment lines in a program.
" Currently supported languages are C, C++, PHP, the vim scripting
" language, python, HTML, Perl, LISP, Tex, Shell, CAOS and others.

" Bugfixes:
"   2.0
"   Fixed invalid expression '\'' -> "'" (thanks to Zak Beck)
"   Setting AltOpen/AltClose to '' (ie. disabling it) would
"   insert '/*' resp. '*/' for character in a line (thanks to Ben Kibbey)
"   1.8
"   Backslashes in comment symbols should not be escaped.
"   typo (commensSymbol -> commentSymbol) (thanks to Steve Butts) 
"   typo (== -> =) 
"   Fixed hardwired '|+'-'+|' pair. 
"   1.7
"   Lines were not correctly decommentified, when there was whitespace
"   at the beginning of the line.    (thanks to Xiangjiang Ma) 
"   Fixed error detecting '*sh' filetypes. 
"   1.3
"   hlsearch was set unconditionally (thanks to Mary Ellen Foster)
"   made function silent	     (thanks to Mare Ellen Foster)

" Changelog:
"   2.0
"   IMPORTANT: EnhancedCommentify is now licensed under BSD license
"              for distribution with Cream! However this shouldn't
"              change anything... 
"   useBlockIndent does no longer depend on respectIndent. 
"   Added code to cope with 'C' in '&cpo'. (thanks to Luc Hermitte
"   for pointing this out!)
"   Added EnhCommentifyIdentFrontOnly option.
"   All options are now handled on a per buffer basis. So options
"   can be overriden for different buffers. 
"   1.9
"   Filetype is now recognized via regular expressions.
"   All known filetypes are (more or less) supported.
"   Decomments multipart-block comments.
"   Added RespectIndent, AlignRight and synID-guessing.
"   Switched to buffer variables.
"   1.8
"   Added Ada support. (thanks to Preben Randhol) 
"   Added Latte support.
"   Added blocksupport and possibility to specify action (comment or
"   decomment). It's also possible to guess the action line by line or
"   using the first line of a block.
"   Thanks to Xiangjiang Ma and John Orr for the rich feedback on these
"   issues.
"   Decomments /*foo();*/, when PrettyComments is set.
"   Added 'vhdl' and 'verilog'. (thanks to Steve Butts) 
"   1.7
"   Added different options to control behaviour of the plugin. 
"   Changed default Keybindings to proper plugin settings.
"   1.6
"   Now supports 'm4', 'config', 'automake'
"   'vb', 'aspvbs', 'plsql' (thanks to Zak Beck)
"   1.5
"   Now supports 'java', 'xml', 'jproperties'. (thanks to Scott Stirling)
"   1.4
"   Lines containing only whitespace are now considered empty.
"   Added Tcl support.
"   Multipart comments are now escaped with configurable alternative
"   strings. Prevents nesting errors (eg. /**/*/ in C)
"   1.3
"   Doesn't break lines like
"	foo(); /* bar */
"   when doing commentify.

" Install Details:
" Simply drop this file into your $HOME/.vim/plugin directory.

if exists("DidToggleCommentify")
    finish
endif
let DidToggleCommentify = 1

let s:savedCpo = &cpo
set cpo-=C

" Note: These must be defined here, since they are used during
"       initialisation.
"
" InitBooleanVariable(confVar, scriptVar, defaultVal)
"	confVar		-- name of the configuration variable
"	scriptVar	-- name of the variable to set
"	defaultVal	-- default value
"
" Tests on existence of configuration variable and sets scriptVar
" according to its contents.
"
function s:InitBooleanVariable(confVar, scriptVar, defaultVal)
    let regex = a:defaultVal ? 'no*' : 'ye*s*'

    if exists(a:confVar) && {a:confVar} =~? regex
	let {a:scriptVar} = !a:defaultVal
    else
	let {a:scriptVar} = a:defaultVal
    endif
endfunction
    
"
" InitStringVariable(confVar, scriptVar, defaultVal)
"	confVar		-- name of the configuration variable
"	scriptVar	-- name of the variable to set
"	defaultVal	-- default value
"
" Tests on existence of configuration variable and sets scriptVar
" to its contents.
"
function s:InitStringVariable(confVar, scriptVar, defaultVal)
    if exists(a:confVar)
	execute "let ". a:scriptVar ." = ". a:confVar
    else
	let {a:scriptVar} = a:defaultVal
    endif
endfunction

"
" InitScriptVariables(nameSpace)
"	nameSpace	-- may be "g" for global or "b" for local
"
" Initialises the script variables.
"
function s:InitScriptVariables(nameSpace)
    let ns = a:nameSpace	" just for abbreviation
    let lns = (ns == "g") ? "s" : "b" " 'local namespace'

    " Comment escape strings...
    call s:InitStringVariable(ns .":EnhCommentifyAltOpen", lns .":ECaltOpen",
		\ s:ECaltOpen)
    call s:InitStringVariable(ns .":EnhCommentifyAltClose", lns .":ECaltClose",
		\ s:ECaltClose)

    call s:InitBooleanVariable(ns .":EnhCommentifyIgnoreWS", lns .":ECignoreWS",
		\ s:ECignoreWS)

    " Adding a space between comment strings and code...
    if exists(ns .":EnhCommentifyPretty")
	if {ns}:EnhCommentifyPretty =~? 'ye*s*'
	    let {lns}:ECprettyComments = ' '
	    let {lns}:ECprettyUnComments = ' \='
	else
	    let {lns}:ECprettyComments = ''
	    let {lns}:ECprettyUnComments = ''
	endif
    else
	let {lns}:ECprettyComments = s:ECprettyComments
	let {lns}:ECprettyUnComments = s:ECprettyUnComments
    endif

    " Identification string settings...
    call s:InitStringVariable(ns .":EnhCommentifyIdentString",
		\ lns .":ECidentFront", s:ECidentFront)
    let {lns}:ECidentBack =
		\ (exists(ns .":EnhCommentifyIdentFrontOnly")
		\	    && {ns}:EnhCommentifyIdentFrontOnly =~? 'ye*s*')
		\ ? ''
		\ : {lns}:ECidentFront

    " Wether to use syntax items...
    call s:InitBooleanVariable(ns .":EnhCommentifyUseSyntax",
		\ lns .":ECuseSyntax", s:ECuseSyntax)

    " Should the script respect line indentation, when inserting strings?
    call s:InitBooleanVariable(ns .":EnhCommentifyRespectIndent",
		\ lns .":ECrespectIndent", s:ECrespectIndent)

    " Block stuff...
    call s:InitBooleanVariable(ns .":EnhCommentifyAlignRight",
		\ lns .":ECalignRight", s:ECalignRight)
    call s:InitBooleanVariable(ns .":EnhCommentifyUseBlockIndent",
		\ lns .":ECuseBlockIndent", s:ECuseBlockIndent)
    call s:InitBooleanVariable(ns .":EnhCommentifyMultiPartBlocks",
		\ lns .":ECuseMPBlock", s:ECuseMPBlock)

    let {lns}:ECsaveWhite = ({lns}:ECrespectIndent
		\ || {lns}:ECignoreWS || {lns}:ECuseBlockIndent)
		\	? '\(\s*\)'
		\	: ''

    if {lns}:ECrespectIndent
	let {lns}:ECrespectWhite = '\1'
	let {lns}:ECignoreWhite = ''
    elseif {lns}:ECignoreWS
	let {lns}:ECrespectWhite = ''
	let {lns}:ECignoreWhite = '\1'
    else
	let {lns}:ECrespectWhite = ''
	let {lns}:ECignoreWhite = ''
    endif
endfunction

" Initial settings.
"
" Setting the default options resp. taking user preferences.
if !exists("g:EnhCommentifyUserMode")
	    \ && !exists("g:EnhCommentifyFirstLineMode")
	    \ && !exists("g:EnhCommentifyTraditionalMode")
	    \ && !exists("g:EnhCommentifyUserBindings")
    let g:EnhCommentifyTraditionalMode = 'Yes'
endif

" These will be the default settings for the script:
let s:ECaltOpen = "|+"
let s:ECaltClose = "+|"
let s:ECignoreWS = 1
let s:ECprettyComments = ''
let s:ECprettyUnComments = ''
let s:ECidentFront = ''
let s:ECuseSyntax = 0
let s:ECrespectIndent = 0
let s:ECalignRight = 0
let s:ECuseBlockIndent = 0
let s:ECuseMPBlock = 0

" Now initialise the global defaults with the preferences set
" by the user in his .vimrc. Settings local to a buffer will be
" done later on, when the script is first called in a buffer.
"
call s:InitScriptVariables("g")

" Globally used variables with some initialisation.
" FIXME: explain what they are good for
" 
let s:Action = 'guess'
let s:firstOfBlock = 1
let s:blockAction = 'comment'
let s:blockIndentRegex = ''
let s:inBlock = 0
let s:tabConvert = ''
let s:overrideEmptyLines = 0
let s:emptyLines = 'no'
let s:maxLen = 0

"
" EnhancedCommentify(emptyLines, action, ...)
"	overrideEL	-- commentify empty lines
"			   may be 'yes', 'no' or '' for guessing
"	action		-- action which should be executed:
"			    * guess:
"			      toggle commetification (old behaviour)
"			    * comment:
"			      comment lines
"			    * decomment:
"			      decomment lines
"			    * first:
"			      use first line of block to determine action 
"	a:1, a:2	-- first and last line of block, which should be
"			   processed. 
"
" Commentifies the current line.
"
function EnhancedCommentify(overrideEL, action, ...)
    if a:overrideEL != ''
	let s:overideEmptyLines = 1
    endif

    " Now do the buffer initialisation. Every buffer will get
    " it's pendant to a global variable (eg. s:ECalignRight -> b:ECalignRight).
    " The local variable is actually used, whereas the global variable
    " holds the defaults from the user's .vimrc. In this way the settings
    " can be overriden for single buffers.
    " 
    if !exists("b:EnhCommDidBufferInit")
	call s:InitScriptVariables("b")
	
	let b:EnhCommentifyEmptyLines = a:overrideEL
	let b:EnhCommentifySyntax = &ft
	
	if !exists("b:EnhCommentifyFallbackTest")
	    let b:EnhCommentifyFallbackTest = 0
	endif

	call s:GetFileTypeSettings(&ft)
	call s:CheckPossibleEmbedding(&ft)

	let b:EnhCommDidBufferInit = 1
    endif

    " The language is not supported.
    if b:EnhCommentifyCommentOpen == ''
	if (has("dialog_gui") && has("gui_running"))
	    call confirm("This filetype is currently _not_ supported!\n"
			\ ."Please consider contacting the author in order"
			\ ." to add this filetype.", "", 1, "Error")
	else
	    echohl ErrorMsg
	    echo "This filetype is currently _not_ supported!"
	    echo "Please consider contacting the author in order to add"
	    echo "this filetype in future releases!"
	    echohl None
	endif
	return
    endif

    let lnum = line(".")
    let cnum = virtcol(".")

    " Now some initialisations...
    let s:Action = a:action

    " FIXME: Is there really _no_ function to simplify this???
    " (Maybe something like 'let foo = 8x" "'?) 
    if s:tabConvert == ''
	let s:tabConvert = ''
	let i = 0
	while i < &tabstop
	    let s:tabConvert = s:tabConvert .' '
	    let i = i + 1
	endwhile
    endif

    if a:0 == 2
	let s:startBlock = a:1
	let s:i = a:1
	let s:endBlock = a:2
	" Go to beginning of block!
	execute 'normal '. s:startBlock .'G'

	let s:inBlock = 1
    else
	let s:startBlock = lnum
	let s:i = lnum
	let s:endBlock = lnum

	let s:inBlock = 0
    endif

    " Get the indent of the less indented line of the block.
    if s:inBlock && (b:ECuseBlockIndent || b:ECalignRight)
	call s:DoBlockComputations(s:startBlock, s:endBlock)
    endif

    if b:ECuseSyntax && b:EnhCommentifyPossibleEmbedding
	execute 'normal ^'
	call s:CheckSyntax()
    endif

    while s:i <= s:endBlock
	let lineString = getline(s:i)
	let lineString = s:TabsToSpaces(lineString) 

	" Don't comment empty lines.
	if lineString !~ "^\s*$"
		    \ || (b:EnhCommentifyEmptyLines == 'yes'
		    \	  && !b:ECrespectIndent)
	    if b:EnhCommentifyCommentClose != ''
		let lineString = s:CommentifyMultiPart(lineString,
			    \ b:EnhCommentifyCommentOpen,
			    \ b:EnhCommentifyCommentClose)
	    else
	    	let lineString = s:CommentifySinglePart(lineString,
			    \ b:EnhCommentifyCommentOpen)
	    endif
	endif

	let lineString = s:SpacesToTabs(lineString)
	call setline(s:i, lineString)

	" Move to the next line of the block.
	if s:i < s:endBlock
	    execute 'normal j'
	endif

	let s:i = s:i + 1
	let s:firstOfBlock = 0
    endwhile

    " Return to position, where we started.
    execute 'normal '. lnum .'G'
    execute 'normal '. cnum .'|'

    let s:firstOfBlock = 1
endfunction

"
" DoBlockComputations(start, end)
"	    start	-- number of first line
"	    end		-- number of last line
"
" This function does some computations which are necessary for useBlockIndent
" and alignRight. ie. find smallest indent and longest line.
"
function s:DoBlockComputations(start, end)
    let i = a:start
    let len = 0
    let amount = 100000	    " this should be enough ...
    
    while i <= a:end
	if b:ECuseBlockIndent && getline(i) !~ '^\s*$'
	    let cur = indent(i)
	    if cur < amount
		let amount = cur
	    endif
	endif

	if b:ECalignRight
	    execute 'normal '. i .'G$'
	    let cur = virtcol(".")
	    if len < cur
		let len = cur
	    endif
	endif
	
	let i = i + 1
    endwhile

    if b:ECuseBlockIndent
	if amount > 0
	    let regex = '\( \{'. amount .'}\)'
	else
	    let regex = ''
	endif
	let s:blockIndentRegex = regex
    endif

    if b:ECalignRight
	execute 'normal '. a:start .'G'
	let s:maxLen = len
    endif
endfunction

"
" CheckSyntax(void)
"
" Check what syntax is active during call of main function. First hit
" wins. If the filetype changes during the block, we ignore that.
" Adjust the filetype if necessary.
"
function s:CheckSyntax()
    let ft = ""
    let synFiletype = synIDattr(synID(line("."), col("."), 1), "name")

    " FIXME: This feature currently relies on a certain format
    " of the names of syntax items: the filetype must be prepended
    " in lowwer case letters, followed by at least one upper case
    " letter.
    if match(synFiletype, '\l\+\u') == 0
	let ft = substitute(synFiletype, '^\(\l\+\)\u.*$', '\1', "")
    endif

    if ft == ""
	execute "let specialCase = ". b:EnhCommentifyFallbackTest

	if specialCase
	    let ft = b:EnhCommentifyFallbackValue
	else
	    " Fallback: If nothing holds, use normal filetype!
	    let ft = &ft
	endif
    endif
    
    " Nothing changed!
    if ft == b:EnhCommentifySyntax
	return
    endif

    let b:EnhCommentifySyntax = ft
    call s:GetFileTypeSettings(ft)
endfunction

"
" GetFileTypeSettings(ft)
"	ft	    -- filetype
"
" This functions sets some buffer-variables, which control the comment
" strings and 'empty lines'-handling.
"
function s:GetFileTypeSettings(ft)
    let fileType = a:ft

    " Multipart comments:
    if fileType =~ '^\(c\|b\|css\|csc\|cupl\|indent\|jam\|lex\|lifelines\|'.
		\ 'lite\|nqc\|phtml\|progress\|rexx\|rpl\|sas\|sdl\|sl\|'.
		\ 'strace\|xpm\)$'
	let b:EnhCommentifyCommentOpen = '/*'
	let b:EnhCommentifyCommentClose = '*/'
    elseif fileType =~ '^\(html\|xml\|dtd\|sgmllnx\)$'
	let b:EnhCommentifyCommentOpen = '<!--'
	let b:EnhCommentifyCommentClose = '-->'
    elseif fileType =~ '^\(sgml\|smil\)$'
	let b:EnhCommentifyCommentOpen = '<!'
	let b:EnhCommentifyCommentClose = '>'
    elseif fileType == 'atlas'
	let b:EnhCommentifyCommentOpen = 'C'
	let b:EnhCommentifyCommentClose = '$'
    elseif fileType =~ '^\(catalog\|sgmldecl\)$'
	let b:EnhCommentifyCommentOpen = '--'
	let b:EnhCommentifyCommentClose = '--'
    elseif fileType == 'dtml'
	let b:EnhCommentifyCommentOpen = '<dtml-comment>'
	let b:EnhCommentifyCommentClose = '</dtml-comment>'
    elseif fileType == 'htmlos'
	let b:EnhCommentifyCommentOpen = '#'
	let b:EnhCommentifyCommentClose = '/#'
    elseif fileType =~ '^\(jgraph\|lotos\|mma\|modula2\|modula3\|pascal\|sml\)$'
	let b:EnhCommentifyCommentOpen = '(*'
	let b:EnhCommentifyCommentClose = '*)'
    elseif fileType == 'jsp'
	let b:EnhCommentifyCommentOpen = '<%--'
	let b:EnhCommentifyCommentClose = '--%>'
    elseif fileType == 'model'
	let b:EnhCommentifyCommentOpen = '$'
	let b:EnhCommentifyCommentClose = '$'
    elseif fileType == 'st'
	let b:EnhCommentifyCommentOpen = '"'
	let b:EnhCommentifyCommentClose = '"'
    elseif fileType =~ '^\(tssgm\|tssop\)$'
	let b:EnhCommentifyCommentOpen = 'comment = "'
	let b:EnhCommentifyCommentClose = '"'
    " Singlepart comments:
    elseif fileType =~ '^\(ox\|cpp\|php\|java\|verilog\|acedb\|ch\|clean\|'.
		\ 'clipper\|cs\|dot\|dylan\|hercules\|idl\|ishd\|javascript'.
		\ 'kscript\|mel\|named\|openroad\|pccts\|pfmain\|pike\|'.
		\ 'pilrc\|plm\|pov\|rc\|scilab\|specman\|tads\|tsalt\|uc\|'.
		\ 'xkb\)$'
	let b:EnhCommentifyCommentOpen = '//'
	let b:EnhCommentifyCommentClose = ''
    elseif fileType =~ '^\(vim\|abel\)$'
	let b:EnhCommentifyCommentOpen = '"'
	let b:EnhCommentifyCommentClose = ''
    elseif fileType =~ '^\(python\|perl\|[^w]*sh$\|tcl\|jproperties\|cmake\|make\|'.
		\ 'robots\|apacha\|apachestyle\|awk\|bc\|cfg\|cl\|conf\|'.
		\ 'crontab\|diff\|ecd\|elmfilt\|eterm\|expect\|exports\|'.
		\ 'fgl\|fvwm\|gdb\|gnuplot\|gtkrc\|hb\|hog\|ia64\|icon\|'.
		\ 'inittab\|lftp\|lilo\|lout\|lss\|lynx\|maple\|mush\|'.
		\ 'muttrc\|nsis\|ocaml\|ora\|pcap\|pine\|po\|procmail\|'.
		\ 'psf\|ptcap\|r\|radiance\|ratpoison\|readline\remind\|'.
		\ 'ruby\|screen\|sed\|sm\|snnsnet\|snnspat\|snnsres\|spec\|'.
		\ 'squid\|terminfo\|tidy\|tli\|tsscl\|vgrindefs\|vrml\|'.
		\ 'wget\|wml\|xf86conf\|xmath\)$'
	let b:EnhCommentifyCommentOpen = '#'
	let b:EnhCommentifyCommentClose = ''
    elseif fileType == 'webmacro'
	let b:EnhCommentifyCommentOpen = '##'
	let b:EnhCommentifyCommentClose = ''
    elseif fileType =~ '^\(lisp\|scheme\|amiga\|asm\|asm68k\|bindzone\|def\|'.
		\ 'dns\|dosini\|dracula\|dsl\|idlang\|iss\|jess\|kix\|masm\|'.
		\ 'monk\|nasm\|ncf\|omnimark\|pic\|povini\|rebol\|registry\|'.
		\ 'samba\|skill\|smith\|tags\|tasm\|tf\|winbatch\|wvdial\|'.
		\ 'z8a\)$'
	let b:EnhCommentifyCommentOpen = ';'
	let b:EnhCommentifyCommentClose = ''
    elseif fileType == 'ppwiz'
	let b:EnhCommentifyCommentOpen = ';;'
	let b:EnhCommentifyCommentClose = ''
    elseif fileType == 'latte'
	let b:EnhCommentifyCommentOpen = '\\;'
	let b:EnhCommentifyCommentClose = ''
    elseif fileType =~ '^\(tex\|abc\|erlang\|ist\|lprolog\|matlab\|mf\|'.
		\ 'postscr\|ppd\|prolog\|simula\|slang\|slrnrc\|slrnsc\|'.
		\ 'texmf\|virata\)$'
	let b:EnhCommentifyCommentOpen = '%'
	let b:EnhCommentifyCommentClose = ''
    elseif fileType =~ '^\(caos\|cterm\|form\|foxpro\|sicad\|snobol4\)$'
	let b:EnhCommentifyCommentOpen = '*'
	let b:EnhCommentifyCommentClose = ''
    elseif fileType =~ '^\(m4\|config\|automake\)$'
	let b:EnhCommentifyCommentOpen = 'dnl '
	let b:EnhCommentifyCommentClose = ''
    elseif fileType =~ '^\(vb\|aspvbs\|ave\|basic\|elf\|lscript\)$'
	let b:EnhCommentifyCommentOpen = "'"
	let b:EnhCommentifyCommentClose = ''
    elseif fileType =~ '^\(plsql\|vhdl\|ahdl\|ada\|asn\|csp\|eiffel\|gdmo\|'.
		\ 'haskell\|lace\|lua\|mib\|sather\|sql\|sqlforms\|sqlj\|'.
		\ 'stp\)$'
	let b:EnhCommentifyCommentOpen = '--'
	let b:EnhCommentifyCommentClose = ''
    elseif fileType == 'abaqus'
	let b:EnhCommentifyCommentOpen = '**'
	let b:EnhCommentifyCommentClose = ''
    elseif fileType =~ '^\(aml\|natural\|vsejcl\)$'
	let b:EnhCommentifyCommentOpen = '/*'
	let b:EnhCommentifyCommentClose = ''
    elseif fileType == 'ampl'
	let b:EnhCommentifyCommentOpen = '\\#'
	let b:EnhCommentifyCommentClose = ''
    elseif fileType == 'bdf'
	let b:EnhCommentifyCommentOpen = 'COMMENT '
	let b:EnhCommentifyCommentClose = ''
    elseif fileType == 'btm'
	let b:EnhCommentifyCommentOpen = '::'
	let b:EnhCommentifyCommentClose = ''
    elseif fileType == 'dcl'
	let b:EnhCommentifyCommentOpen = '$!'
	let b:EnhCommentifyCommentClose = ''
    elseif fileType == 'dosbatch'
	let b:EnhCommentifyCommentOpen = 'rem '
	let b:EnhCommentifyCommentClose = ''
    elseif fileType == 'focexec'
	let b:EnhCommentifyCommentOpen = '-*'
	let b:EnhCommentifyCommentClose = ''
    elseif fileType == 'forth'
	let b:EnhCommentifyCommentOpen = '\\ '
	let b:EnhCommentifyCommentClose = ''
    elseif fileType =~ '^\(fortran\|inform\|sqr\|uil\|xdefaults\|'.
		\ 'xmodmap\|xpm2\)$'
	let b:EnhCommentifyCommentOpen = '!'
	let b:EnhCommentifyCommentClose = ''
    elseif fileType == 'gp'
	let b:EnhCommentifyCommentOpen = '\\\\'
	let b:EnhCommentifyCommentClose = ''
    elseif fileType =~ '^\(master\|nastran\|sinda\|spice\|tak\|trasys\)$'
	let b:EnhCommentifyCommentOpen = '$'
	let b:EnhCommentifyCommentClose = ''
    elseif fileType == 'nroff'
	let b:EnhCommentifyCommentOpen = '\'\'\''
	let b:EnhCommentifyCommentClose = ''
    elseif fileType == 'opl'
	let b:EnhCommentifyCommentOpen = 'REM '
	let b:EnhCommentifyCommentClose = ''
    elseif fileType == 'texinfo'
	let b:EnhCommentifyCommentOpen = '@c '
	let b:EnhCommentifyCommentClose = ''
    else 
	let b:EnhCommentifyCommentOpen = ''
	let b:EnhCommentifyCommentClose = ''
    endif

    if !s:overrideEmptyLines
	call s:CommentEmptyLines(fileType)
    endif
endfunction

"
" CommentEmptyLines(ft)
"	ft	    -- filetype of current buffer
"
" Decides, if empty lines should be commentified or not. Add the filetype,
" you want to change, to the apropriate if-clause.
"
function s:CommentEmptyLines(ft)
    " if (a:ft == 'ox' || a:ft == 'cpp' || a:ft == 'php' || a:ft == 'java'
    "             \ || a:ft == 'verilog' || a:ft == 'vim' || a:ft == 'python'
    "             \ || a:ft == 'perl' || a:ft =~ '[^w]*sh$' || a:ft == 'tcl'
    "             \ || a:ft == 'jproperties' || a:ft == 'make' || a:ft == 'lisp'
    "             \ || a:ft == 'scheme' || a:ft == 'latte' || a:ft == 'tex'
    "             \ || a:ft == 'caos' || a:ft == 'm4' || a:ft == 'config'
    "             \ || a:ft == 'automake' || a:ft == 'vb' || a:ft == 'aspvbs'
    "             \ || a:ft == 'plsql' || a:ft == 'vhdl' || a:ft == 'ada')
    "     let b:EnhCommentifyEmptyLines = 'yes'
    " elseif (a:ft == 'c' || a:ft == 'css' || a:ft == 'html' || a:ft == 'xml')
    "     let b:EnhCommentifyEmptyLines = 'no'
    " else " Default behaviour
    "     let b:EnhCommentifyEmptyLines = 'no'
    " endif

    " FIXME: Quick hack (tm)!
    if 0
	" Add special filetypes here.
    elseif b:EnhCommentifyCommentClose == '' && !b:ECuseBlockIndent
	let b:EnhCommentifyEmptyLines = 'yes'
    else
	let b:EnhCommentifyEmptyLines = 'no'
    endif
endfunction

"
" CheckPossibleEmbedding(ft)
"	ft	-- the filetype of current buffer
"
" Check wether it makes sense to allow checking for the synIDs.
" Eg. C will never have embedded code...
"
function s:CheckPossibleEmbedding(ft)
    if a:ft =~ '^\(php\|vim\|latte\|html\)$'
	let b:EnhCommentifyPossibleEmbedding = 1
    else
	" Since getting the synID is slow, we set the default to 'no'!
	" There are also some 'broken' languages like the filetype for
	" autoconf's configure.in's ('config'). 
	let b:EnhCommentifyPossibleEmbedding = 0
    endif
endfunction

"
" CommentifyMultiPart(lineString, commentStart, commentEnd, action)
"	lineString	-- line to commentify
"	commentStart	-- comment-start string, eg '/*'
"	commentEnd	-- comment-end string, eg. '*/'
"
" This function commentifies code of languages, which have multipart
" comment strings, eg. '/*' - '*/' of C.
"
function s:CommentifyMultiPart(lineString, commentStart, commentEnd)
    if s:Action == 'guess' || s:Action == 'first' || b:ECuseMPBlock
	let todo = s:DecideWhatToDo(a:lineString, a:commentStart, a:commentEnd)
    else
	let todo = s:Action
    endif

    if todo == 'decomment'
	return s:UnCommentify(a:lineString, a:commentStart, a:commentEnd)
    else
	return s:Commentify(a:lineString, a:commentStart, a:commentEnd)
    endif
endfunction

"
" CommentifySinglePart(lineString, commentSymbol)
"	lineString	-- line to commentify
"	commentSymbol	-- comment string, eg '#'
"
" This function is used for all languages, whose comment strings
" consist only of one string at the beginning of a line.
"
function s:CommentifySinglePart(lineString, commentSymbol)
    if s:Action == 'guess' || s:Action == 'first'
	let todo = s:DecideWhatToDo(a:lineString, a:commentSymbol)
    else
	let todo = s:Action
    endif

    if todo == 'decomment'
	return s:UnCommentify(a:lineString, a:commentSymbol)
    else
	return s:Commentify(a:lineString, a:commentSymbol)
    endif
endfunction

"
" Escape(lineString, commentStart, commentEnd)
"
" Escape already present symbols.
"
function s:Escape(lineString, commentStart, commentEnd)
    let line = a:lineString

    if b:ECaltOpen != ''
	let line = substitute(line, s:EscapeString(a:commentStart),
		    \ b:ECaltOpen, "g")
    endif
    if b:ECaltClose != ''
	let line = substitute(line, s:EscapeString(a:commentEnd),
		    \ b:ECaltClose, "g")
    endif

    return line
endfunction

"
" UnEscape(lineString, commentStart, commentEnd)
"
" Unescape already present escape symbols.
"
function s:UnEscape(lineString, commentStart, commentEnd)
    let line = a:lineString

    if b:ECaltOpen != ''
	let line = substitute(line, s:EscapeString(b:ECaltOpen),
		    \ a:commentStart, "g")
    endif
    if b:ECaltClose != ''
	let line = substitute(line, s:EscapeString(b:ECaltClose),
		    \ a:commentEnd, "g")
    endif

    return line
endfunction

"
" Commentify(lineString, commentSymbol, [commentEnd])
"       lineString	-- the line in work
"	commentSymbol	-- string to insert at the beginning of the line
"	commentEnd	-- string to insert at the end of the line
"			   may be omitted
"
" This function inserts the start- (and if given the end-) string of the
" comment in the current line.
"
function s:Commentify(lineString, commentSymbol, ...)
    let rescueHls = &hlsearch  
    set nohlsearch
    
    let line = a:lineString
    let j = 0

    " If a end string is present, insert it too.
    if a:0
	" First we have to escape any comment already contained in the line,
	" since (at least for C) comments are not allowed to nest.
	let line = s:Escape(line, a:commentSymbol, a:1)

	if !b:ECuseMPBlock || (b:ECuseMPBlock && s:i == s:endBlock)
	    " Align the closing part to the right.
	    if b:ECalignRight && s:inBlock
		let len = strlen(line)
		while j < s:maxLen - len
		    let line = line .' '
		    let j = j + 1
		endwhile
	    endif

	    let line = substitute(line, s:LookFor('commentend'),
			\ s:SubstituteWith('commentend', a:1), "")
	endif
    endif
    
    " insert the comment symbol
    if !b:ECuseMPBlock || a:0 == 0 || (b:ECuseMPBlock && s:i == s:startBlock) 
	let line = substitute(line, s:LookFor('commentstart'),
		    \ s:SubstituteWith('commentstart', a:commentSymbol), "")
    endif
    
    let &hlsearch = rescueHls
    return line
endfunction

"
" UnCommentify(lineString, commentSymbol, [commentEnd])
"	lineString	-- the line in work
"	commentSymbol	-- string to remove at the beginning of the line
"	commentEnd	-- string to remove at the end of the line
"			   may be omitted
"
" This function removes the start- (and if given the end-) string of the
" comment in the current line.
"
function s:UnCommentify(lineString, commentSymbol, ...)
    let rescueHls = &hlsearch 
    set nohlsearch
    
    let line = a:lineString

    " remove the first comment symbol found on a line
    if !b:ECuseMPBlock || a:0 == 0 || (b:ECuseMPBlock && s:i == s:startBlock) 
	let line = substitute(line, s:LookFor('decommentstart',
		    \	a:commentSymbol),
		    \ s:SubstituteWith('decommentstart'), "")
    endif

    " If a end string is present, we have to remove it, too.
    if a:0
	" First, we remove the trailing comment symbol. We can assume, that it
	" is there, because we check for it.
	if !b:ECuseMPBlock || (b:ECuseMPBlock && s:i == s:endBlock) 
	    let line = substitute(line, s:LookFor('decommentend', a:1),
			\ s:SubstituteWith('decommentend'), "")

	    " Remove any trailing whitespace, if we used alignRight.
	    if b:ECalignRight
		let line = substitute(line, ' *$', '', "")
	    endif
	endif

	" Remove escaped inner comments.
	let line = s:UnEscape(line, a:commentSymbol, a:1)
    endif

    let &hlsearch = rescueHls
    return line
endfunction

"
" EscapeString(string)
"	string	    -- string to process
"
" Escapes characters in 'string', which have some function in
" regular expressions, with a '\'.
"
" Returns the escaped string.
"
function s:EscapeString(string)
    return escape(a:string, "*{}[]$^-")
endfunction

"
" LookFor(what, ...)
"	what	    -- what type of regular expression
"			* checkstart:
"			* checkend:
"			  check for comment at start/end of line
"			* commentstart:
"			* commentend:
"			  insert comment strings
"			* decommentstart:
"			* decommentend:
"			  remove comment strings
"	a:1	    -- comment string
"
function s:LookFor(what, ...)
    if b:ECuseBlockIndent && s:inBlock
	let handleWhitespace = s:blockIndentRegex
    else
	let handleWhitespace = b:ECsaveWhite
    endif
	
    if a:what == 'checkstart'
	let regex = '^'. b:ECsaveWhite . s:EscapeString(a:1)
		    \ . s:EscapeString(b:ECidentFront)
    elseif a:what == 'checkend'
	let regex = s:EscapeString(b:ECidentBack)
		    \ . s:EscapeString(a:1) . b:ECsaveWhite . '$'
    elseif a:what == 'commentstart'
	let regex = '^'. handleWhitespace
    elseif a:what == 'commentend'
	let regex = '$'
    elseif a:what == 'decommentstart'
	let regex = '^'. b:ECsaveWhite . s:EscapeString(a:1)
    		    \ . s:EscapeString(b:ECidentFront) . b:ECprettyUnComments
    elseif a:what == 'decommentend'
	let regex = b:ECprettyUnComments . s:EscapeString(b:ECidentBack)
		    \ . s:EscapeString(a:1) . b:ECsaveWhite .'$'
    endif

    return regex
endfunction

"
" SubstituteWith(what, ...)
"	what	    -- what type of regular expression
"			* commentstart:
"			* commentend:
"			  insert comment strings
"			* decommentstart:
"			* decommentend:
"			  remove comment strings
"	a:1	    -- comment string
"
function s:SubstituteWith(what, ...)
    if a:what == 'commentstart' || a:what == 'commentend'
	let commentSymbol = a:1
    else
	let commentSymbol = ''
    endif

    if b:ECuseBlockIndent && s:inBlock
	let handleWhitespace = '\1' . commentSymbol
    else
	let handleWhitespace = b:ECrespectWhite . commentSymbol
		    \ . b:ECignoreWhite
    endif
	
    if a:what == 'commentstart'
	let regex = handleWhitespace . b:ECidentFront
		    \ . b:ECprettyComments
    elseif a:what == 'commentend'
	let regex = b:ECprettyComments . b:ECidentBack . a:1
    elseif a:what == 'decommentstart' || a:what == 'decommentend'
	let regex = handleWhitespace
    endif

    return regex
endfunction

"
"
" DecideWhatToDo(lineString, commentStart, ...)
"	lineString	-- first line of block
"	commentStart	-- comment start symbol
"	a:1		-- comment end symbol
"
function s:DecideWhatToDo(lineString, commentStart, ...)
    " If we checked already, we return our previous result.
    if !s:firstOfBlock
		\ && (s:Action == 'first'
		\	|| (b:ECuseMPBlock && s:inBlock && a:0))
	return s:blockAction
    endif

    let s:blockAction = 'comment'

    if s:inBlock && a:0 && b:ECuseMPBlock
	let first = getline(s:startBlock)
	let last = getline(s:endBlock)

	if first =~ s:LookFor('checkstart', a:commentStart)
		\ && first !~ s:LookFor('checkend', a:1)
		\ && last !~ s:LookFor('checkstart', a:commentStart)
		\ && last =~ s:LookFor('checkend', a:1)
	    let s:blockAction = 'decomment'
	endif

	return s:blockAction
    endif

    if a:lineString =~ s:LookFor('checkstart', a:commentStart)
	let s:blockAction = 'decomment'
    endif

    if a:0
	if a:lineString !~ s:LookFor('checkend', a:1)
	    let s:blockAction = 'comment'
	endif
    endif

    let s:firstOfBlock = 0
    return s:blockAction
endfunction

"
" TabsToSpaces(str)
"	str	    -- string to convert
"
" Convert leading tabs of given string to spaces.
"
function s:TabsToSpaces(str)
    let string = a:str

    " FIXME: Can we use something like retab? I don't think so,
    " because retab changes every whitespace in the line, but we
    " wan't to modify only the leading spaces. Is this a problem?
    while string =~ '^\( *\)\t'
	let string = substitute(string, '^\( *\)\t', '\1'. s:tabConvert, "")
    endwhile

    return string
endfunction

"
" SpacesToTabs(str)
"	str	    -- string to convert
"
" Convert leading spaces of given string to tabs.
"
function s:SpacesToTabs(str)
    let string = a:str

    if !&expandtab
	while string =~ '^\(\t*\)'. s:tabConvert
	    let string = substitute(string, '^\(\t*\)'. s:tabConvert,
			\ '\1\t', "")
	endwhile
    endif

    return string
endfunction

"
" EnhCommentifyFallback4Embedded(test, fallback)
"	test	    -- test for the special case
"	fallback    -- filetype instead of normal fallback
"
" This function is global. It should be called from filetype
" plugins like php, where the normal fallback behaviour may
" not work. One may use 'synFiletype' to reference the guessed
" filetype via synID.
"
function EnhCommentifyFallback4Embedded(test, fallback)
    let b:EnhCommentifyFallbackTest = a:test
    let b:EnhCommentifyFallbackValue = a:fallback
endfunction

"
" Keyboard mappings.
"
noremap <Plug>Comment
	    \ :call EnhancedCommentify('', 'comment')<CR>
noremap <Plug>DeComment
	    \ :call EnhancedCommentify('', 'decomment')<CR>
noremap <Plug>Traditional
	    \ :call EnhancedCommentify('', 'guess')<CR>
noremap <Plug>FirstLine
	    \ :call EnhancedCommentify('', 'first')<CR>

noremap <Plug>VisualComment
	    \ <Esc>:call EnhancedCommentify('', 'comment',
	    \				    line("'<"), line("'>"))<CR>
noremap <Plug>VisualDeComment
	    \ <Esc>:call EnhancedCommentify('', 'decomment',
	    \				    line("'<"), line("'>"))<CR>
noremap <Plug>VisualTraditional
	    \ <Esc>:call EnhancedCommentify('', 'guess',
	    \				    line("'<"), line("'>"))<CR>
noremap <Plug>VisualFirstLine
	    \ <Esc>:call EnhancedCommentify('', 'first',
	    \				    line("'<"), line("'>"))<CR>
"
" Finally set keybindings.
"
if exists("g:EnhCommentifyUserBindings")
	    \ && g:EnhCommentifyUserBindings =~? 'ye*s*'
    "
    " *** Put your personal bindings here! ***
    "
else
    if exists("g:EnhCommentifyUseAltKeys")
	    \ && g:EnhCommentifyUseAltKeys =~? 'ye*s*'
	let s:c = '<M-c>'
	let s:x = '<M-x>'
	let s:C = '<M-v>'
	let s:X = '<M-y>'
    else
	let s:c = '<Leader>c'
	let s:x = '<Leader>x'
	let s:C = '<Leader>C'
	let s:X = '<Leader>X'
    endif

    if exists("g:EnhCommentifyTraditionalMode")
		\ && g:EnhCommentifyTraditionalMode =~? 'ye*s*'
	let s:Method = 'Traditional'
    elseif exists("g:EnhCommentifyFirstLineMode")
		\ && g:EnhCommentifyFirstLineMode =~? 'ye*s*'
	let s:Method = 'FirstLine'
    else
	let s:Method = 'Comment'

	" Decomment must be defined here. Everything else is mapped below.
	execute 'nmap <silent> <unique> '. s:C .' <Plug>DeCommentj'
	execute 'nmap <silent> <unique> '. s:X .' <Plug>DeComment'

	execute 'imap <silent> <unique> '. s:C .' <Esc><Plug>DeCommentji'
	execute 'imap <silent> <unique> '. s:X .' <Esc><Plug>DeCommenti'

	execute 'vmap <silent> <unique> '. s:C .' <Plug>VisualDeCommentj'
	execute 'vmap <silent> <unique> '. s:X .' <Plug>VisualDeComment'
    endif

    execute 'nmap <silent> <unique> '. s:c .' <Plug>'. s:Method .'j'
    execute 'nmap <silent> <unique> '. s:x .' <Plug>'. s:Method

    execute 'imap <silent> <unique> '. s:c .' <Esc><Plug>'. s:Method .'ji'
    execute 'imap <silent> <unique> '. s:x .' <Esc><Plug>'. s:Method

    execute 'vmap <silent> <unique> '. s:c .' <Plug>Visual'. s:Method .'j'
    execute 'vmap <silent> <unique> '. s:x .' <Plug>Visual'. s:Method
endif

let &cpo = s:savedCpo
