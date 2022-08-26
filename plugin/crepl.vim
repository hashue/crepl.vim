if exists('g:loaded_crepl')
  finish
endif
let g:loaded_crepl = 1

command! -nargs=0 CreatePermaLink call crepl#make_permalink()
command! -range=% -nargs=0 CreateMLPermaLink <line1>,<line2> call crepl#make_multiline_permalink()
