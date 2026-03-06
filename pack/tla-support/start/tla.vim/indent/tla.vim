" File: tla.vim
" Author: Hillel Wayne
" Description: Indent file for TLA+
" Last Modified: Wat

" This is both super elegant and way too slow.

if exists("b:did_indent")
   finish
endif

let b:did_indent = 1
let s:cpo_save = &cpo
set cpo&vim

setlocal indentexpr=TlaIndent()
setlocal indentkeys+=<:>,=end,=begin,=do,=or
"setlocal
 
let s:tla_open_scopes = [] " LET-IN, IF-THEN, CASE
let s:tla_closed_scopes = []
"  \ {'region': 'tlaSetRegion', 'start': 'tlaStartSet', 'end': 'tlaEndSet'},
"  \ {'region': 'tlaFunctionRegion', 'start': 'tlaStartFunction', 'end': 'tlaEndFunction'},
let s:pluscal_scopes = [ 
  \ {'region': 'pluscalBeginRegion', 'start': 'pluscalStartBegin', 'end': 'pluscalEndBegin'},
  \ {'region': 'pluscalIfRegion', 'start': 'pluscalStartIf', 'end': 'pluscalEndIf', 'mid': 'pluscalElse'},
  \ {'region': 'pluscalEitherRegion', 'start': 'pluscalStartEither', 'end': 'pluscalEndEither', 'mid': 'pluscalOr'},
  \ {'region': 'pluscalDoRegion', 'start': 'pluscalStartDo', 'end': 'pluscalEndDo'},
  \ ]

function! s:SyntaxStackAt(line, column)
  "We only really care about the name of the syntax stack
  "That's the only thing Vim will give us other than colors
  return map(synstack(a:line, a:column), 'synIDattr(v:val, "name")')
endfunction

function! s:SyntaxRegionsAt(line, column)
  return filter(s:SyntaxStackAt(a:line, a:column), 'v:val  =~ "Region"')
endfunction

function! s:InSyntaxRegion(region)
  return index(s:SyntaxStackAt(line("."), col(".")), a:region) != -1
endfunction

" Returns index of first character in line 'match' region
" TODO jump by word to make this more performant
function! s:LineMatchesSyntax(linenum, match)
  let columns = len(getline(a:linenum))
  for i in range(1, columns)
    if s:SyntaxStackAt(a:linenum, i)[-1] ==# a:match
      return i
    end if
  endfor
  return 0
endfunction


" Returns index of first character in line with match
" _and_ the same region stack. For /\ and \/.
function! s:LineMatchesSyntaxWithRegion(linenum, match, regions)
  let columns = len(getline(a:linenum))
  for i in range(1, columns)
    if s:SyntaxStackAt(a:linenum, i)[-1] ==# a:match && s:SyntaxRegionsAt(a:linenum, i) == a:regions
      return i
    end if
  endfor
  return 0
endfunction

" Each line has a 'region signature'. The end matchgroup is the same as the
" start matchgroup, except that the the start has one extra 'region'
" corresponding to its start.
function! s:LineStartOfRegion(start, signature)
  " v:lnum - 1 is a hack to make this work more easily with labels
  for lineNum in reverse(range(1, v:lnum - 1))
    let region_start = s:LineMatchesSyntax(lineNum, a:start)
    if region_start && s:SyntaxRegionsAt(lineNum, region_start) == a:signature
      return lineNum
    endif
  endfor
  return 0
endfunction

function! TlaIndent()
  let line = getline(v:lnum)

  " First nonblank line at or above this
  let previousNum = prevnonblank(v:lnum - 1)

  """ PLUSCAL SECTION
  " We handle this after TLA+ so that if we have TLA+ in our PlusCal
  " We'll add on their rules instead!
  for scope in s:pluscal_scopes
    " Test we're in a region we need to unindent
    " Since tags also create indents, we have to match to the start of the
    " scope, not just deindent by one.
    " TODO DRY this up
    let end_scope_col = s:LineMatchesSyntax(v:lnum, scope["end"])
    if end_scope_col
      let start_of_region = s:LineStartOfRegion(scope["start"], s:SyntaxRegionsAt(v:lnum, end_scope_col) + [scope["region"]])
      return indent(start_of_region)
    endif

    let mid_scope_col = s:LineMatchesSyntax(v:lnum, get(scope, "mid", "NULL"))
    if mid_scope_col
      let start_of_region = s:LineStartOfRegion(scope["start"], s:SyntaxRegionsAt(v:lnum, mid_scope_col) + [])
      return indent(start_of_region)
    endif

    " Test we're in a region we need to indent
    if s:InSyntaxRegion(scope["region"]) && (s:LineMatchesSyntax(previousNum, scope["start"]) || s:LineMatchesSyntax(previousNum, get(scope, "mid", "NULL") ))
      return indent(previousNum) + &tabstop
    endif
  endfor

  "Tagtest!
  " This makes sure that there's only one level of tag indentation per region
  " TODO only if the start of a line?
  let label_col = s:LineMatchesSyntax(v:lnum, "pluscalLabel")
  if label_col
      let last_tagged_line = s:LineStartOfRegion("pluscalLabel", s:SyntaxRegionsAt(v:lnum, label_col) + [])
      if last_tagged_line
        return indent(last_tagged_line)
      endif
  endif
" tlaBinaryOperator
  " Tags create subindentations
  if s:LineMatchesSyntax(previousNum, "pluscalLabel")
    return indent(previousNum) + &tabstop
  endif

  " TLA SECTION
  " We assume an empty line is a sign the operator is complete, and so we can
  " assume it's back to square zero.

  if previousNum != v:lnum - 1
    return 0
  endif

  " LET/IN handling
  let current_trimmed = substitute(line, '^\s*', '', '')
  let prev_line = getline(previousNum)
  let prev_trimmed = substitute(prev_line, '^\s*', '', '')

  " Current line starts with IN -> align with matching LET
  if current_trimmed =~# '^IN\>'
    for lnum in reverse(range(1, v:lnum - 1))
      let l = getline(lnum)
      if l =~# '\<LET\>'
        return match(l, '\<LET\>')
      endif
    endfor
    return indent(previousNum)
  endif

  " Previous line contains LET -> indent into LET definitions
  if prev_line =~# '\<LET\>'
    let let_col = match(prev_line, '\<LET\>')
    " Check if LET has a definition on the same line (LET x == ...)
    if matchstr(prev_line, '\<LET\>\s*\zs\S.*') !=# ''
      return let_col + 4
    else
      return let_col + &shiftwidth
    endif
  endif

  " /\ \/ : matching
  " If current line starts with /\ or \/, find the SAME operator above
  " so that \/ aligns with \/ and /\ aligns with /\
  " Stop searching at LET/IN scope boundaries to avoid escaping to outer scope
  let cur_op = strpart(current_trimmed, 0, 2)
  if cur_op ==# '/\' || cur_op ==# '\/'
    for lnum in range(previousNum, max([1, previousNum - 100]), -1)
      if getline(lnum) =~# '^\s*$'
        break
      endif
      let col = stridx(getline(lnum), cur_op)
      if col >= 0
        return col
      endif
      " Stop at LET/IN scope boundaries (checked after operator so we can
      " still match operators ON the IN line, e.g. IN /\ \/)
      if getline(lnum) =~# '\<LET\>\|\<IN\>'
        break
      endif
    endfor
  endif

  " Previous line starts with IN -> indent the IN body
  " Placed after operator matching so IN /\ \/ lines are handled by operator search
  if prev_trimmed =~# '^IN\>'
    let in_col = match(prev_line, '\<IN\>')
    if matchstr(prev_line, '\<IN\>\s*\zs\S.*') !=# ''
      " IN has content on same line (IN \E ...) -> align to after "IN  "
      return in_col + 4
    else
      " IN alone on line -> indent by shiftwidth
      return in_col + &shiftwidth
    endif
  endif

  " Fall back: match indentation to first /\ or \/ on previous line
  " AMBAR - Relaxed match: ignore region stack to ensure alignment works in nested scopes (e.g. LET/IN)
  let logic_col = s:LineMatchesSyntax(previousNum, "tlaBinaryOperator")
  if logic_col
    return logic_col - 1
  endif

  return indent(previousNum)
endfunction

let &cpo = s:cpo_save
unlet s:cpo_save
