
function! s:change_dir(stat) abort
  if a:stat == 'init'
    let cmd = printf('lcd %s',expand('%:p:h'))
  elseif a:stat == 'end'
    let cmd = 'lcd-'
  endif
  silent! execute(cmd)
endfunction

function! s:fetch_git_info() abort
  "[:-2] is trim null charactor
  let s:url    = system('git config --get remote.origin.url')[:-2]
  let s:branch = system('git symbolic-ref --short HEAD')[:-2]

  if s:is_ssh(s:url) == v:true
    let s:url = s:cv_ssh_2_http()
  endif
endfunction

function! s:is_ssh(url) abort
  return a:url !~# "https*" ? v:true :v:false
endfunction

function! s:cv_ssh_2_http()
  "2nd arg of substitute must be single quotation
  return printf('https://github.com/%s',substitute(s:url,'\(git@github.com:\|\.git$\)',"","g"))
endfunction


function! s:make_http_link() abort
  let s:url = printf('%s/blob/%s',s:url,s:branch)
endfunction

function! s:append_file_path() abort
  let list = split(s:url,'/') "expected: ['https','','github.com','{user}','{repo}','{branch}','blob']
  let s:repo_name = list[4]
  unlet list
  let pos = stridx(expand('%:p'),s:repo_name)
  let fpath = expand('%:p')[pos+len(s:repo_name):]
  let s:url = s:url . fpath
endfunction

function! s:append_line_num() abort
  let s:url = printf('%s#L%s',s:url,line('.'))
endfunction

function! s:append_multi_line_num(from,to) abort
  let s:url = printf('%s#L%s-L%s',s:url,a:from,a:to)
endfunction


function! crepl#make_permalink() abort
  call s:change_dir('init')
  call s:fetch_git_info()
  call s:make_http_link()
  call s:append_file_path()
  call s:append_line_num()
  call s:change_dir('end')
  echomsg s:url
endfunction

function! crepl#make_multiline_permalink() range abort
  call s:change_dir('init')
  call s:fetch_git_info()
  call s:make_http_link()
  call s:append_file_path()
  call s:append_multi_line_num(a:firstline,a:lastline)
  call s:change_dir('end')
  echomsg s:url
endfunction
