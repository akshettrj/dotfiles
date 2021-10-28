-- vim.g.codedark_term256 = 1

-- VS Code Dark ColorScheme
-- vim.cmd[[colorscheme codedark]]

vim.cmd[[
let g:gruvbox_transparent_background = 1
let g:gruvbox_improved_warnings = 1
colorscheme gruvbox
]]

--[[
require("lsp-colors").setup({
  Error = "#db4b4b",
  Warning = "#e0af68",
  Information = "#0db9d7",
  Hint = "#10B981"
})
--]]

--[[
au ColorScheme * highlight Normal guibg=NONE
au ColorScheme * highlight EndOfBuffer guibg=NONE
au ColorScheme * highlight SignColumn guibg=NONE
au ColorScheme * highlight LineNr guibg=NONE
au ColorScheme * highlight CursorLineNr guibg=NONE
au ColorScheme * highlight Comment gui=italic
--]]

-- Make things transparent
--[[
vim.cmd[[
au ColorScheme * highlight VimwikiHeader1 guifg=#b57419 gui=bold
au ColorScheme * highlight VimwikiHeader2 guifg=#38b519 gui=bold
au ColorScheme * highlight VimwikiHeader3 guifg=#1984b5 gui=bold
au ColorScheme * highlight VimwikiHeader4 guifg=#943537 gui=bold
au ColorScheme * highlight VimwikiLink guifg=#15dde8 gui=underline
]]
--]]
