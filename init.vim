"     _   __         _    ___         
"    / | / /__  ____| |  / (_)___ ___ 
"   /  |/ / _ \/ __ \ | / / / __ `__ \
"  / /|  /  __/ /_/ / |/ / / / / / / /
" /_/ |_/\___/\____/|___/_/_/ /_/ /_/ 
                                    
"TESTING---------
"minimalist
"set both to 2 to show 
"set laststatus=0
"set showtabline =0
"temp btw
nnoremap <leader>tv :FloatermNew mvim<CR>
"this gives live feedback while searching with /
set incsearch


"btw the 3d fonts:
"slant, ANSI Shadow, straight

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
set hidden                    " Required to keep multiple buffers open
set printfont=Hack\ Nerd\ Font\ Mono:h8 "font used in pdf

"""auto commands
"set cursorline
"sets cursorline and cursor column only on the current window
augroup Cursor
    autocmd!
    autocmd VimEnter,WinEnter,BufWinEnter * setlocal cursorline
    autocmd VimEnter,WinEnter,BufWinEnter * setlocal cursorcolumn
    autocmd WinLeave * setlocal nocursorline
    autocmd WinLeave * setlocal nocursorcolumn
augroup END

augroup EnteringFiles
    autocmd!
    "enables spellcheck on .txt and extensionless files
    autocmd BufEnter *.txt setlocal spell spelllang=en_us
    "turns off line wrapping
    autocmd BufEnter :se nowrap
augroup END

augroup terminal
    autocmd!
    "automatically changes the mode to insert mode for new term windows
    autocmd TermOpen * startinsert
    "changes the mode to insert mode when switching to a term buffer
    autocmd BufEnter * if &buftype == "terminal" | :startinsert | endif
    "removes line numbers for the terminal when a terminal is opened
    autocmd TermOpen * setlocal norelativenumber & nonumber 
    "& laststatus=0
    "autocloses the terminal without need of pressing enter
    "autocmd TermClose * call feedkeys("i")
augroup END

augroup Templates
    autocmd!
    "adds bash shebang to .sh files
    autocmd bufnewfile *.sh 0r ~/.config/nvim/templates/skeleton.sh
augroup END

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

"""for python
set tabstop=4
set softtabstop=4
set shiftwidth=4
set expandtab
set autoindent
set fileformat=unix

"for firenvim
set guifont=Hack\ Nerd\ Font\ Mono:h15


"----custom key-bindings----
"maps jk to <Esc> in insert mode 
inoremap jk <Esc>
"maps leader o to the non insertmode versions of o
nnoremap <leader>o o<Esc>k

"Press F9 in normal mode to run python script into separate floaterm window 
"nnoremap <F9> :w<CR>:FloatermNew python3 %<CR>
nnoremap <F9> :w<CR> :tab sp<CR> :term python3 %<CR>

" example for term related remap nnoremap <leader>q :tab sp<CR> :term lazygit %<CR>

"lazygit
nnoremap <leader>g :FloatermNew lazygit <CR>
"ncmpcpp
nnoremap <leader>m :FloatermNew ncmpcpp<CR>

"fzf vim plugin
"nnoremap <leader>f :FZF<CR>
nnoremap <leader>f :Files<CR>

"Pressing F9 in insert mode will run the python script in the current buffer
inoremap <F9> <C-O>:w<CR> <C-O>:tab sp<CR> <C-O>:term python3 %<CR>
"makes a hotkey that copies everything (F1) in insert mode
inoremap <S-F1> <C-O>:%y<CR>
"Pressing F12 will save and do :source load-vim-script % 
nnoremap <F12> :w<CR>:source %<CR>
"Pressing esc whilst in terminal mode will get back to normal mode
tnoremap <Esc> <C-\><C-n>
"Pressing <leader> and n will clear highlighting
nnoremap <leader>n :nohlsearch<CR>

"""splits
"navigate splits with leader w 
nnoremap <leader>w <C-w>w

"changes the current buffer location
nnoremap <leader>k <C-w>K

"arrow keys for resizing splits in their corresponding directions
nnoremap <S-Up> <C-w>-
nnoremap <S-Down> <C-w>+
nnoremap <S-Left> <C-w><
nnoremap <S-Right> <C-w>>

"""buffers   (moved to bufferline) 
"pressing <leader> and 1 will switch to previous buffer
"nnoremap <leader>1 :bp<CR>
"pressing <leader> and 2 will switch to the next buffer
"nnoremap <leader>2 :bn<CR>

"pressing <leader> and 0 will delete the current buffer
nnoremap <leader>0 :bdelete<CR>
"leader and minus will force close the current buffer (no <CR> for safety)
nnoremap <leader>- :bdelete!
"pressing <leader> and l will show all buffers
nnoremap <leader>l :ls<CR>

"""Misc bindings
"pressing <leader> and s will open up autocorrect for the word under the cursor
nnoremap <leader>s <esc>z=
"pressing alt space will open this file in nvim 
"and switch the working directory for this file to .config/nvim
nnoremap <Tab><Space> :new $MYVIMRC<CR> :lcd %:p:h<CR>
"Toggle bindings (double leader)
"pressing leader and leader will toggle the status bar
"the echo clears out the lingering vanilla statusline when switching
nnoremap <silent> <leader><leader>s :call ToggleStatusBar()<CR> :echo<CR>
"pressing leader twice will toggle the tab bar
nnoremap <silent> <leader><leader>t :call ToggleTabBar()<CR>
"pressing leader twice will toggle the line numbers
nnoremap <silent> <leader><leader>n :call ToggleRelativeNumber()<CR>
"pressing leader twice will toggle the cursor column
nnoremap <silent> <leader><leader>cc :call ToggleCursorColumn()<CR>
"pressing leader twice will toggle the cursor line
nnoremap <silent> <leader><leader>cl :call ToggleCursorline()<CR>
"pressing leader twice and d will toggle between a light and dark colorscheme
nnoremap <silent> <leader><leader>C :call ToggleColorscheme()<CR>


"""Commands
"doing :HardcopyPdf will convert the current file to a pdf
command! -range=% HardcopyPdf <line1>,<line2> hardcopy > %.ps | !ps2pdf %.ps && rm %.ps && echo 'Created: %.pdf'

"""functions
function! ToggleStatusBar()
    if &laststatus
        setlocal laststatus=0
    else
        setlocal laststatus=2
    endif
endfunction

function! ToggleTabBar()
    if &showtabline
        setlocal showtabline=0
    else
        setlocal showtabline=2
    endif
endfunction

"toggles the numbers on the left not working
function! ToggleRelativeNumber()
    if &relativenumber
        setlocal norelativenumber & nonumber
    else
        setlocal number relativenumber
    endif
endfunction

"toggles the cursor column
function! ToggleCursorColumn()
    if &cursorcolumn
        setlocal nocursorcolumn
    else
        setlocal cursorcolumn
    endif
endfunction

function! ToggleCursorline()
    if &cursorline
        setlocal nocursorline
    else
        setlocal cursorline
    endif
endfunction

"relies on rakr/vim-one for detecting and changing to light colorscheme
function! ToggleColorscheme()
    if g:colors_name == "one"
        colorscheme onedark
        set background=dark
    else
        colorscheme one
        set background=light
    endif
endfunction

"""##########################
""" plugins go here---------------
call plug#begin('~/.vim/plugged')

"which key (never forget keybindings with this)
Plug 'folke/which-key.nvim'
"Plug 'liuchengxu/vim-which-key'
"Language Server Protocol or lsp for short
Plug 'neovim/nvim-lspconfig'
"autocomplete (using with lsp)
"Plug 'nvim-lua/completion-nvim'
"
"autocomplete (goes with lsp)
"Plug 'hrsh7th/nvim-compe'
"""colorizes hex codes (hex codes will be in their respective color)
Plug 'norcalli/nvim-colorizer.lua'
"" double grouping symbols
"Plug 'jiangmiao/auto-pairs' 
"File tree
Plug 'ms-jpq/chadtree', {'on':'CHADopen', 'branch': 'chad', 'do': 'python3 -m chadtree deps'}
"""Lualine statusline 
Plug 'hoob3rt/lualine.nvim'
"for icons in the lualine statusline
Plug 'kyazdani42/nvim-web-devicons'
"Floaterm
Plug 'voldikss/vim-floaterm'
"""neovim in chrome and some other browsers
Plug 'glacambre/firenvim', { 'do': { _ -> firenvim#install(0) } }
"""colorscheme
Plug 'morhetz/gruvbox'               "gruvbox

Plug 'joshdick/onedark.vim'          "onedark
Plug 'rakr/vim-one'                  "onedark with light theme
"Plug 'monsonjeremy/onedark.nvim'    "onedark with lua
"""treesitter
Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}
"""fzf
Plug 'junegunn/fzf', {'do': {-> fzf#install()} }
Plug 'junegunn/fzf.vim'
"""bufferline
Plug 'akinsho/nvim-bufferline.lua'
"battery component for statuslines or whatever
Plug 'lambdalisue/battery.vim'

"""Git
":DiffviewOpen
Plug 'sindrets/diffview.nvim'
"git signs in gutter 
Plug 'airblade/vim-gitgutter'

call plug#end()
"""##########################

"italics with onedark theme (looks like it just affects comments)
let g:onedark_terminal_italics = 1
"removes the ~ at the end of buffers with the onedark colorscheme 
let g:onedark_hide_endofbuffer = 1

"italics when using light colorscheme "one" not "onedark"
let g:one_allow_italics = 1

"custom colorscheme
"colorscheme onedark
colorscheme gruvbox

"lua << EOF
"
"--https://github.com/RRethy/nvim-base16
"--colorschemes are also listed in 
"local colorscheme = require('base16-colorscheme')
"-- provide the name of a builtin colorscheme
"colorscheme.setup('one-light')
"
"
"EOF

"better battery icons
"function! Battery_icon() 
"  let l:battery_icon = {
"    \ 5: " ",
"    \ 4: " ",
"    \ 3: " ",
"    \ 2: " ",
"    \ 1: " "}
"    
"  let l:backend = battery#backend()
"  let l:nf = float2nr(round(backend.value / 20.0))
"  return printf('%s', get(battery_icon, nf))
"endfunction

" ██████╗ ██╗████████╗
"██╔════╝ ██║╚══██╔══╝
"██║  ███╗██║   ██║   
"██║   ██║██║   ██║   
"╚██████╔╝██║   ██║   
" ╚═════╝ ╚═╝   ╚═╝   
"git
"###GitGutter
highlight GitGutterChange guifg=#61afef ctermfg=3

nmap ]a <Plug>(GitGutterNextHunk)
nmap [a <Plug>(GitGutterPrevHunk)

let g:gitgutter_grep = "rg"

"███████╗███████╗███████╗
"██╔════╝╚══███╔╝██╔════╝
"█████╗    ███╔╝ █████╗  
"██╔══╝   ███╔╝  ██╔══╝  
"██║     ███████╗██║     
"╚═╝     ╚══════╝╚═╝     
" Customize fzf colors to match your color scheme
let g:fzf_colors =
\ { 'fg':      ['fg', 'Normal'],
  \ 'bg':      ['bg', 'Normal'],
  \ 'hl':      ['fg', 'Comment'],
  \ 'fg+':     ['fg', 'CursorLine', 'CursorColumn', 'Normal'],
  \ 'bg+':     ['bg', 'CursorLine', 'CursorColumn'],
  \ 'hl+':     ['fg', 'Statement'],
  \ 'info':    ['fg', 'Proc'],
  \ 'border':  ['fg', 'Ignore'],
  \ 'prompt':  ['fg', 'Conditional'],
  \ 'pointer': ['fg', 'Exception'],
  \ 'marker':  ['fg', 'Keyword'],
  \ 'spinner': ['fg', 'Label'],
  \ 'header':  ['fg', 'Comment'] }

"Get Files
command! -bang -nargs=? -complete=dir Files
    \ call fzf#vim#files(<q-args>, fzf#vim#with_preview({'options': ['--layout=reverse', '--info=inline']}), <bang>0)


" Get text in files with Rg
command! -bang -nargs=* Rg
  \ call fzf#vim#grep(
  \   'rg --column --line-number --no-heading --color=always --smart-case '.shellescape(<q-args>), 1,
  \   fzf#vim#with_preview(), <bang>0)

" Ripgrep advanced
function! RipgrepFzf(query, fullscreen)
  let command_fmt = 'rg --column --line-number --no-heading --color=always --smart-case %s || true'
  let initial_command = printf(command_fmt, shellescape(a:query))
  let reload_command = printf(command_fmt, '{q}')
  let spec = {'options': ['--phony', '--query', a:query, '--bind', 'change:reload:'.reload_command]}
  call fzf#vim#grep(initial_command, 1, fzf#vim#with_preview(spec), a:fullscreen)
endfunction

command! -nargs=* -bang RG call RipgrepFzf(<q-args>, <bang>0)

" Git grep
command! -bang -nargs=* GGrep
  \ call fzf#vim#grep(
  \   'git grep --line-number '.shellescape(<q-args>), 0,
  \   fzf#vim#with_preview({'dir': systemlist('git rev-parse --show-toplevel')[0]}), <bang>0)



"████████╗██████╗ ███████╗███████╗███████╗██╗████████╗████████╗███████╗██████╗ 
"╚══██╔══╝██╔══██╗██╔════╝██╔════╝██╔════╝██║╚══██╔══╝╚══██╔══╝██╔════╝██╔══██╗
"   ██║   ██████╔╝█████╗  █████╗  ███████╗██║   ██║      ██║   █████╗  ██████╔╝
"   ██║   ██╔══██╗██╔══╝  ██╔══╝  ╚════██║██║   ██║      ██║   ██╔══╝  ██╔══██╗
"   ██║   ██║  ██║███████╗███████╗███████║██║   ██║      ██║   ███████╗██║  ██║
"   ╚═╝   ╚═╝  ╚═╝╚══════╝╚══════╝╚══════╝╚═╝   ╚═╝      ╚═╝   ╚══════╝╚═╝  ╚═╝
"                                                                              

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
"linefolding
"set foldmethod=expr
"set foldexpr=nvim_treesitter#foldexpr()







"██╗     ███████╗██████╗ 
"██║     ██╔════╝██╔══██╗
"██║     ███████╗██████╔╝
"██║     ╚════██║██╔═══╝ 
"███████╗███████║██║     
"╚══════╝╚══════╝╚═╝     

"#format is:
"lua require'lspconfig'.<server>.setup{<config>}
"#example: 
"lua require'lspconfig'.pyright.setup{}

"with completion-nvim plugin---------------------
"autocompletion for python with pyright
lua require'lspconfig'.pyright.setup{on_attach=require'completion'.on_attach, settings={python={analysis={typeChekcingMode="off"}}}}
"autocomplete for bash (files)
lua require'lspconfig'.bashls.setup{on_attach=require'completion'.on_attach}
"autocomplete for .vim
lua require'lspconfig'.vimls.setup{on_attach=require'completion'.on_attach}
"autocomplete for c++
lua require'lspconfig'.clangd.setup{on_attach=require'completion'.on_attach}
" Use <Tab> and <S-Tab> to navigate through popup menu
"inoremap <expr> <Tab>   pumvisible() ? "\<C-n>" : "\<Tab>"
"inoremap <expr> <S-Tab> pumvisible() ? "\<C-p>" : "\<S-Tab>"


"╔═══════════════════════════════╗
" _ _  _  _ | _|_. _  _ |\ |  . _  
"(_(_)||||_)|(-|_|(_)| )| \|\/|||| 
"        |                         
"╚═══════════════════════════════╝     
"
imap <tab> <Plug>(completion_smart_tab)
imap <s-tab> <Plug>(completion_smart_s_tab)

" Set completeopt to have a better completion experience
set completeopt=menuone,noinsert,noselect
set completeopt-=preview
" Avoid showing message extra message when using completion
set shortmess+=c


"
"##########COLORIZER##########
"
"colorizer for displaying color as a highlight 
"example:  #0000ff 
lua require 'colorizer'.setup()



"██╗     ██╗   ██╗ █████╗ ██╗     ██╗███╗   ██╗███████╗
"██║     ██║   ██║██╔══██╗██║     ██║████╗  ██║██╔════╝
"██║     ██║   ██║███████║██║     ██║██╔██╗ ██║█████╗  
"██║     ██║   ██║██╔══██║██║     ██║██║╚██╗██║██╔══╝  
"███████╗╚██████╔╝██║  ██║███████╗██║██║ ╚████║███████╗
"╚══════╝ ╚═════╝ ╚═╝  ╚═╝╚══════╝╚═╝╚═╝  ╚═══╝╚══════╝
"lualine----------
"
"This outputs the current time in a good way idk how to implement tho
"strftime("%I:%M %p")
"ver with month and day down below
"strftime("%m/%d, %I:%M %p")
"+-------------------------------------------------+
"| A | B | C                             X | Y | Z |
"+-------------------------------------------------+
"for battery component of the statusline
let g:battery#component_format = " %v"

lua << EOF

--color table
local colors = {

        
    purple   = '#c07be5',
    grey     = '#5c6370',
    yellow   = '#e5c07b',
    cyan     = '#008080',
    blue1    = '#6666ff',
    green    = '#98be65',
    orange   = '#FF8800',
    violet   = '#a9a1e1',
    magenta  = '#c678dd',
    blue     = '#61afef';
    red      = '#e06c75';

}

--lualine
--+-------------------------------------------------+
--| A | B | C                             X | Y | Z |
--+-------------------------------------------------+
require('lualine').setup{

options = {
    theme = 'gruvbox',
    section_separators = {'', ''},
    component_separators = {'|', '|'},
    disabled_filetypes = {},
    icons_enabled = true,
},
sections = {
    lualine_a = { 
    {'mode', upper = true},
    {'battery#component', 
    --color = {bg = '#00000', fg = colors.green}
    }


    },
    lualine_b = { 
        {'diff', colored = true,
        color_added = colors.green,
        color_modified = colors.blue,
        color_removed = colors.red,

        },

        {'branch', icon = '', color = {fg = colors.violet}},

        },  --end of segment b

    lualine_c = { 
        {'diagnostics', 
        sources = {'nvim_lsp'},
        color_error = colors.red,
        color_warn = colors.yellow,
        color_info = colors.blue1,
        color_hint = colors.purple,
        },
        {'filename', file_status = true} ,
        }, --end of segment c

    lualine_x = { 'encoding', 'filetype' },

    lualine_y = { 
    {'os.date("%a %m/%d")',
        color = {
            bg = colors.yellow,
            --fg ='#484848' 
            fg = '#000000'
            },
        icon = ''
    
    },

    {'os.date("%I:%M %p")', 
        color = {
            bg = colors.yellow,
            fg = '#000000'
            },
        icon = '| '
            } --end of second os.date

            }, --end of lualine_y 
            
    lualine_z = {{'progress'} , {'location', icon = ''}},
    
},
extensions = { 'fzf','chadtree' }
}

EOF

"████████╗ █████╗ ██████╗ ██╗     ██╗███╗   ██╗███████╗
"╚══██╔══╝██╔══██╗██╔══██╗██║     ██║████╗  ██║██╔════╝
"   ██║   ███████║██████╔╝██║     ██║██╔██╗ ██║█████╗  
"   ██║   ██╔══██║██╔══██╗██║     ██║██║╚██╗██║██╔══╝  
"   ██║   ██║  ██║██████╔╝███████╗██║██║ ╚████║███████╗
"   ╚═╝   ╚═╝  ╚═╝╚═════╝ ╚══════╝╚═╝╚═╝  ╚═══╝╚══════╝
"nvim lua bufferline 
" These commands will navigate through buffers in order regardless of which mode you are using
" e.g. if you change the order of buffers :bnext and :bprevious will not respect the custom ordering
" leader [ next    leader ] prev
nnoremap <silent><leader>[ :BufferLineCycleNext<CR>
nnoremap <silent><leader>] :BufferLineCyclePrev<CR>

" These commands will move the current buffer backwards or forwards in the bufferline
nnoremap <silent><mymap> :BufferLineMoveNext<CR>
nnoremap <silent><mymap> :BufferLineMovePrev<CR>

" These commands will sort buffers by directory, language, or a custom criteria
nnoremap <silent><leader>be :BufferLineSortByExtension<CR>
nnoremap <silent><leader>bd :BufferLineSortByDirectory<CR>
nnoremap <silent><mymap> :lua require'bufferline'.sort_buffers_by(function (buf_a, buf_b) return buf_a.id < buf_b.id end)<CR>

lua << EOF
require"bufferline".setup{
        options = {
            view = "default",
            numbers = "ordinal",
            number_style = "subscript", -- buffer_id at index 1, ordinal at index 2
            mappings = true,  --leader 1 through 9 can be used to navigate tabs
            buffer_close_icon= "",
            modified_icon = "●",
            close_icon = "",
            left_trunc_marker = "",
            right_trunc_marker = "",
            max_name_length = 18,
            max_prefix_length = 15, -- prefix used when a buffer is deduplicated
            tab_size = 18,
            diagnostics = "nvim-lsp",
            --diagnostics_indicator = function(count, level)
            --return "("..count..")"
            --end

            --these are used to differentiate between buffers and tabs 
            show_buffer_close_icons = false,
            show_close_icon = false,
            show_tab_indicators = true,

            persist_buffer_sort = true, -- whether or not custom sorted buffers should persist
            -- can also be a table containing 2 custom separators
            -- [focused and unfocused]. eg: { "|", "|" }
            separator_style = "thin",
            enforce_regular_tabs = false,
            always_show_bufferline = false,
            --sort_by =  "relative_directory"
        }
    }
EOF

" ██████╗██╗  ██╗ █████╗ ██████╗ ████████╗██████╗ ███████╗███████╗
"██╔════╝██║  ██║██╔══██╗██╔══██╗╚══██╔══╝██╔══██╗██╔════╝██╔════╝
"██║     ███████║███████║██║  ██║   ██║   ██████╔╝█████╗  █████╗  
"██║     ██╔══██║██╔══██║██║  ██║   ██║   ██╔══██╗██╔══╝  ██╔══╝  
"╚██████╗██║  ██║██║  ██║██████╔╝   ██║   ██║  ██║███████╗███████╗
" ╚═════╝╚═╝  ╚═╝╚═╝  ╚═╝╚═════╝    ╚═╝   ╚═╝  ╚═╝╚══════╝╚══════╝
"chadtree                                                                 

nnoremap <F1> <CMD>CHADopen<CR>


"███████╗██╗      ██████╗  █████╗ ████████╗███████╗██████╗ ███╗   ███╗
"██╔════╝██║     ██╔═══██╗██╔══██╗╚══██╔══╝██╔════╝██╔══██╗████╗ ████║
"█████╗  ██║     ██║   ██║███████║   ██║   █████╗  ██████╔╝██╔████╔██║
"██╔══╝  ██║     ██║   ██║██╔══██║   ██║   ██╔══╝  ██╔══██╗██║╚██╔╝██║
"██║     ███████╗╚██████╔╝██║  ██║   ██║   ███████╗██║  ██║██║ ╚═╝ ██║
"╚═╝     ╚══════╝ ╚═════╝ ╚═╝  ╚═╝   ╚═╝   ╚══════╝╚═╝  ╚═╝╚═╝     ╚═╝
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


"██╗    ██╗██╗  ██╗██╗ ██████╗██╗  ██╗██╗  ██╗███████╗██╗   ██╗
"██║    ██║██║  ██║██║██╔════╝██║  ██║██║ ██╔╝██╔════╝╚██╗ ██╔╝
"██║ █╗ ██║███████║██║██║     ███████║█████╔╝ █████╗   ╚████╔╝ 
"██║███╗██║██╔══██║██║██║     ██╔══██║██╔═██╗ ██╔══╝    ╚██╔╝  
"╚███╔███╔╝██║  ██║██║╚██████╗██║  ██║██║  ██╗███████╗   ██║   
" ╚══╝╚══╝ ╚═╝  ╚═╝╚═╝ ╚═════╝╚═╝  ╚═╝╚═╝  ╚═╝╚══════╝   ╚═╝   
"whichkey (lua)--------
"

lua << EOF

local wk = require("which-key")

--this is the <leader>t ... group
wk.register({
  t = {
    name = "floaterm", -- optional group name
    p = { ":FloatermNew python3<CR>"                           ,"python3" }, 
    y = { ":FloatermNew ytop<CR>"                              ,"ytop" }, 
    i = { ":FloatermNew speedtest-cli<CR>"                     ,"Internet test" }, 
    t = { ":FloatermNew <CR>"                                  ,"Toggle" }, 
    n = { ":FloatermNew ncdu<CR>"                              ,"View space taken" }, 
  },
}, { prefix = "<leader>" })

