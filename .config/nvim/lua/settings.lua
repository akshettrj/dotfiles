local o = vim.o
local cmd = vim.cmd

-- Line Numbering
o.number = true
o.relativenumber = true

-- Encoding
o.encoding = 'utf-8'

-- Enable Mouse
o.mouse = 'a'

-- Don't break words
o.wrap = true
o.linebreak = true

-- Splits open in intuitive direction
o.splitbelow = true
o.splitright = true

-- Tabbing and spacing
o.tabstop = 4
o.shiftwidth = 4
o.expandtab = true
-- o.smarttab = true
-- o.smartindent = true
-- o.autoindent = true

-- Completion Moment
o.completeopt = "menuone,noselect"


-- Fix Syntax on saving
cmd[[
set title
setglobal termguicolors
" Storing current cursor position
autocmd BufWritePre * let save_pos = getpos('.')

autocmd BufWritePre * %s/\s\+$//e
autocmd BufWritePre * %s/\n\+\%$//e

" Restoring current cursor position
autocmd BufWritePre * call setpos('.', save_pos)

autocmd BufWritePost *.wiki silent !reload_browser &

" No need of mode showing now
set noshowmode

augroup highlight_yank
    autocmd!
    autocmd TextYankPost * silent! lua require'vim.highlight'.on_yank({timeout = 40})
augroup END

]]

-- Disable auto commenting
cmd[[
autocmd BufEnter * setlocal fo-=c fo-=r fo-=o
]]
