if exists('g:loaded_crepl')
  finish
endif
let g:loaded_crepl = 1

command! -range -nargs=0 CreplCreatePermaLink <line1>,<line2> call crepl#display_link()
