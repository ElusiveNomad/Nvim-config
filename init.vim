"     _   __         _    ___         
"    / | / /__  ____| |  / (_)___ ___ 
"   /  |/ / _ \/ __ \ | / / / __ `__ \
"  / /|  /  __/ /_/ / |/ / / / / / / /
" /_/ |_/\___/\____/|___/_/_/ /_/ /_/ 


"3d fonts from
"https://patorjk.com/software/taag/#p=testall&f=Isometric1&t=test
"fonts used: slant, ANSI Shadow, straight

"general settings----------
"sets mapleader to <spacebar>
let mapleader = ' '
set number relativenumber
set noswapfile
set scrolloff=5
set backspace=indent,eol,start
set hidden                    "buffers do not auto save when switching between buffers 

set tabstop=4
set softtabstop=4
set shiftwidth=4
set expandtab
set autoindent
set fileformat=unix

set guifont=Hack\ Nerd\ Font\ Mono:h12
set printfont=Hack\ Nerd\ Font\ Mono:h8 "font used in pdf

"this gives live feedback while searching with /
set incsearch

"shows matching grouping symbols
set showmatch
"copies to system clipboard
set clipboard=unnamed

"sets termguicolors (24bit in iTerm) if available
if (has("termguicolors"))
    set termguicolors
endif

"autocomplete menu options
set completeopt=menuone,noselect

"""auto commands
"sets cursorline and cursor column only on the current window
augroup Cursor
    autocmd!
    autocmd VimEnter,WinEnter,BufWinEnter * setlocal cursorline
    autocmd VimEnter,WinEnter,BufWinEnter * setlocal cursorcolumn
    autocmd WinLeave * setlocal nocursorline
    autocmd WinLeave * setlocal nocursorcolumn
augroup END

augroup EnteringBuffers
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
augroup END

augroup skeleton
    autocmd!
    "adds bash shebang to .sh files
    autocmd bufnewfile *.sh 0r ~/.config/nvim/templates/skeleton.sh
augroup END

augroup YankHighlight
    autocmd!
    autocmd TextYankPost * silent! lua vim.highlight.on_yank()
  augroup end


"----custom key-bindings----
"maps jk to <Esc> in insert mode
inoremap jk <Esc>
"maps leader o to the non insertmode versions of o
nnoremap <leader>o o<Esc>k

"F9 Runs code (look at RunCode fn to see supported fileExtensions )
"nnoremap <silent> <F9> :w<CR> :call RunCode()<CR>
nnoremap <F9> :call RunCode()<CR>

"lazygit
nnoremap <leader>g :FloatermNew lazygit <CR>
"ncmpcpp
nnoremap <leader>m :FloatermNew ncmpcpp<CR>

"fzf vim plugin
nnoremap <leader>f :Files<CR>

"makes a hotkey that copies everything (shift F1) in insert mode
inoremap <F13> <C-O>:%y<CR>
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

"pressing <leader> and 0 will delete the current buffer
nnoremap <leader>0 :bdelete<CR>
"leader and minus will force close the current buffer (no <CR> for safety)
nnoremap <leader>- :bdelete!
"pressing <leader> and l will show all buffers
nnoremap <leader>l :ls<CR>

"""Misc bindings
"pressing <leader> and s will open up spellcheck for the word under the cursor
nnoremap <leader>s <esc>z=
"pressing alt space will open this file in nvim
"and switch the working directory for this file to .config/nvim
nnoremap <Tab><Space> :new $MYVIMRC<CR> :lcd %:p:h<CR>

"""Toggle bindings (double leader)
"pressing leader and leader will toggle the status bar
"the echo clears out the lingering vanilla statusline when switching
nnoremap <silent> <leader><leader>s :call ToggleStatusBar()<CR> :echo<CR>
"pressing leader twice will toggle the tab bar
nnoremap <silent> <leader><leader>t :call ToggleTabBar()<CR>
"pressing leader twice and n will toggle the line numbers
nnoremap <silent> <leader><leader>n :call ToggleRelativeNumber()<CR>
"pressing leader twice and cc will toggle the cursor column
nnoremap <silent> <leader><leader>cc :call ToggleCursorColumn()<CR>
"pressing leader twice and cl will toggle the cursor line
nnoremap <silent> <leader><leader>cl :call ToggleCursorline()<CR>
"pressing leader twice and d will toggle between a light and dark theme
nnoremap <silent> <leader><leader>C :call ToggleTheme()<CR>
"pressing leader twice and r will toggle between showing and not showing return characters
nnoremap <silent> <leader><leader>r :call ToggleShowReturnChar()<CR>

"""Commands
"doing :HardcopyPdf will convert the current file to a pdf
command! -range=% HardcopyPdf <line1>,<line2> hardcopy > %.ps | !ps2pdf %.ps && rm %.ps && echo 'Created: %.pdf'


"""functions

"runs the code in a term buffer depending on filetype
function! RunCode()
    let fileExtension = expand("%:e")
    if fileExtension == "py"
        term python3 %
    elseif fileExtension == "sh"
        term bash %
    else
        echo fileExtension "is probably not executable"
    endif

endfunction

"toggles

function! ToggleShowReturnChar()
    if &list
        setlocal nolist
        echom "defaults"
    else
        setlocal list
        setlocal listchars=eol:↵,trail:❙,tab:\ \ 
        echom "newchange"
    endif
endfunction


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

"toggles between a light and dark theme
function! ToggleTheme()

    if g:colors_name == "one" && &background == "light"
        colorscheme onedark
        set background=dark
        echo "switched to onedark"
    elseif g:colors_name == "onedark"
        colorscheme one
        set background=light
        echo "switched to one-light"

    elseif &background == "light"
        set background=dark
        echo "set to dark bg"
    else
        set background=light
        echo "set to light bg"
    endif
endfunction

"""##########################
""" plugins go here---------------
call plug#begin('~/.vim/plugged')

"which key (never forget keybindings with this)
Plug 'folke/which-key.nvim'

"Language Server Protocol or lsp for short
Plug 'neovim/nvim-lspconfig'

""" "autocomplete"
"Plug 'hrsh7th/nvim-compe'
Plug 'hrsh7th/nvim-cmp'
"snippets
Plug 'L3MON4D3/LuaSnip'
"extra snippets for luasnip
Plug 'rafamadriz/friendly-snippets'
"completion sources for cmp
Plug 'hrsh7th/cmp-nvim-lsp'
Plug 'saadparwaiz1/cmp_luasnip'
Plug 'hrsh7th/cmp-buffer'
Plug 'hrsh7th/cmp-path'
"formatting for cmp sources in completion menu
Plug 'onsails/lspkind-nvim'

"""colorizes hex codes (hex codes will be in their respective color)
Plug 'norcalli/nvim-colorizer.lua'
"" double grouping symbols
Plug 'jiangmiao/auto-pairs' 
"File tree
Plug 'kyazdani42/nvim-tree.lua'
"""Lualine statusline 
Plug 'hoob3rt/lualine.nvim'
"for icons in the lualine statusline
Plug 'kyazdani42/nvim-web-devicons'
"Floaterm
Plug 'voldikss/vim-floaterm'

""" "colorscheme"
Plug 'morhetz/gruvbox'               "gruvbox

Plug 'joshdick/onedark.vim'          "onedark
Plug 'rakr/vim-one'                  "onedark with light theme


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
Plug 'sindrets/diffview.nvim', {'on': 'DiffviewOpen'}
"git signs in gutter 
Plug 'nvim-lua/plenary.nvim'
Plug 'lewis6991/gitsigns.nvim'

"""Markdown
Plug 'davidgranstrom/nvim-markdown-preview', {'on': 'MarkdownPreview'}

"""Movement 
Plug 'ggandor/lightspeed.nvim'

"""Misc
Plug 'lukas-reineke/indent-blankline.nvim'

call plug#end()
"""##########################

"Indent line
let g:indent_blankline_char = '│'
let g:indent_blankline_filetype_exclude = ['help']
let g:indent_blankline_show_current_context = v:true
"let g:indent_blankline_use_treesitter = v:true



" ██████╗ ██████╗ ██╗      ██████╗ ██████╗ 
"██╔════╝██╔═══██╗██║     ██╔═══██╗██╔══██╗
"██║     ██║   ██║██║     ██║   ██║██████╔╝
"██║     ██║   ██║██║     ██║   ██║██╔══██╗
"╚██████╗╚██████╔╝███████╗╚██████╔╝██║  ██║
" ╚═════╝ ╚═════╝ ╚══════╝ ╚═════╝ ╚═╝  ╚═╝

"useful website with color wheel and color theory stuff 
"https://www.canva.com/colors/color-wheel/
"######### colorscheme
"removes the ~ at the end of buffers with the onedark colorscheme 
let g:onedark_hide_endofbuffer = 1

"italics
let g:one_allow_italics = 1         "one
let g:onedark_terminal_italics = 1  "onedark
let g:gruvbox_italic = 1            "gruvbox

colorscheme gruvbox

"look at :h pumblend
"This enables transparency for the completion menu
set pumblend=10

"##########COLORIZER##########
"colorizer for displaying color as a highlight 
"example:  #0000ff
"This may break when sourcing this file
lua require 'colorizer'.setup()

"######## highlights
"changes the floating window colors
"Normal float was originialy linked to Pmenu
hi FloatBorder guibg=#342829 guifg=#F34955
hi NormalFloat guibg=#282828

"look at :h pumblend 
"this allows for the selection in the completion menu to not be transparent when "pumblend" is set
hi PmenuSel blend=0


"cmp
"shows suggested completion as completely white text
hi! CmpItemAbbr    guifg=NONE

"changes source (such as [LSP] or [buf]) color
hi! CmpItemMenu         guifg=#76695D   
"hi! CmpItemMenu         guifg=#8FDD78   gui=italic

"changes item kind color (such as text, variable, operator, snippet, etc.)
"hi! CmpItemKind   guifg=#C678DD
hi! CmpItemKindDefault   guifg=#DCAEEA     gui=bold
"hi! CmpItemKind guifg=#a9a1e1
"hi! LspDiagnosticsUnderlineError cterm=underline gui=undercurl guisp=Red



"changes comments to italic, but resets to normal when changing colorscheme
"highlight Comment gui=italic

" ██████╗ ██╗████████╗
"██╔════╝ ██║╚══██╔══╝
"██║  ███╗██║   ██║   
"██║   ██║██║   ██║   
"╚██████╔╝██║   ██║   
" ╚═════╝ ╚═╝   ╚═╝   
"git


"### git signs plugin
lua << EOF
require('gitsigns').setup{
signs = {
    add          = {hl = 'GitSignsAdd'   , text = '│', numhl='GitSignsAddNr'   , linehl='GitSignsAddLn'},
    change       = {hl = 'GitSignsChange', text = '│', numhl='GitSignsChangeNr', linehl='GitSignsChangeLn'},
    delete       = {hl = 'GitSignsDelete', text = '_', numhl='GitSignsDeleteNr', linehl='GitSignsDeleteLn'},
    topdelete    = {hl = 'GitSignsDelete', text = '‾', numhl='GitSignsDeleteNr', linehl='GitSignsDeleteLn'},
    changedelete = {hl = 'GitSignsChange', text = '~', numhl='GitSignsChangeNr', linehl='GitSignsChangeLn'},
  },
keymaps = {
    -- Default keymap options
    noremap = true,
    
    --NOTE: the n in 'n [a' denotes normal mode
    ['n ]a'] = { expr = true, "&diff ? ']a' : '<cmd>lua require\"gitsigns.actions\".next_hunk()<CR>'"},
    ['n [a'] = { expr = true, "&diff ? '[a' : '<cmd>lua require\"gitsigns.actions\".prev_hunk()<CR>'"},

    ['n <leader>hs'] = '<cmd>lua require"gitsigns".stage_hunk()<CR>',
    ['v <leader>hs'] = '<cmd>lua require"gitsigns".stage_hunk({vim.fn.line("."), vim.fn.line("v")})<CR>',
    ['n <leader>hu'] = '<cmd>lua require"gitsigns".undo_stage_hunk()<CR>',
    ['n <leader>hr'] = '<cmd>lua require"gitsigns".reset_hunk()<CR>',
    ['v <leader>hr'] = '<cmd>lua require"gitsigns".reset_hunk({vim.fn.line("."), vim.fn.line("v")})<CR>',
    ['n <leader>hR'] = '<cmd>lua require"gitsigns".reset_buffer()<CR>',
    ['n <leader>hp'] = '<cmd>lua require"gitsigns".preview_hunk()<CR>',
    ['n <leader>hb'] = '<cmd>lua require"gitsigns".blame_line(true)<CR>',
    ['n <leader>hS'] = '<cmd>lua require"gitsigns".stage_buffer()<CR>',
    ['n <leader>hU'] = '<cmd>lua require"gitsigns".reset_buffer_index()<CR>',

    -- Text objects
    ['o ih'] = ':<C-U>lua require"gitsigns.actions".select_hunk()<CR>',
    ['x ih'] = ':<C-U>lua require"gitsigns.actions".select_hunk()<CR>'
  },
}
EOF

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


"██╗     ███████╗██████╗ 
"██║     ██╔════╝██╔══██╗
"██║     ███████╗██████╔╝
"██║     ╚════██║██╔═══╝ 
"███████╗███████║██║     
"╚══════╝╚══════╝╚═╝     


nnoremap <silent>K :lua vim.lsp.buf.hover()<CR>
nnoremap <silent>gd :lua vim.lsp.buf.definition()<CR>
nnoremap <silent>gD :lua vim.lsp.buf.declaration()<CR>
nnoremap <silent>gr :lua vim.lsp.buf.rename()<CR>

"add servers by adding to "local servers = ..." list
lua << EOF
local nvim_lsp = require('lspconfig')
--Add additional capabilities supported by nvim-cmp
local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities = require('cmp_nvim_lsp').update_capabilities(capabilities)

-- Enable some language servers with the additional completion capabilities offered by nvim-cmp
local servers = { 'pyright', 'bashls', 'vimls' }
for _, lsp in ipairs(servers) do
  nvim_lsp[lsp].setup {
    -- on_attach = my_custom_on_attach,
    capabilities = capabilities,
  }
end

local signs = { Error = " ", Warning = " ", Hint = " ", Information = " " }

for type, icon in pairs(signs) do
  local hl = "LspDiagnosticsSign" .. type
  vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = "" })
end

-- icon
vim.lsp.handlers["textDocument/publishDiagnostics"] = vim.lsp.with(
  vim.lsp.diagnostic.on_publish_diagnostics, {
    underline = true,
    signs = true,
    virtual_text = {
      spacing = 4,
      prefix = '■'
    },
    update_in_insert = true
  }
)



--" ██████╗███╗   ███╗██████╗ 
--"██╔════╝████╗ ████║██╔══██╗
--"██║     ██╔████╔██║██████╔╝
--"██║     ██║╚██╔╝██║██╔═══╝ 
--"╚██████╗██║ ╚═╝ ██║██║     
--" ╚═════╝╚═╝     ╚═╝╚═╝     
--" nvim cmp
--
--
--"cmp 

-- lspkind icons
local lspkind = require "lspkind"
lspkind.init()

-- luasnip
local has_words_before = function()
  local line, col = unpack(vim.api.nvim_win_get_cursor(0))
  return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") == nil
end

local luasnip = require 'luasnip'

require('luasnip.loaders.from_vscode').lazy_load()

local cmp = require 'cmp'

cmp.setup {
  snippet = {
    expand = function(args)
      require('luasnip').lsp_expand(args.body)
    end,
  },
mapping = {
--    ['<C-p>'] = cmp.mapping.select_prev_item(),
--    ['<C-n>'] = cmp.mapping.select_next_item(),
    ['<C-d>'] = cmp.mapping.scroll_docs(-4),
    ['<C-f>'] = cmp.mapping.scroll_docs(4),
    ['<C-Space>'] = cmp.mapping.complete(),
    ['<C-e>'] = cmp.mapping.close(),

    ['<CR>'] = cmp.mapping.confirm {
      behavior = cmp.ConfirmBehavior.Replace,
      select = true,
    },

    ["<Tab>"] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_next_item()
--      elseif luasnip.expand_or_jumpable() then
--        luasnip.expand_or_jump()
--        vim.fn.feedkeys(vim.api.nvim_replace_termcodes('<Plug>luasnip-expand-or-jump', true, true, true), '')
      elseif has_words_before() then
        cmp.complete()
      else
        fallback()
      end
    end, { "i", "s" }),

    ["<S-Tab>"] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_prev_item()
--      elseif luasnip.jumpable(-1) then
--        luasnip.jump(-1)
--        vim.fn.feedkeys(vim.api.nvim_replace_termcodes('<Plug>luasnip-jump-prev', true, true, true), '')
      else
        fallback()
      end
    end, { "i", "s" }),
  },

  --Insert new cmp sources here: 
  sources = {
    { name = 'nvim_lsp' },
    { name = 'luasnip' },
    { name = 'buffer', keyword_length = 5},
    { name = 'path' },
  },

  --Uses lspkind
  formatting = {
    format = lspkind.cmp_format {
      with_text = true,
      menu = {
        buffer = "[buf]",
        nvim_lsp = "[LSP]",
        path = "[path]",
        luasnip = "[snip]",
      },
    },
  },

  experimental = {
      native_menu = false,
      ghost_text = true,
    },
}
EOF

"<M-k> and <M-j> for next and previous
"luasnip mappings
imap <silent><expr> <M-k> luasnip#expand_or_jumpable() ? '<Plug>luasnip-expand-or-jump' : '<Tab>' 
inoremap <silent> <M-j> <cmd>lua require'luasnip'.jump(-1)<Cr>

snoremap <silent> <M-k> <cmd>lua require('luasnip').jump(1)<Cr>
snoremap <silent> <M-j> <cmd>lua require('luasnip').jump(-1)<Cr>

imap <silent><expr> <C-E> luasnip#choice_active() ? '<Plug>luasnip-next-choice' : '<C-E>'
smap <silent><expr> <C-E> luasnip#choice_active() ? '<Plug>luasnip-next-choice' : '<C-E>'



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
    theme = 'auto',
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
        --color_added = colors.green,
        --color_modified = colors.blue,
        --color_removed = colors.red,

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
extensions = { 'fzf'}
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

"navigate using numbers
nnoremap <silent><leader>1 <Cmd>BufferLineGoToBuffer 1<CR>
nnoremap <silent><leader>2 <Cmd>BufferLineGoToBuffer 2<CR>
nnoremap <silent><leader>3 <Cmd>BufferLineGoToBuffer 3<CR>
nnoremap <silent><leader>4 <Cmd>BufferLineGoToBuffer 4<CR>
nnoremap <silent><leader>5 <Cmd>BufferLineGoToBuffer 5<CR>
nnoremap <silent><leader>6 <Cmd>BufferLineGoToBuffer 6<CR>
nnoremap <silent><leader>7 <Cmd>BufferLineGoToBuffer 7<CR>
nnoremap <silent><leader>8 <Cmd>BufferLineGoToBuffer 8<CR>
nnoremap <silent><leader>9 <Cmd>BufferLineGoToBuffer 9<CR>

lua << EOF
require"bufferline".setup{
        options = {
            view = "default",
            numbers = "ordinal",
            --number_style = "subscript", -- buffer_id at index 1, ordinal at index 2
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


"████████╗██████╗ ███████╗███████╗
"╚══██╔══╝██╔══██╗██╔════╝██╔════╝
"   ██║   ██████╔╝█████╗  █████╗  
"   ██║   ██╔══██╗██╔══╝  ██╔══╝  
"   ██║   ██║  ██║███████╗███████╗
"   ╚═╝   ╚═╝  ╚═╝╚══════╝╚══════╝
"                                 
"nvim-tree
lua require'nvim-tree'.setup()
nnoremap <F1> :NvimTreeToggle<CR>


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
        p = { ":FloatermNew python3<CR>"                           ,"python3 [REPL]" }, 
        b = { ":FloatermNew btm<CR>"                              ,"btm" }, 
        i = { ":FloatermNew speedtest-cli<CR>"                     ,"Internet test" }, 
        t = { ":FloatermNew <CR>"                                  ,"Toggle" }, 
        n = { ":FloatermNew ncdu<CR>"                              ,"View space taken" }, 
        l = { ":FloatermNew lua<CR>"                              ,"lua [REPL]" }, 
    },
            },
{ prefix = "<leader>" })
EOF

