"     _   __         _    ___         
"    / | / /__  ____| |  / (_)___ ___ 
"   /  |/ / _ \/ __ \ | / / / __ `__ \
"  / /|  /  __/ /_/ / |/ / / / / / / /
" /_/ |_/\___/\____/|___/_/_/ /_/ /_/ 
                                    
"TESTING--------
"minimalst
"set both to 2 to show 
"set laststatus=0
"set showtabline =0

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
inoremap <F1> <C-O>:%y<CR>
"Pressing F12 will save and do :source load-vim-script % 
nnoremap <F12> :w<CR>:source %<CR>
"Pressing esc whilst in terminal mode will get back to normal mode
tnoremap <Esc> <C-\><C-n>
"Pressing <leader> and h will clear highlighting
nnoremap <leader>h :noh<CR>

"""buffers   (moved to bufferline) 
"pressing <leader> and 1 will switch to previous buffer
"nnoremap <leader>1 :bp<CR>
"pressing <leader> and 2 will switch to the next buffer
"nnoremap <leader>2 :bn<CR>

"pressing <leader> and 0 will delete the current buffer
nnoremap <leader>0 :bd<CR>
"leader and minus will force close the current buffer
nnoremap <leader>- :bd!
"pressing <leader> and l will show all buffers
nnoremap <leader>l :ls<CR>

"""Misc bindings
"pressing <leader> and s will open up autocorrect for the word under the cursor
nnoremap <leader>s <esc>z=
"pressing leader and leader will toggle the status bar
nnoremap <silent> <leader><leader>s :call ToggleStatusBar()<CR>
"pressing leader twice will toggle the tab bar
nnoremap <silent> <leader><leader>t :call ToggleTabBar()<CR>
"pressing leader twice will toggle the line numbers
nnoremap <silent> <leader><leader>n :call ToggleRelativeNumber()<CR>

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
set guifont=Hack\ Nerd\ Font\ Mono:h15

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
"""fzf
Plug 'junegunn/fzf', {'do': {-> fzf#install()} }
Plug 'junegunn/fzf.vim'
"""bufferline
Plug 'akinsho/nvim-bufferline.lua'
"battery component for statuslines or whatever
Plug 'lambdalisue/battery.vim'

call plug#end()

"custom colorschemes
colorscheme onedark 

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

        
    purple  = '#c07be5',
    grey   = '#5c6370',
    yellow   = '#e5c07b',
    cyan     = '#008080',
    darkblue = '#081633',
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
    theme = 'onedark',
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
        {'branch', icon = '', color = {fg = colors.violet}},
        },

    lualine_c = { 
        {'diagnostics', 
        sources = {'nvim_lsp'},
        color_error = colors.red,
        color_warn = colors.yellow,
        color_info = colors.cyan,
        },
        {'filename', file_status = true} ,
    },

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

            }

            },
            
    lualine_z = {{'progress'} , {'location', icon = ''}},
    
},
extensions = { 'fzf', 'nerdtree' }
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

"███╗   ██╗███████╗██████╗ ██████╗ ████████╗██████╗ ███████╗███████╗
"████╗  ██║██╔════╝██╔══██╗██╔══██╗╚══██╔══╝██╔══██╗██╔════╝██╔════╝
"██╔██╗ ██║█████╗  ██████╔╝██║  ██║   ██║   ██████╔╝█████╗  █████╗  
"██║╚██╗██║██╔══╝  ██╔══██╗██║  ██║   ██║   ██╔══██╗██╔══╝  ██╔══╝  
"██║ ╚████║███████╗██║  ██║██████╔╝   ██║   ██║  ██║███████╗███████╗
"╚═╝  ╚═══╝╚══════╝╚═╝  ╚═╝╚═════╝    ╚═╝   ╚═╝  ╚═╝╚══════╝╚══════╝
"nerdtree---------
"NERDTree closes when a file is open
let NERDTreeQuitOnOpen=1
"minimal UI
let g:NERDTreeMinimalUI=1
"NERDTree opens and closes with F2
nnoremap <F1> :NERDTreeToggle<CR>


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
"whichkey--------
"
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
