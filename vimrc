set nocompatible                " Because vi is old
set backspace=indent,eol,start  " Backspace should delete anything
set autoindent                  " Copy indent when starting new line
set history=50		            " 50 lines of history
set ruler		                " Always show cursor position
set shiftwidth=4                " Spaces used for indend
set smarttab                    " Deletes as much as it tabs
set tabstop=4                   " Number of spaces a tab translates to
set expandtab                   " Tab characters are bad, see
set ignorecase                  " Generally, search should ignore case
set smartcase                   " Ignore case unless you use caps
set scrolloff=3                 " When scrolling, always show X lines context
set incsearch                   " Search as you type
set showcmd                     " Show the command at the bottom
set shortmess=atI               " Quiet vim, prevents many 'hit-enter' alets

" Modelines are super cool, but also crazy dangerous
"  If you need them, enable them per-project
set modelines=0
set nomodeline

set viminfo='20,\"500	" keep a .viminfo file

" syntax highlighting if terminal supports it
if &t_Co > 2 || has("gui_running")
  syntax on
  set hlsearch
endif

if &term=="xterm"
	set t_Co=8
	set t_Sb=^[4%dm
	set t_Sf=^[3%dm
endif

inoremap <C-U> <C-G>u<C-U>

if has("autocmd")

  " Enable file type detection.
  " Use the default filetype settings, so that mail gets 'tw' set to 72,
  " 'cindent' is on in C files, etc.
  " Also load indent files, to automatically do language-dependent indenting.
  filetype plugin indent on

  " Put these in an autocmd group, so that we can delete them easily.
  augroup vimrcEx
  au!

  " For all text files set 'textwidth' to 78 characters.
  autocmd FileType text setlocal textwidth=78

  " When editing a file, always jump to the last known cursor position.
  " Don't do it when the position is invalid or when inside an event handler
  " (happens when dropping a file on gvim).
  " Also don't do it when the mark is in the first line, that is the default
  " position when opening a file.
  autocmd BufReadPost *
    \ if line("'\"") > 1 && line("'\"") <= line("$") |
    \   exe "normal! g`\"" |
    \ endif

  augroup END
else
	set autoindent		" always set autoindenting on
endif " has("autocmd")

if !exists(":DiffOrig")
  command DiffOrig vert new | set bt=nofile | r # | 0d_ | diffthis
		  \ | wincmd p | diffthis
endif

if has ('mouse')
	set mouse=a
endif

if has('gui_running')
	map <S-Insert> <MiddleMouse>
	map! <S-Insert> <MiddleMouse>
endif

au BufRead,BufNewFile *.include setfiletype xml
au BufRead,BufNewFile *.build   setfiletype xml
au BufRead,BufNewFile *.md,*.mkdn,*.markdown   set filetype=markdown

if &term ==? "gnome" && has("eval")
 " Set useful keys that vim doesn't discover via termcap but are in the
 " builtin xterm termcap. See bug #122562. We use exec to avoid having to
 " include raw escapes in the file.
  exec "set <C-Left>=\eO5D"
  exec "set <C-Right>=\eO5C"
endif

if isdirectory(expand("$VIMRUNTIME/ftplugin"))
  filetype plugin on
  "filetype indent on
endif

if has("eval")
  let is_bash=1
endif

let g:xml_syntax_folding = 1
set foldenable
set foldmethod=syntax
set foldlevel=999
set clipboard=unnamed

" Highlights the 80th column, for better line length control
if exists('+colorcolumn')
  set colorcolumn=80
  hi ColorColumn ctermbg=darkgrey guibg=darkgrey
endif

" Supposedly this is better than '\'
let mapleader = ","

" Set shortcut for pep8 report
let g:pep8_map='<leader>8'

" Activate Pathogen
call pathogen#infect()
call pathogen#helptags()


" Add the virtualenv's site-packages to vim path
py << EOF
import os.path
import sys
import vim
if 'VIRTUAL_ENV' in os.environ:
    project_base_dir = os.environ['VIRTUAL_ENV']
    sys.path.insert(0, project_base_dir)
    activate_this = os.path.join(project_base_dir, 'bin/activate_this.py')
    execfile(activate_this, dict(__file__=activate_this))
EOF

" Enable python 'supertab' completion
au FileType python set omnifunc=pythoncomplete#Complete
let g:SuperTabDefaultCompletionType = "context"
set completeopt=menuone,longest,preview

" Set shortcuts for py.test
"   Execute the tests
nmap <silent><Leader>tf <Esc>:Pytest file<CR>
nmap <silent><Leader>tc <Esc>:Pytest class<CR>
nmap <silent><Leader>tm <Esc>:Pytest method<CR>
"   cycle through test errors
nmap <silent><Leader>tn <Esc>:Pytest next<CR>
nmap <silent><Leader>tp <Esc>:Pytest previous<CR>
nmap <silent><Leader>te <Esc>:Pytest error<CR>

" Set some rope shortcuts
map <leader>j :RopeGotoDefinition<CR>
map <leader>r :RopeRename<CR>

" Supposed to show trailing whitespace, does not yet work
set listchars=tab:>-,trail:·,eol:$
nmap <silent> <leader>s :set nolist!<CR>

" Helps Command-T to ignore files
set wildignore+=*.o,*.obj,.git,*.pyc,*.pyo,__pycache__

" Put some of the local only commands in untracked files
source ~/.vimrc.rfi
source ~/.vimrc.private
