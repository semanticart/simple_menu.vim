function! SimpleMenuBak(options, ...)
  "let l:visual = get(a:, 1, 0)  " visual selection is active
  "echo l:visual
  "echo ''

  "let &ch=len(a:options)
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
  "let &ch=1

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




function! SimpleMenu(options, ...)
  let l:choice_map = {}
  let l:menu_lines = []

  " Prepare the menu lines and choice map
  for choice in a:options
    if type(choice) != type([]) || len(choice) < 2
      echo "Error: Invalid menu option structure. Each option must be a list with at least two elements."
      return
    endif

    let l:key = choice[0]
    let l:description = choice[1]
    if len(choice) == 3
      let l:choice_map[l:key] = choice[2]
    else
      let l:choice_map[l:key] = choice[1]
    endif

    let l:key_display = l:key
    if l:key == ' '
      let l:key_display = '<space>'
    endif

    call add(l:menu_lines, printf(' %s: %s', l:key_display, l:description))
  endfor

  " Capture the current window ID, top visible line, and cursor position
  let l:main_win = win_getid()
  let l:topline = line('w0', l:main_win) " Top visible line of the main buffer
  let l:cursor = getpos('.')

  " Define a function to restore the scroll position in the main buffer
  function! RestoreScroll(main_win, topline, cursor) abort
    call win_gotoid(a:main_win)               " Switch to the main buffer window
    execute 'normal! ' . a:topline . 'Gzt'
    call setpos('.', a:cursor)                " Restore the cursor position
  endfunction

  " Define the desired height of the new buffer based on menu lines
  let l:new_buf_height = len(l:menu_lines)

  " Open a scratch buffer at the bottom
  execute 'botright ' . l:new_buf_height . 'new'
  setlocal buftype=nofile bufhidden=wipe noswapfile
  setlocal nobuflisted
  setlocal nonumber norelativenumber
  setlocal winfixheight winfixwidth
  let l:buf_win = win_getid()

  " Populate the buffer with menu lines
  call setline(1, l:menu_lines)
  setlocal nomodifiable

  " Apply syntax highlighting for menu keys
  highlight link MenuKey Boolean
  call matchadd('MenuKey', '^ .:')

  " Restore scroll position in the main buffer
  call RestoreScroll(l:main_win, l:topline, l:cursor)
  redraw! " Force redraw of the buffer content

  " Loop to handle input and detect Ctrl+C or Escape
  echo "Select an option (key) and press Enter:"
  let l:response = ''
  while l:response == ''
    try
      let l:response = nr2char(getchar())
    catch /^Vim:Interrupt$/
      " Handle Ctrl+C explicitly
      let l:response = "\<C-c>"
    endtry
  endwhile

  " Close the scratch buffer
  call win_gotoid(l:buf_win)
  bdelete!

  " Restore scroll position in the main buffer again
  call RestoreScroll(l:main_win, l:topline, l:cursor)

  " Handle Escape (ASCII 27) and Ctrl+C to gracefully exit
  if l:response ==# "\<Esc>" || l:response ==# "\<C-c>"
    return
  endif

  " Execute the selected option
  if has_key(l:choice_map, l:response)
    if (l:choice_map[l:response][0] == ':') ||
            \ (l:choice_map[l:response][0:len('normal! ')-1] ==# 'normal! ' )
        " if it starts from ':' or 'normal! ' interpret it as vim command: `:foo`
        execute substitute(l:choice_map[l:response], "^%", '', '')
    else
        " otherwise it's a function name so do: `:call foo()`
        call call(l:choice_map[l:response], [])
    endif
  else
    echo "Invalid choice: " . l:response
  endif
endfunction
