" 42 Piscine .vimrc — C & Bash
" First run: curl -fLo ~/.vim/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
" Then :PlugInstall  +  :CocInstall coc-clangd coc-sh
" Tools: pipx install norminette c-formatter-42

" === CORE ===
set nocompatible
syntax on
filetype plugin indent on
set encoding=utf-8
set backspace=indent,eol,start
set number relativenumber
set signcolumn=yes
set termguicolors
set background=dark
set scrolloff=8 sidescrolloff=8
set noexpandtab tabstop=4 shiftwidth=4 softtabstop=4
set textwidth=80 colorcolumn=81
set list listchars=tab:▸\ ,trail:·
set ignorecase smartcase incsearch hlsearch
set mouse=a updatetime=300 timeoutlen=400
set splitright splitbelow wildmenu
set completeopt=menu,menuone,noselect
set undofile backup writebackup
set backupdir=~/.logs/vim/backup// directory=~/.logs/vim/swap// undodir=~/.logs/vim/undo//
silent! call mkdir(expand('~/.logs/vim/backup'), 'p')
silent! call mkdir(expand('~/.logs/vim/swap'), 'p')
silent! call mkdir(expand('~/.logs/vim/undo'), 'p')

let mapleader = " "
let maplocalleader = " "
let g:user42 = 'nfavier'
let g:mail42 = 'nfavier@student.42.fr'

" === PLUGINS ===
call plug#begin('~/.vim/plugged')
  Plug 'dense-analysis/ale'
  Plug 'neoclide/coc.nvim', {'branch': 'release'}
  Plug 'pbondoer/vim-42header'
  Plug 'cacharle/c_formatter_42.vim'
  Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
  Plug 'junegunn/fzf.vim'
  Plug 'preservim/nerdtree'
  Plug 'ThePrimeagen/harpoon'
  Plug 'airblade/vim-gitgutter'
  Plug 'tpope/vim-fugitive'
  Plug 'tpope/vim-commentary'
  Plug 'jiangmiao/auto-pairs'
  Plug 'tpope/vim-surround'
  Plug 'vim-airline/vim-airline'
  Plug 'vim-airline/vim-airline-themes'
  Plug 'mhinz/vim-startify'
  Plug 'ryanoasis/vim-devicons'
  Plug 'preservim/tagbar'
  Plug 'ghifarit53/tokyonight-vim'
call plug#end()

" === COLORSCHEME ===
try
  let g:tokyonight_style = 'night'
  let g:tokyonight_transparent_background = 1
  let g:tokyonight_enable_italic = 1
  colorscheme tokyonight
catch
  colorscheme desert
endtry

" === FILETYPE ===
augroup piscine_filetypes
  autocmd!
  autocmd FileType c,h setlocal noexpandtab tabstop=4 shiftwidth=4
  autocmd FileType sh setlocal noexpandtab tabstop=4 shiftwidth=4
  autocmd BufWritePre *.c,*.h,*.sh :%s/\s\+$//e
augroup END

" === ALE ===
let g:ale_linters_explicit = 1
let g:ale_linters = {
\   'c':  ['norminette', 'clangd'],
\   'sh': ['shellcheck', 'bashls'],
\}
let g:ale_lint_on_text_changed = 'never'
let g:ale_lint_on_insert_leave = 0
let g:ale_lint_on_save = 1
let g:ale_lint_on_enter = 1
let g:ale_completion_enabled = 0
let g:ale_sign_error = '✗'
let g:ale_sign_warning = '⚠'
let g:ale_echo_msg_format = '[%linter%] %s [%severity%]'

" === COC ===
inoremap <silent><expr> <TAB>
      \ coc#pum#visible() ? coc#pum#next(1) :
      \ CheckBackspace() ? "\<Tab>" :
      \ coc#refresh()
inoremap <expr><S-TAB> coc#pum#visible() ? coc#pum#prev(1) : "\<C-h>"
inoremap <silent><expr> <CR> coc#pum#visible() ? coc#pum#confirm() : "\<CR>"
inoremap <silent><expr> <C-Space> coc#refresh()

function! CheckBackspace() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1] =~# '\s'
endfunction

nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gr <Plug>(coc-references)
nmap <silent> gi <Plug>(coc-implementation)
nmap <silent> gy <Plug>(coc-type-definition)
nnoremap <silent> K :call ShowDocumentation()<CR>
function! ShowDocumentation()
  if CocAction('hasProvider', 'hover')
    call CocActionAsync('doHover')
  else
    call feedkeys('K', 'in')
  endif
endfunction

nmap <leader>rn <Plug>(coc-rename)
nmap <leader>ca <Plug>(coc-codeaction-cursor)
nmap <silent> [d <Plug>(coc-diagnostic-prev)
nmap <silent> ]d <Plug>(coc-diagnostic-next)

" === KEYMAPS ===
nnoremap <C-h> <C-w>h
nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k
nnoremap <C-l> <C-w>l

nnoremap <leader>bn :bnext<CR>
nnoremap <leader>bp :bprevious<CR>
nnoremap <leader>bd :bdelete<CR>

nnoremap <leader>tn :tabnext<CR>
nnoremap <leader>tp :tabprevious<CR>
nnoremap <leader>to :tabnew<CR>
nnoremap <leader>tc :tabclose<CR>

nnoremap <leader>ff :Files<CR>
nnoremap <leader>fb :Buffers<CR>
nnoremap <leader>fg :GFiles<CR>
nnoremap <leader>/  :Rg<CR>

nnoremap <leader>e :NERDTreeToggle<CR>
nnoremap <leader>cs :TagbarToggle<CR>

nnoremap <leader>a :lua require("harpoon.mark").add_file()<CR>
nnoremap <leader>h :lua require("harpoon.ui").toggle_quick_menu()<CR>
nnoremap <leader>1 :lua require("harpoon.ui").nav_file(1)<CR>
nnoremap <leader>2 :lua require("harpoon.ui").nav_file(2)<CR>
nnoremap <leader>3 :lua require("harpoon.ui").nav_file(3)<CR>
nnoremap <leader>4 :lua require("harpoon.ui").nav_file(4)<CR>

nnoremap <leader>y "+y
vnoremap <leader>y "+y
nnoremap <leader>Y "+Y
nnoremap <leader>p "+p
nnoremap <leader>P "+P
nnoremap <silent> <leader>nh :nohlsearch<CR>

" === C / BASH WORKFLOW ===
nnoremap <leader>cc :!gcc -Wall -Wextra -Werror % -o %:r<CR>
nnoremap <leader>cr :!gcc -Wall -Wextra -Werror % -o %:r && ./%:r<CR>
nnoremap <leader>mk :!make<CR>
nnoremap <leader>mc :!make clean<CR>
nnoremap <leader>mf :!make fclean<CR>
nnoremap <leader>mr :!make re<CR>
nnoremap <leader>rb :!bash %<CR>
nnoremap <leader>cf :!c_formatter_42 %<CR>:edit!<CR>
nnoremap <leader>nm :!norminette %<CR>

" === STARTIFY ===
let g:startify_custom_header = startify#center([
\ '   ██╗  ██╗██████╗ ',
\ '   ██║  ██║╚════██╗',
\ '   ███████║ █████╔╝',
\ '   ╚════██║██╔═══╝ ',
\ '        ██║███████╗',
\ '        ╚═╝╚══════╝',
\ '',
\ '   PISCINE  ·  42 PARIS',
\ '',
\ ])
let g:startify_lists = [
\ { 'type': 'files',     'header': ['   Recent files']           },
\ { 'type': 'dir',       'header': ['   Current dir '. getcwd()] },
\ { 'type': 'sessions',  'header': ['   Sessions']               },
\ { 'type': 'bookmarks', 'header': ['   Bookmarks']              },
\ ]
let g:startify_bookmarks = [{ 'v': '~/.vimrc' }, { 'z': '~/.zshrc' }]
let g:startify_session_persistence = 1
let g:startify_change_to_vcs_root = 1

" === AIRLINE ===
let g:airline_theme = 'tokyonight'
let g:airline_powerline_fonts = 1
let g:airline#extensions#tabline#enabled = 1
let g:airline#extensions#ale#enabled = 1

" === NERDTREE ===
let g:NERDTreeShowHidden = 1
let g:NERDTreeMinimalUI = 1
autocmd BufEnter * if winnr('$') == 1 && exists('b:NERDTree') && b:NERDTree.isTabTree() | quit | endif

" === GITGUTTER ===
let g:gitgutter_sign_added = '┃'
let g:gitgutter_sign_modified = '┃'
let g:gitgutter_sign_removed = '✘'

" === c_formatter_42 ===
let g:c_formatter_42_format_on_save = 0
