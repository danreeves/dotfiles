" Start plugins
"""""""""""""""
call plug#begin('~/.config/nvim/plugged')

" Theme
Plug 'andreypopp/vim-colors-plain'
" Automatic syntax for a bunch of languages
Plug 'sheerun/vim-polyglot'
" Detect editorconfig file
Plug 'editorconfig/editorconfig-vim'
" GitGutter
Plug 'airblade/vim-gitgutter'
" Automatic quote & brace completion
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
" Highlight matching tag
Plug 'valloric/matchtagalways'
" JavaScript
Plug 'pangloss/vim-javascript'
" Crystal
Plug 'vim-crystal/vim-crystal'
" Autocomplete
" Plug 'ncm2/ncm2'
" Plug 'roxma/nvim-yarp'
" Plug 'ncm2/ncm2-bufword'
" Plug 'ncm2/ncm2-path'
" Plug 'fgrsnau/ncm2-otherbuf'
" IDE Junk
Plug 'neoclide/coc.nvim', {'branch': 'release'}
Plug 'neoclide/coc-tsserver', {'do': 'yarn install --frozen-lockfile'}
Plug 'neoclide/coc-rls'

call plug#end()
" End plugins
"""""""""""""

if (has("nvim"))
  "For Neovim 0.1.3 and 0.1.4 <
  "https://github.com/neovim/neovim/pull/2198 >
  let $NVIM_TUI_ENABLE_TRUE_COLOR=1
endif

if (has("termguicolors"))
  set termguicolors
endif

" Begin config
""""""""""""""
syntax on
set termguicolors
" Theme
set background=light " Set to dark for a dark variant
colorscheme plain
" Refresh every 100ms
set updatetime=100
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
set listchars=tab:\ \ ,trail:▫
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

" tabs are cool now
set softtabstop=0 noexpandtab
set shiftwidth=2
set tabstop=4

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
let g:javascript_plugin_flow = 0

" ALE Settings
" let g:ale_linters = {
"       \  'javascript': ['eslint', 'xo', 'flow'],
"       \}
"
let g:ale_fixers = {
      \   'javascript': [
      \       'prettier',
      \   ],
      \   'typescript': [
      \       'prettier',
      \   ],
      \   'typescriptreact': [
      \       'prettier',
      \   ],
      \   'rust': [
      \       'rustfmt',
      \   ],
      \   'go': [
      \       'gofmt',
      \   ],
      \}

" \+p to autofix
map <Leader>p <Plug>(ale_fix)

let g:ale_fix_on_save = 1


" NCM2 config
" suppress the annoying 'match x of y', 'The only match' and 'Pattern not found' messages
set shortmess+=c
" autocmd BufEnter * call ncm2#enable_for_buffer()
set completeopt=noinsert,menuone,noselect
" " CTRL-C doesn't trigger the InsertLeave autocmd . map to <ESC> instead.
inoremap <c-c> <ESC>
" " Use <TAB> to select the popup menu:
" Use tab for trigger completion with characters ahead and navigate.
" NOTE: Use command ':verbose imap <tab>' to make sure tab is not mapped by
" other plugin before putting this into your config.
inoremap <silent><expr> <TAB>
      \ pumvisible() ? "\<C-n>" :
      \ <SID>check_back_space() ? "\<TAB>" :
      \ coc#refresh()
inoremap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<C-h>"

function! s:check_back_space() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~# '\s'
endfunction


" Hack for lua fix on save
function LuaFmt()
  silent !luaformatter % --autosave
  edit
endfunction
autocmd bufwritepost *.lua call LuaFmt()

" LanguageServer config
" let g:LanguageClient_serverCommands = {
"     \ 'rust': ['rls'],
"     \ 'javascript': ['typescript-language-server', '--stdio'],
"     \ 'javascript.jsx': ['typescript-language-server', '--stdio'],
"     \ 'typescript': ['typescript-language-server', '--stdio'],
"     \ 'typescriptreacreactt': ['typescript-language-server', '--stdio'],
"     \ }

" NERDTree
map <C-n> :NERDTreeToggle<CR>
let g:NERDTreeIgnore = ['node_modules', 'tmp', 'flow-typed', '.git', '.DS_Store']
let g:NERDTreeShowHidden = 1

" NERDCommenter
" <leader>c<space> is the default NERDComToggleComment
" here we rebind it to Ctrl -
" and Ctrl \
map <C-_> <leader>c<space>
map <C-\> <leader>c<space>
let g:NERDSpaceDelims = 1
let g:NERDDefaultAlign = 'left'
let g:NERDCommentEmptyLines = 1
let g:NERDTrimTrailingWhitespace = 1

" fzf keybinds
" Fuzzy search for filenames with Ctrl+p
noremap <C-p> :GitFiles<CR>
" Search for text in files with Ctrl+f
noremap <C-f> :Rg<CR>
" Jump to the existing window if possible
let g:fzf_buffers_jump = 1
" Hide the > fzf status line
autocmd! FileType fzf set laststatus=0 noshowmode noruler
  \| autocmd BufLeave <buffer> set laststatus=2 showmode ruler

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

" Highlight matching tags in these filetypes
let g:mta_filetypes = {
      \ 'javascript.jsx': 1,
      \ 'javascript': 1,
      \ 'html' : 1,
      \ 'xhtml' : 1,
      \ 'xml' : 1,
      \ 'jinja' : 1,
      \}

map <F10> :echo "hi<" . synIDattr(synID(line("."),col("."),1),"name") . '> trans<'
\ . synIDattr(synID(line("."),col("."),0),"name") . "> lo<"
\ . synIDattr(synIDtrans(synID(line("."),col("."),1)),"name") . ">"<CR>

hi MyTagOverride guifg=#008EC4 guibg=#F1F1F1
hi! link jsxPunct MyTagOverride
hi! link jsxTagName MyTagOverride
hi! link jsxComponentName MyTagOverride
hi! link jsxCloseString MyTagOverride

hi CocErrorFloat guifg=white

set statusline=
set statusline+=%f
set statusline+=%{&modified?\"\ +\":\"\"}
set statusline+=%{&readonly?\"\ [Read\ Only]\":\"\"}
set statusline+=%=
set statusline+=%{FugitiveHead()}

highlight Pmenu guibg=gray guifg=white

function! Tabline()
  let s = ''
  for i in range(tabpagenr('$'))
    let tab = i + 1
    let winnr = tabpagewinnr(tab)
    let buflist = tabpagebuflist(tab)
    let bufnr = buflist[winnr - 1]
    let bufname = bufname(bufnr)
    let bufmodified = getbufvar(bufnr, "&mod")

    let s .= '%' . tab . 'T'
    let s .= (tab == tabpagenr() ? '%#TabLineSel#' : '%#TabLine#')
    let s .= (bufname != '' ? '[ ' . tab .': ' . fnamemodify(bufname, ':t') : '[ ' . tab .': No Name')

    if bufmodified
      let s .= ' + ]'
	else
	  let s .= ' ]'
    endif
  endfor

  let s .= '%#TabLineFill#'
  if (exists("g:tablineclosebutton"))
    let s .= '%=%999XX'
  endif
  return s
endfunction
set tabline=%!Tabline()

hi TabLineFill guifg=Grey95
hi TabLine guifg=Grey60 guibg=Grey95 cterm=none gui=none
hi TabLineSel guifg=Grey35 guibg=Grey95

 autocmd ColorScheme *
              \ hi CocErrorSign  ctermfg=Red guifg=#ff0000 |
              \ hi CocWarningSign  ctermfg=Brown guifg=#ff922b |
              \ hi CocInfoSign  ctermfg=Yellow guifg=#fab005 |
              \ hi CocHintSign  ctermfg=Blue guifg=#15aabf |
              \ hi CocUnderline  cterm=underline gui=underline

"""" coc settings
" TextEdit might fail if hidden is not set.
set hidden
" Some servers have issues with backup files, see #649.
set nobackup
set nowritebackup
" GoTo code navigation.
nmap <silent> gtd <Plug>(coc-definition)
nmap <silent> gtt <Plug>(coc-type-definition)
nmap <silent> gti <Plug>(coc-implementation)
nmap <silent> gtr <Plug>(coc-references)

" Use K to show documentation in preview window.
nnoremap <silent> K :call <SID>show_documentation()<CR>

function! s:show_documentation()
  if (index(['vim','help'], &filetype) >= 0)
    execute 'h '.expand('<cword>')
  else
    call CocAction('doHover')
  endif
endfunction

" Highlight the symbol and its references when holding the cursor.
autocmd CursorHold * silent call CocActionAsync('highlight')

" Symbol renaming.
nmap <leader>rn <Plug>(coc-rename)
"""" coc settings

" Set last because something is resetting it
set noshowmode

" MUST COME LAST
" Read project .vimrc files
set exrc
" Only if they are owned by me
set secure
