"                              █████   █████  ███
"                             ░░███   ░░███  ░░░
" ████████    ██████   ██████  ░███    ░███  ████  █████████████
"░░███░░███  ███░░███ ███░░███ ░███    ░███ ░░███ ░░███░░███░░███
" ░███ ░███ ░███████ ░███ ░███ ░░███   ███   ░███  ░███ ░███ ░███
" ░███ ░███ ░███░░░  ░███ ░███  ░░░█████░    ░███  ░███ ░███ ░███
" ████ █████░░██████ ░░██████     ░░███      █████ █████░███ █████
"░░░░ ░░░░░  ░░░░░░   ░░░░░░       ░░░      ░░░░░ ░░░░░ ░░░ ░░░░░
"
" INIT.VIM
"
set nocompatible		" unnecessary for nvim...
filetype on
filetype plugin indent on
let mapleader = "\<SPACE>"
let g:mapleader = "\<SPACE>"

"
" Plugins {{{
"

let vimplug_exists=expand('~/.local/nvim/autoload/plug.vim')

if !filereadable(vimplug_exists)
  echo "Installing Vim-Plug...\n"
  silent !\curl -fLo ~/.local/nvim/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  let g:not_finish_vimplug = "yes"

  autocmd VimEnter * PlugInstall
endif

" Specify a directory for plugins
" - For Neovim: stdpath('data') . '/plugged'
" - Avoid using standard Vim directory names like 'plugin'
call plug#begin('~/.local/nvim/plugged')
" Make sure you use single quotes
	" Tpops basic sensible vim setting
	Plug 'tpope/vim-sensible'

	" Shorthand notation; fetches https://github.com/junegunn/vim-easy-align
	Plug 'junegunn/vim-easy-align'
	" Autoformat
	Plug 'Chiel92/vim-autoformat'
	" Any valid git URL is allowed
	Plug 'https://github.com/junegunn/vim-github-dashboard.git'

	" On-demand loading
	Plug 'scrooloose/nerdtree', { 'on':  'NERDTreeToggle' }
	Plug 'ryanoasis/vim-devicons'
	Plug 'kyazdani42/nvim-web-devicons'

	" Using a tagged release; wildcard allowed (requires git 1.9.2 or above)
	Plug 'fatih/vim-go', { 'tag': '*' }

	" Plugin options
	Plug 'nsf/gocode', { 'tag': 'v.20150303', 'rtp': 'vim' }

	" Plugin outside ~/.vim/plugged with post-update hook
	Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
	Plug 'junegunn/fzf.vim'

	Plug 'jremmen/vim-ripgrep'

	Plug 'mbbill/undotree'
	Plug 'junegunn/rainbow_parentheses.vim'
	Plug 'scrooloose/syntastic'
	Plug 'jiangmiao/auto-pairs'
	"Plug 'itchyny/lightline.vim'
    Plug 'glepnir/spaceline.vim'
	Plug 'luochen1990/rainbow'                              " rainbow parenthesis

	Plug 'ntpeters/vim-better-whitespace'

	" git
	Plug 'itchyny/vim-gitbranch'
	Plug 'tpope/vim-fugitive'
	" Show git stuff in gutter
	Plug 'airblade/vim-gitgutter'
	" theme
	Plug 'gruvbox-community/gruvbox'
	" visual debugger
	Plug 'puremourning/vimspector'
	" c# stuff
	Plug 'OmniSharp/omnisharp-vim'
	Plug 'dense-analysis/ale'
	Plug 'sheerun/vim-polyglot'
	Plug 'neoclide/coc.nvim', { 'branch': 'release' }
" Initialize plugin system
call plug#end()

" Automatically install missing plugins on startup
if !empty(filter(copy(g:plugs), '!isdirectory(v:val.dir)'))
  autocmd VimEnter * PlugInstall | q
endif

" }}}

"
" Configs... {{{
"

" vimspector
let g:vimspector_enable_mappings='HUMAN'
nmap <leader>dd :call vimspector#Launch()<CR>
nmap <leader>dx :VimspectorReset<CR>
nmap <leader>de :VimspectorEval
nmap <leader>dw :VimspectorWatch
nmap <leader>do	:VimspectorShowOutput
"autocmd Filetype java nmap <leader>dd :CocCommand java.debug.vimspector.start<CR>

"undotree
"  Map show undo tree
nnoremap <leader>u :UndotreeToggle<CR>

" Syntastic settings
let g:elm_syntastic_show_warnings = 1
"set statusline+=%#warningmsg#
"set statusline+=%{SyntasticStatuslineFlag()}
"set statusline+=%*
let g:syntastic_always_populate_loc_list = 1
let g:syntastic_auto_loc_list = 1
let g:syntastic_check_on_open = 1
let g:syntastic_check_on_wq = 0

" CoC settings
inoremap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<C-h>"
inoremap <silent><expr> <c-space> coc#refresh()
nmap <silent> <leader>gd <Plug>(coc-definition)
nmap <silent> <leader>gy <Plug>(coc-type-definition)
nmap <silent> <leader>gi <Plug>(coc-implementation)
nmap <silent> <leader>gr <Plug>(coc-references)
" Use `[g` and `]g` to navigate diagnostics
nmap <silent> [g <Plug>(coc-diagnostic-prev)
nmap <silent> ]g <Plug>(coc-diagnostic-next)
nnoremap <buffer> <leader>cr :CocRestart

function! s:check_back_space() abort
	let col = col('.') - 1
	return !col || getline('.')[col - 1]  =~# '\s'
endfunction

inoremap <silent><expr> <TAB>
      \ pumvisible() ? "\<C-n>" :
      \ <SID>check_back_space() ? "\<TAB>" :
      \ coc#refresh()
inoremap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<C-h>"
" completion for Omnisharp
let g:coc_global_extensions=[ 'coc-omnisharp' ]
" Omnisharp
let g:omnicomplete_fetch_full_documentation = 1
let g:OmniSharp_autoselect_existing_sln = 1
let g:OmniSharp_popup_position = 'peek'
let g:OmniSharp_highlighting = 3
let g:OmniSharp_diagnostic_exclude_paths = [ 'Temp[/\\]', 'obj[/\\]', '\.nuget[/\\]' ]
let g:OmniSharp_fzf_options = { 'down': '10' }

augroup csharp_commands
    autocmd!
    autocmd FileType cs nmap <buffer> gd <Plug>(omnisharp_go_to_definition)
    autocmd FileType cs nmap <buffer> <Leader><Space> <Plug>(omnisharp_code_actions)
    autocmd FileType cs xmap <buffer> <Leader><Space> <Plug>(omnisharp_code_actions)
    autocmd FileType cs nmap <buffer> <F2> <Plug>(omnisharp_rename)
    autocmd FileType cs nmap <buffer> <Leader>cf <Plug>(omnisharp_code_format)
    autocmd FileType cs nmap <buffer> <Leader>fi <Plug>(omnisharp_find_implementations)
    autocmd FileType cs nmap <buffer> <Leader>fs <Plug>(omnisharp_find_symbol)
    autocmd FileType cs nmap <buffer> <Leader>fu <Plug>(omnisharp_find_usages)
    autocmd FileType cs nmap <buffer> <Leader>dc <Plug>(omnisharp_documentation)
    autocmd FileType cs nmap <buffer> <Leader>cc <Plug>(omnisharp_global_code_check)
    autocmd FileType cs nmap <buffer> <Leader>rt <Plug>(omnisharp_run_test)
    autocmd FileType cs nmap <buffer> <Leader>rT <Plug>(omnisharp_run_tests_in_file)
    autocmd FileType cs nmap <buffer> <Leader>ss <Plug>(omnisharp_start_server)
    autocmd FileType cs nmap <buffer> <Leader>sp <Plug>(omnisharp_stop_server)
    autocmd FileType cs nmap <buffer> <C-\> <Plug>(omnisharp_signature_help)
    autocmd FileType cs imap <buffer> <C-\> <Plug>(omnisharp_signature_help)
    autocmd BufWritePre *.cs :OmniSharpCodeFormat

    " vim-better-whitespace
    autocmd FileType cs let g:strip_whitespace_on_save = 1
    autocmd FileType cs let g:strip_whitespace_confirm = 0
augroup END

" rainbow brackets
let g:rainbow_active = 1

" NERDtree
let g:WebDevIconsUnicodeDecorateFolderNodes = 1
let g:DevIconsEnableFoldersOpenClose = 1
let g:DevIconsEnableFolderExtensionPatternMatching = 1
let g:NERDTreeShowHidden = 1
let g:NERDTreeMinimalUI = 1
let g:NERDTreeIgnore = []
let g:NERDTreeStatusline = ''
" ctrl+p when you move to a file this highlights it.
let g:nerdtree_sync_cursorline = 1
" Automaticaly close nvim if NERDTree is only thing left open
autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTree") && b:NERDTree.isTabTree()) | q | endif
"autocmd vimenter * NERDTree		"autoload nerdtree
nmap <leader>e :NERDTreeToggle<CR>

" FZF
if executable('fzf')
    nnoremap <C-p> :FZF<CR>
	let g:fzf_layout = {'window': {'width': 0.8, 'height': 0.5, 'yoffset': 0.1, 'border': 'rounded'}}
endif

" --column: Show column number
" --line-number: Show line number
" --no-heading: Do not show file headings in results
" --fixed-strings: Search term as a literal string
" --ignore-case: Case insensitive search
" --no-ignore: Do not respect .gitignore, etc...
" --hidden: Search hidden files and folders
" --follow: Follow symlinks
" --glob: Additional conditions for search (in this case ignore everything in the .git/ folder)
" --color: Search color options
command! -bang -nargs=* Find call fzf#vim#grep('rg --column --line-number --no-heading --fixed-strings --ignore-case --no-ignore --hidden --follow --glob "!.git/*" --color "always" '.shellescape(<q-args>), 1, <bang>0)

" Autoformat
noremap <leader>f :Autoformat<CR>
" vimspector
let g:vimspector_enable_mappings = 'VISUAL_STUDIO'

" ALE
" from https://github.com/magtastic/.dotfiles/blob/master/.vim/.vimrc
let g:ale_linters = {
	\ 'cs': ['OmniSharp'],
	\}
let g:ale_fixers = {
 \ 'javascript': ['eslint']
 \ }

let g:ale_sign_error = '❌'
let g:ale_sign_warning = '⚠️'
let g:ale_fix_on_save = 1

let b:ale_linters = ['cs']
let g:ale_completion_enabled=1
let g:ale_sign_column_always=1
nmap <silent> [W <Plug>(ale_first)
nmap <silent> ]W <Plug>(ale_first)
nmap <silent> [w <Plug>(ale_previous)
nmap <silent> ]w <Plug>(ale_next)


" }}}

" GUI {{{
let $NVIM_TUI_ENABLE_TRUE_COLOR=1
set t_Co=256
set termguicolors
colorscheme gruvbox
set linespace=2			" more space for messages
set laststatus=2		" always show statusline
set background=dark
set emoji

let g:gruvbox_contrast_dark = 'hard'
"let g:lightline = {
"    \ 'active': {
"    \   'left': [
"    \     ['mode', 'paste'],
"    \     ['gitbranch', 'readonly', 'filename', 'modified']
"    \   ],
"    \   'right': [
"    \     ['lineinfo'],
"    \     ['percent'],
"    \     ['fileformat', 'fileencoding', 'filetype', 'scrollbar']
"    \   ]
"    \ },
"    \ 'component_function': {
"    \   'gitbranch':    'FugitiveHead',
"    \ },
"    \ 'colorscheme': 'seoul256',
"    \ }
let g:spaceline_seperate_style= 'arrow-fade'
let g:spaceline_colorscheme = 'space'

set guifont=FiraCode\ Nerd\ Font\ Mono:h14
set guioptions=egmrti
set signcolumn=yes		" Git Gutter always shows
set lazyredraw			" dont redraw screen during macro execution

" Character to show before the lines that have been soft-wrapped
set showbreak=↪

set mouse=a
syntax on
set autoread autowrite
" }}}

set noerrorbells		"dont beep
set visualbell
set noruler				"lighline already has it

set nosol				"no start-of-line
set showcmd
set cmdheight=2			"more space for messages
set showmatch
set matchtime=2
set nospell

set noswapfile
set nobackup
set undodir=~/.vim/undodir
set undofile
set undolevels=1000 undoreload=10000

set title
set titlestring=%t\ %m\ (%{expand('%:p:h')})
set showtabline=2		"always show the tabline at the top
set completeopt=longest,menuone,preview
set pumheight=10		" Maximum number of items to show in popup menu

set magic				"regular expressions
set backspace=indent,eol,start
set conceallevel=0		"don't hide my shit
set hidden
set number relativenumber
set smartindent
set ignorecase
set smartcase
set hlsearch			"highlight search
set incsearch
set tbs					"binary search on tagfile
set updatetime=500
set ttimeoutlen=100
set fileformat=unix
set encoding=utf-8
set fileencoding=utf-8
set fileencodings=utf-8
set history=150         " keep 150 lines of command line history
set scrolljump=-15		" accelerated scrolling
set ttyfast

set smarttab
set noexpandtab			" we dont like spaces for indentation
set shiftwidth=4
set softtabstop=4
set tabstop=4

set clipboard+=unnamedplus
set wildmode=longest,list,full
set wildignorecase

set splitbelow splitright
set cursorline cursorcolumn
" autocenter screen on Insert
autocmd InsertEnter * norm zz
" autoreload vimrc on write
autocmd BufWritePost $MYVIMRC source %

set grepprg=rg\ --vimgrep\ --no-heading\ --smart-case
set grepformat=%f:%l:%c:%m
if executable('ag')
  " Use Ag over Grep
  set grepprg=ag\ --nogroup\ --nocolor

  " Use ag in CtrlP for listing files. Lightning fast and respects .gitignore
  " let g:ctrlp_user_command = 'ag %s -l --nocolor -g ""'
endif

"
" mappings {{{
"


" - split navigation
map <C-Left> <C-w>h
map <C-Down> <C-w>j
map <C-Up> <C-w>k
map <C-Right> <C-w>l

map <C-h> <C-w>h
map <C-j> <C-w>j
map <C-k> <C-w>k
map <C-l> <C-w>l

" - resize panels
nnoremap <M-j>	:resize -2<CR>
nnoremap <M-k>	:resize +2<CR>
nnoremap <M-h>	:vertical resize -2<CR>
nnoremap <M-l>	:vertical resize +2<CR>

" - why not ?
nnoremap ; :

map Q gq
map <C-Z> :undo<CR>
imap <C-Z> <ESC>:undo<CR>i
map <F5> <ESC>v%
imap <F5> <ESC>v%
map P "*p
nmap <BS> X

nnoremap <C-S> :w<CR>
inoremap <C-S> <ESC>:w<CR>i
map     <S-C-T> :tabnew<CR>
imap    <S-C-T> <ESC>:tabnew<CR>i

map     <C-TAB> :bnext<CR>
imap    <C-TAB> <ESC>:bnext<CR>i
map     <S-C-TAB> :bprev<CR>
imap    <S-C-TAB> <ESC>:bprev<CR>i

"--- shift-insert default (CLI) behaviour
map <S-Insert> <MiddleMouse>
map! <S-Insert> <MiddleMouse>

" better tabbing
vnoremap < <gv
vnoremap > >gv

" Make p in Visual mode replace the selected text with the "" register.
vnoremap p <Esc>:let current_reg = @"<CR>gvs<C-R>=current_reg<CR><Esc>
" }}}

"
" Helper functions {{{
"

" fix python3 expected to be "python" on $PATH
let g:python3_host_prog = '/usr/bin/python3'

" Trim Whitespaces
function! TrimWhitespace()
    let l:save = winsaveview()
    %s/\\\@<!\s\+$//e
    call winrestview(l:save)
endfunction
autocmd BufWritePre * :call TrimWhitespace()


" fast sum
fu! SumFunc() range
    let old = @a
    normal gv"ay
    let sel=@a
    let @a=old

    let res=0
    try
        exe 'let res = ' . join(split(sel,'\n'), '+')
        "call append(a:lastline, printf("Sum: %.02f", res))
        echom "Sum " res
    catch
        return -1
    endtry
    return 0
endfu
cmap SS call SumFunc()

" Use K to show documentation in preview window.
nnoremap <silent> K :call <SID>show_documentation()<CR>

function! s:show_documentation()
  if (index(['vim','help'], &filetype) >= 0)
    execute 'h '.expand('<cword>')
  else
    call CocAction('doHover')
  endif
endfunction

" autoload modified file
" Triger `autoread` when files changes on disk
" https://unix.stackexchange.com/questions/149209/refresh-changed-content-of-file-opened-in-vim/383044#383044
" https://vi.stackexchange.com/questions/13692/prevent-focusgained-autocmd-running-in-command-line-editing-mode
autocmd FocusGained,BufEnter,CursorHold,CursorHoldI * if mode() != 'c' | checktime | endif
set autoread
" Notification after file change
" https://vi.stackexchange.com/questions/13091/autocmd-event-for-autoread
autocmd FileChangedShellPost *
  \ echohl WarningMsg | echo "File changed on disk. Buffer reloaded." | echohl None

" }}}
