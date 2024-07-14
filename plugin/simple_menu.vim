function! SimpleMenu(options)

  let l:choice_map = {}

  for choice in a:options
    let l:key = choice[0]
    let l:description = choice[1]
    if len(choice) == 3
        let l:choice_map[l:key] = choice[2]
    else
        let l:choice_map[l:key] = choice[1]
        let l:description = substitute(l:description, "^:", '', '')
    endif

    let l:key_display = l:key
    if l:key == ' '
        let l:key_display = '<space>'
    endif
    echohl Boolean
    echon ' ' . l:key_display . ' '

    echohl None
    echon l:description
    echo ''
  endfor

  let l:response = nr2char(getchar())

  redraw!

  if has_key(l:choice_map, l:response)
    if (l:choice_map[l:response][0] == ':') ||
            \ (l:choice_map[l:response][0:len('normal! ')-1] ==# 'normal! ' )
        " if it starts from ':' or 'normal! ' interpret it as vim command: `:foo`
        execute substitute(l:choice_map[l:response], "^%", '', '')
    else
        " otherwise it's a function name so do: `:call foo()`
        call call(l:choice_map[l:response], [])
    endif
  endif
endfunction
