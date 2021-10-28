vim.api.nvim_exec([[
function! ZathuraOpenPdf()
  let fullPath = expand("%:p")
  let pdfFile = substitute(fullPath, ".tex", ".pdf", "")
  silent make target="%" &
  execute "silent !zathura '" . pdfFile . "' &"
endfunction

function! BuildLatexFiles()
  let fullPath = expand("%:p")
  let pdfFile = substitute(fullPath, ".tex", ".pdf", "")
  execute "silent !rm '" . pdfFile ."'"
  silent make target="%"
endfunction

]], false)

vim.api.nvim_set_keymap("n", "<A-p>", ":call ZathuraOpenPdf()<CR>", {noremap = true})
vim.api.nvim_set_keymap("n", "<A-b>", ":call BuildLatexFiles()<CR>", {noremap = true})

vim.api.nvim_exec([[
au BufWritePost *.*tex call BuildLatexFiles()
]], false)
