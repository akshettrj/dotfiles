vim.lsp.handlers['textDocument/publishDiagnostics'] = vim.lsp.with(vim.lsp.diagnostic.on_publish_diagnostics, {
  virtual_text = {
	  spacing = 4,
  },
  signs = true,
  underline = true,
  update_in_insert = false,
})
