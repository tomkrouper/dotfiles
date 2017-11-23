" Switch syntax highlighting on
:color slate
syntax on

" always show ruler at bottom
set ruler

" don't make foo~ files
set nobackup

" searching
set ignorecase
set smartcase

" indentation
set autoindent
set smarttab
if has("autocmd")
  filetype on
  filetype indent on
  filetype plugin on
endif
set list
set expandtab
set shiftwidth=2
set softtabstop=2
set tabstop=2

" whitespace
if has("multi_byte")
  set encoding=utf-8
  set list listchars=tab:»·,trail:·
else
  set list listchars=tab:>-,trail:.
endif

" disable mouse integration
set mouse=

" Setup pathogen
execute pathogen#infect()

" Syntastic Settings
set statusline+=%#warningmsg#
set statusline+=%{SyntasticStatuslineFlag()}
set statusline+=%*

let g:syntastic_always_populate_loc_list = 1
let g:syntastic_auto_loc_list = 1
let g:syntastic_check_on_open = 1
let g:syntastic_check_on_wq = 0
let g:syntastic_loc_list_height = 5
let g:syntastic_puppet_puppetlint_args = "--no-80chars-check --no-documentation-check"
let g:syntastic_sh_shellcheck_args = "--exclude=SC1090,SC1091,SC2068,SC2086"
