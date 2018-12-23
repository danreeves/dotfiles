" Start plugins
"""""""""""""""
call plug#begin('~/.config/nvim/plugged')

" One Dark theme
Plug 'joshdick/onedark.vim'
" Automatic syntax for a bunch of languages
Plug 'sheerun/vim-polyglot'
" Detect editorconfig file
Plug 'editorconfig/editorconfig-vim'
" GitGutter
Plug 'airblade/vim-gitgutter'
" Simple tab autocompletion
Plug 'ajh17/vimcompletesme'
" Automatice quote & brace completion
Plug 'raimondi/delimitmate'
" Linting
Plug 'w0rp/ale'
" File tree explorer
Plug 'scrooloose/nerdtree'
" Code comment helper
Plug 'scrooloose/nerdcommenter'
" Surrounding quote/brace helper
Plug 'tpope/vim-surround'
" Git plugin
Plug 'tpope/vim-fugitive'
" GitHub enhancement to fugitive
Plug 'tpope/vim-rhubarb'
" fzf fuzzy finder
Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
" fzf vim plugin
Plug 'junegunn/fzf.vim'
" No distractions mode
Plug 'junegunn/goyo.vim'
" Minimal status bar
Plug 'itchyny/lightline.vim'
" Highlight matching tag
Plug 'valloric/matchtagalways'
" Flow omnifunc
Plug 'flowtype/vim-flow'
" Flow coverage
Plug 'carlosrocha/vim-flow-plus'
" JavaScript
Plug 'pangloss/vim-javascript'
" GraphQL
" Plug 'jparise/vim-graphql'
" styled-components
" Plug 'styled-components/vim-styled-components'
Plug 'autozimu/LanguageClient-neovim', {
      \ 'branch': 'next',
      \ 'do': 'bash install.sh',
      \ }

call plug#end()
" End plugins
"""""""""""""

" Begin config
""""""""""""""
syntax on
set termguicolors
" One Dark colour theme
colorscheme onedark
" Refresh every 250ms
set updatetime=250
" Show 80 col
set colorcolumn=80
" Show line number
set number
" Enable filetype plugins
filetype plugin on
" Show existing tab with 4 spaces width
set tabstop=4
" When indenting with '>', use 4 spaces width
set shiftwidth=4
" On pressing tab, insert 4 spaces
set expandtab
" Autoindent?
set autoindent
" Reload files when changed on disk, i.e. via `git checkout`
set autoread
" Fix broken backspace in some setups
set backspace=2
" See :help crontab
set backupcopy=yes
" Yank and paste with the system clipboard
set clipboard=unnamed
" Don't store swapfiles in the current directory
set directory-=.
" Save with utf8 encoding
set encoding=utf-8
" Case-insensitive search
set ignorecase
" Search as you type
set incsearch
" Always show statusline
set laststatus=2
" Show trailing whitespace
set list
" Display tabs an invisible characters
set listchars=tab:▸\ ,trail:▫
" Show where you are
set ruler
" Show context above/below cursorline
set scrolloff=5
" Normal mode indentation commands use 2 spaces
set shiftwidth=2
" Show the command line at the bottom
set showcmd
" Case-sensitive search if any caps
set smartcase
" Insert mode tab and backspace use 2 spaces
set softtabstop=2
" Actual tabs occupy 8 characters
set tabstop=8
" Show a navigable menu for tab completion
set wildmenu
" Wildmode config
set wildmode=longest,list,full
" Highlight the current line
set cursorline

" Enable basic mouse behavior such as resizing buffers.
set mouse=a

" Set the cursor back to a vertical bar on exit
au VimLeave * set guicursor=a:ver1-blinkon1

" Try to autoload files that have changed on the file system
autocmd BufEnter,FocusGained * checktime

" FixWhitespace function taken from bronson/vim-trailing-whitespace
function! s:FixWhitespace(line1,line2)
  let l:save_cursor = getpos(".")
  silent! execute ':' . a:line1 . ',' . a:line2 . 's/\\\@<!\s\+$//'
  call setpos('.', l:save_cursor)
endfunction
" Run :FixWhitespace to remove end of line white space
command! -range=% FixWhitespace call <SID>FixWhitespace(<line1>,<line2>)
" Fix whitespace on save
au BufWritePre * :FixWhitespace

" Flow syntax
let g:javascript_plugin_flow = 1

"Use locally installed flow
function! FindLocalFlow ()
  let project_path = substitute(system('git rev-parse --show-toplevel'), '\n\+$', '', '')
  let flow_path = project_path . '/node_modules/.bin/flow'
  if executable(flow_path)
    return flow_path
  endif
  return 'flow'
endfunction

" Use local flow bin if it exists
let g:flow#flowpath = FindLocalFlow()
let g:ale_javascript_flow_executable = FindLocalFlow()
let g:javascript_flow_use_global = 0

" Disable flow quickfix box popping up
let g:flow#showquickfix = 0
" Underline uncovered lines
highlight FlowCoverage gui=underline

" ALE Settings
let g:ale_linters = {
      \  'javascript': [],
      \}

let g:ale_fixers = {
      \   'javascript': [
      \       'prettier',
      \   ],
      \   'rust': [
      \       'rustfmt',
      \   ],
      \   'go': [
      \       'gofmt',
      \   ]
      \}

" \+p to autofix
map <Leader>p <Plug>(ale_fix)

let g:ale_fix_on_save = 1

" LanguageServer config
let g:LanguageClient_serverCommands = {
      \ 'rust': ['rls'],
      \ }

" NERDTree
map <C-n> :NERDTreeToggle<CR>
let g:NERDTreeIgnore = ['node_modules', 'tmp', 'flow-typed', '.git', '.DS_Store']
let g:NERDTreeShowHidden = 1

" NERDCommenter
" <leader>c<space> is NERDComToggleComment
map <C-_> <leader>c<space>
let g:NERDSpaceDelims = 1

" fzf keybinds
" Fuzzy search for filenames with Ctrl+p
noremap <C-p> :Files<CR>
" Search for text in files with Ctrl+f
noremap <C-f> :Find<CR>
" Jump to the existing window if possible
let g:fzf_buffers_jump = 1

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

" Close the fzf buffer quicker when you hit esc
" Some sort of nvim bug
" See https://github.com/junegunn/fzf/issues/632
if has('nvim')
  aug fzf_setup
    au!
    au TermOpen term://*FZF tnoremap <silent> <buffer><nowait> <esc> <c-c>
  aug END
end

" Tabs
noremap <Leader>e :tabnew<CR>
noremap <Leader>w :tabclose<CR>
noremap <Leader>1 1gt
noremap <Leader>2 2gt
noremap <Leader>3 3gt
noremap <Leader>4 4gt
noremap <Leader>5 5gt
noremap <Leader>6 6gt
noremap <Leader>7 7gt
noremap <Leader>8 8gt
noremap <Leader>9 9gt

" Alias :gh to :Gbrowse
cnoreabbrev gh Gbrowse

" Status bar config
" Remove redundant mode line
set noshowmode
let g:lightline = {
      \  'colorscheme': 'one',
      \  'active': {
      \    'left': [
      \      [ 'mode' ],
      \      ['gitbranch', 'filename', 'modified']
      \    ],
      \    'right': [
      \      ['lineinfo'],
      \      ['percent'],
      \      ['linter_warnings', 'linter_errors', 'linter_ok'],
      \      ['flow'],
      \    ],
      \  },
      \  'component_function': {
      \    'gitbranch': 'fugitive#head',
      \    'flow': 'LightlineFlowCoverage',
      \  },
      \ 'component_expand': {
      \   'linter_warnings': 'LightlineLinterWarnings',
      \   'linter_errors': 'LightlineLinterErrors',
      \   'linter_ok': 'LightlineLinterOK'
      \ },
      \ 'component_type': {
      \   'linter_warnings': 'warning',
      \   'linter_errors': 'error',
      \   'linter_ok': 'ok',
      \ },
      \}

function! LightlineLinterWarnings() abort
  let l:counts = ale#statusline#Count(bufnr(''))
  let l:all_errors = l:counts.error + l:counts.style_error
  let l:all_non_errors = l:counts.total - l:all_errors
  return l:counts.total == 0 ? '' : printf('%d ●', all_non_errors)
endfunction

function! LightlineLinterErrors() abort
  let l:counts = ale#statusline#Count(bufnr(''))
  let l:all_errors = l:counts.error + l:counts.style_error
  let l:all_non_errors = l:counts.total - l:all_errors
  return l:counts.total == 0 ? '' : printf('%d ✗', all_errors)
endfunction

function! LightlineLinterOK() abort
  let l:counts = ale#statusline#Count(bufnr(''))
  let l:all_errors = l:counts.error + l:counts.style_error
  let l:all_non_errors = l:counts.total - l:all_errors
  return l:counts.total == 0 ? '✓ ' : ''
endfunction

function! LightlineFlowCoverage()
  if exists('b:flow_coverage_status')
    return b:flow_coverage_status
  endif
  return ''
endfunction

autocmd User ALELint call s:MaybeUpdateLightline()

" Update and show lightline but only if it's visible (e.g., not in Goyo)
function! s:MaybeUpdateLightline()
  if exists('#lightline')
    call lightline#update()
  end
endfunction

" Highlight matching tags in these filetypes
let g:mta_filetypes = {
      \ 'javascript.jsx': 1,
      \ 'html' : 1,
      \ 'xhtml' : 1,
      \ 'xml' : 1,
      \ 'jinja' : 1,
      \}
" Custom highlighting
let g:mta_use_matchparen_group = 0
let g:mta_set_default_matchtag_color = 0
highlight MatchTag gui=bold

" MUST COME LAST
" Read project .vimrc files
set exrc
" Only if they are owned by me
set secure
