function! myinlineedit#JiraMarkdownFencedCode()
  let start_pattern = '\v^\s*\{code:(.+)\}\s*$'
  let end_pattern   = '\v^\s*\{code\}\s*$'

  call inline_edit#PushCursor()

  " find start of area
  if searchpair(start_pattern, '', end_pattern, 'Wb') <= 0
    call inline_edit#PopCursor()
    return []
  endif
  let start    = line('.') + 1
  let filetype = matchlist(getline('.'), start_pattern, 0)[1]

  " find end of area
  if searchpair(start_pattern, '', end_pattern, 'W') <= 0
    call inline_edit#PopCursor()
    return []
  endif
  let end    = line('.') - 1
  let indent = indent('.')

  call inline_edit#PopCursor()

  return [start, end, filetype, indent]
endfunction

