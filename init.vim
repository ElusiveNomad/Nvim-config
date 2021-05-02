"     _   __         _    ___         
"    / | / /__  ____| |  / (_)___ ___ 
"   /  |/ / _ \/ __ \ | / / / __ `__ \
"  / /|  /  __/ /_/ / |/ / / / / / / /
" /_/ |_/\___/\____/|___/_/_/ /_/ /_/ 
                                    
"TESTING--------
"minimalst
"set laststatus=2

"general settings----------
"sets mapleader to <spacebar>
let mapleader = ' '
set number relativenumber
set encoding=utf-8
set fileencoding=utf-8
syntax enable
set noswapfile
set scrolloff=5
set backspace=indent,eol,start
set cursorline
set hidden                    " Required to keep multiple buffers open

"sets termguicolors (24bit in iTerm) if available
if (has("termguicolors"))
    set termguicolors
endif
"""shows matching grouping symbols
set showmatch
"""copies to system clipboard
set clipboard=unnamed

"enables python highlighting features
let python_highlight_all = 1

"enables spellcheck on .txt and extensionless files
autocmd BufEnter *.txt setlocal spell spelllang=en_us

"turns off line wrapping
autocmd BufEnter :se nowrap

"automatically changes the mode to insert mode for new term windows
autocmd TermOpen * startinsert

"----custom key-bindings----
"maps jk to <Esc> in insert mode 
inoremap jk <Esc>
"makes a hotkey that runs python (Ctrl \)
"Press F9 in normal mode to run python script into separate floaterm window 
"nnoremap <F9> :w<CR>:FloatermNew python3 %<CR>
nnoremap <F9> :w<CR> :tab sp<CR> :term python3 %<CR>

" example for term related remap nnoremap <leader>q :tab sp<CR> :term lazygit %<CR>

"lazygit
nnoremap <leader>g :FloatermNew lazygit <CR>
"ncmpcpp
nnoremap <leader>m :FloatermNew ncmpcpp<CR>

"Pressing F9 in insert mode will run the python script in the current buffer
inoremap <F9> <C-O>:w<CR> <C-O>:tab sp<CR> <C-O>:term python3 %<CR>
"makes a hotkey that copies everything (Ctrl \) in insert mode
inoremap <C-\> <C-O>:%y<CR>
"Pressing F12 will save and do :source load-vim-script % 
nnoremap <F12> :w<CR>:source %<CR>
"Pressing esc whilst in terminal mode will get back to normal mode
tnoremap <Esc> <C-\><C-n>
"Pressing <leader> and h will clear highlighting
nnoremap <leader>h :noh<CR>

"""buffers
"pressing <leader> and 1 will switch to previous buffer
nnoremap <leader>1 :bp<CR>
"pressing <leader> and 2 will switch to the next buffer
nnoremap <leader>2 :bn<CR>
"pressing <leader> and 0 will delete the current buffer

nnoremap <leader>0 :bd<CR>
"pressing <leader> and l will show all buffers
nnoremap <leader>l :ls<CR>

"""Misc
"pressing <leader> and s will open up autocorrect for the word under the cursor
nnoremap <leader>s <esc>z=

"""for python
set tabstop=4
set softtabstop=4
set shiftwidth=4
set expandtab
set autoindent
set fileformat=unix
"enables python highlighting features
let python_highlight_all = 1

"for firenvim
set guifont=Hack\ Nerd\ Font

"""##########################
""" plugins go here---------------
call plug#begin('~/.vim/plugged')

"which key (never forget keybindings with this)
Plug 'liuchengxu/vim-which-key'
"Language Server Protocol or lsp for short
Plug 'neovim/nvim-lspconfig'
"autocomplete (using with lsp)
Plug 'nvim-lua/completion-nvim'
"autocomplete (goes with lsp)
"Plug 'hrsh7th/nvim-compe'
"""colorizes hex codes (hex codes will be in their respective color)
Plug 'norcalli/nvim-colorizer.lua'
"" double grouping symbols
"Plug 'jiangmiao/auto-pairs' 
"""nerdtree 
Plug 'preservim/nerdtree'
"""Lualine statusline 
Plug 'hoob3rt/lualine.nvim'
"for icons in the lualine statusline
Plug 'kyazdani42/nvim-web-devicons'
"Floaterm
Plug 'voldikss/vim-floaterm'
"""neovim in chrome and some other browsers
Plug 'glacambre/firenvim', { 'do': { _ -> firenvim#install(0) } }
"""colorscheme
Plug 'joshdick/onedark.vim'          "onedark
Plug 'sonph/onehalf', {'rtp': 'vim'} "onelight 
"Plug 'christianchiarulli/nvcode-color-schemes.vim' "treesitter support
"""treesitter
Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}

call plug#end()


"""Treesitter
"lua require'nvim-treesitter.configs'.setup {highlight = {enable = true}}
lua << EOF
require('nvim-treesitter.configs').setup({
    highlight = {
        enable = true
        },
    incremental_selection = {
        enable = true,
        keymaps= {
            init_selection = "gnn",
        },
    },
    indent = {
        enable = true
    },

})
EOF

set foldmethod=expr
set foldexpr=nvim_treesitter#foldexpr()

"echo nvim_treesitter#statusline(90)
"""##########################

"for lua∏∏∏∏∏∏∏∏∏∏∏∏∏∏∏∏∏∏∏∏∏∏∏∏∏∏∏∏∏∏∏∏∏∏∏∏∏∏∏∏∏∏∏

"#format is:
"require'lspconfig'.<server>.setup{<config>}
"#example: 
"lua << EOF
"require'lspconfig'.pyright.setup{}
"require'lspconfig'.bashls.setup{}
"EOF

"completion-nvim plugin---------------------
"autocompletion for python with pyright
lua require'lspconfig'.pyright.setup{on_attach=require'completion'.on_attach}
"autocomplete for bash (files)
lua require'lspconfig'.bashls.setup{on_attach=require'completion'.on_attach}
"autocomplete for .vim
lua require'lspconfig'.vimls.setup{on_attach=require'completion'.on_attach}
"autocomplete for c++
lua require'lspconfig'.clangd.setup{on_attach=require'completion'.on_attach}
" Use <Tab> and <S-Tab> to navigate through popup menu
"inoremap <expr> <Tab>   pumvisible() ? "\<C-n>" : "\<Tab>"
"inoremap <expr> <S-Tab> pumvisible() ? "\<C-p>" : "\<S-Tab>"
imap <tab> <Plug>(completion_smart_tab)
imap <s-tab> <Plug>(completion_smart_s_tab)

" Set completeopt to have a better completion experience
set completeopt=menuone,noinsert,noselect
set completeopt-=preview
" Avoid showing message extra message when using completion
set shortmess+=c

""" getting settings from other files
"""≈≈≈≈≈≈≈≈≈≈≈≈≈≈≈≈≈≈≈≈≈≈≈≈≈≈≈≈≈≈≈≈≈≈
"source ~/.config/nvim/plug-config/lsp-config.vim
"luafile ~/.config/nvim/lua/plugins/compe-config.lua
"""≈≈≈≈≈≈≈≈≈≈≈≈≈≈≈≈≈≈≈≈≈≈≈≈≈≈≈≈≈≈≈≈≈≈
"end of lua stuff∏∏∏∏∏∏∏∏∏∏∏∏∏∏∏∏∏∏∏∏∏∏∏∏∏∏∏∏∏∏∏∏∏∏


"colorizer for displaying color as a highlight 
"example:  #0000ff 
lua require 'colorizer'.setup()

"custom colorschemes
colorscheme onedark 

"lualine----------
"uncomment for lualine

"lua << EOF
"require('lualine').setup{
"    
"    options = {theme = 'onedark'}
"
"}
"EOF
"
let g:lualine = {
    \'options' : {
    \  'theme' : 'onedark',
    \  'section_separators' : ['', ''],
    \  'component_separators' : ['', ''],
    \  'disabled_filetypes' : [],
    \  'icons_enabled' : v:true,
    \},
    \'sections' : {
    \  'lualine_a' : [ ['mode', {'upper': v:true,},], ],
    \  'lualine_b' : [ ['branch', {'icon': '',}, ], ],
    \  'lualine_c' : [ ['filename', {'file_status': v:true,},], ],
    \  'lualine_x' : [ 'encoding', 'fileformat', 'filetype' ],
    \  'lualine_y' : [ 'progress' ],
    \  'lualine_z' : [ 'location'  ],
    \},
    \'inactive_sections' : {
    \  'lualine_a' : [  ],
    \  'lualine_b' : [  ],
    \  'lualine_c' : [ 'filename' ],
    \  'lualine_x' : [ 'location' ],
    \  'lualine_y' : [  ],
    \  'lualine_z' : [  ],
    \},
    \'extensions' : [ 'fzf' ],
    \}
lua require("lualine").setup()


"
"airline----------
"nord_minimal and raven and silver and desertink and base16_eighties and angr are possible ones
" and violet and base16_snazzy 
"let g:airline_theme='onedark'
"lists open buffers
"let g:airline#extensions#tabline#enabled=1
"only show names of the buffers in tabs
"let g:airline#extensions#tabline#fnamemode=':t'





"nerdtree---------
"NERDTree closes when a file is open
let NERDTreeQuitOnOpen=1
"minimal UI
let g:NERDTreeMinimalUI=1
"NERDTree opens and closes with F2
nnoremap <F1> :NERDTreeToggle<CR>

"floaterm--------
let g:floaterm_keymap_next   = '<F3>'
let g:floaterm_keymap_prev   = '<F4>'

"removes floaterm title
let g:floaterm_title = "" 

hi FloatermBorder guibg=#282c34 guifg=#61afef
"floaterm takes up 90% of the screen
let g:floaterm_width = 0.9
let g:floaterm_height = 0.9
let g:floaterm_wintitle=0
let g:floaterm_autoclose=1

"witchkey--------
nnoremap <silent> <leader> :silent WhichKey '<Space>'<CR>
vnoremap <silent> <leader> :silent <c-u> :silent WhichKeyVisual '<Space>'<CR>
"no floating window
let g:which_key_use_floating_win = 0
" Create map to add keys to
let g:which_key_map =  {}
" Define a separator
let g:which_key_sep = '→'
" Change the colors if you want
highlight default link WhichKey          Operator
highlight default link WhichKeySeperator DiffAdded
highlight default link WhichKeyGroup     Identifier
highlight default link WhichKeyDesc      Function
"" Hide status line
autocmd! FileType which_key
autocmd  FileType which_key set laststatus=0 noshowmode noruler
  \| autocmd BufLeave <buffer> set laststatus=2 noshowmode ruler
"which key config (with floaterm)
let g:which_key_map.t = {
      \ 'name' : '+terminal' ,
      \ 'f' : [':FloatermNew fzf'                               , 'fzf'],
      \ 'p' : [':FloatermNew python3'                            , 'python3'],
      \ 'n' : [':FloatermNew node'                              , 'node'],
      \ 't' : [':FloatermToggle'                                , 'toggle'],
      \ 'y' : [':FloatermNew ytop'                              , 'ytop'],
      \ 's' : [':FloatermNew ncdu'                              , 'ncdu'],
      \ 'i' : [':FloatermNew speedtest-cli'                     , 'Internet test'],
      \ }
" Register which key map
call which_key#register('<Space>', "g:which_key_map")
