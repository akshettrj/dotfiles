local cmp = require('cmp')
local luasnip = require('luasnip')

require('cmp-npm')

cmp.setup.cmdline('/', {
  sources = cmp.config.sources({
    { name = 'nvim_lsp_document_symbol' }
  }, {
    { name = 'buffer' }
  })
})

cmp.setup({
  snippet = {
    expand = function(args)
      -- For `luasnip`
      require('luasnip').lsp_expand(args.body)
    end
  },
  mapping = {
    ['<C-d>'] = cmp.mapping.scroll_docs(-4),
    ['<C-f>'] = cmp.mapping.scroll_docs(4),
    ['<C-e>'] = cmp.mapping.abort(),
    ["<Down>"] = cmp.mapping.select_next_item { behaviour = cmp.SelectBehavior.Select },
    ["<Up>"] = cmp.mapping.select_prev_item { behaviour = cmp.SelectBehavior.Select },
    ["<Right>"] = cmp.mapping.confirm { select = true },
    ["<Tab>"] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_next_item()
      elseif luasnip.expand_or_jumpable() then
        luasnip.expand_or_jump()
      else
        fallback()
      end
    end, { "i", "s" }),
    ["<S-Tab>"] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_prev_item()
      elseif luasnip.jumpable(-1) then
        luasnip.jump(-1)
      else
        fallback()
      end
    end, { "i", "s" }),
    ['<C-y>'] = cmp.mapping.confirm({ select = true }),
  },
  sources = {
    { name = 'npm', keyword_length = 4 },
    { name = 'luasnip'},
    { name = 'nvim_lsp' },
    { name = 'nvim_lua' },
    { name = 'path' },
    { name = 'latex_symbols' },
    -- { name = 'zsh' },
    -- { name = 'treesitter' },
    { name = 'buffer', keyword_length = 5, max_item_count = 4 },
    { name = 'emoji' },
    { name = 'spell', keyword_length = 5 },
  },
  documentation = {
  },
  experimental = {
    native_menu = false,
    ghost_text = true,
  },
  formatting = {
    format = function(entry, vim_item)
      -- fancy icons and a name of kind
      vim_item.kind = require("lspkind").presets.default[vim_item.kind] .. " " .. vim_item.kind

      -- set a name for each source
      vim_item.menu = ({
        npm = "",
        buffer = "﬘",
        nvim_lsp = "",
        luasnip = "",
        nvim_lua = "",
        emoji = "ﲃ",
        latex_symbols = "",
        treesitter = "滑",
        path = "",
        zsh = "",
        spell = "暈"
      })[entry.source.name]

      return vim_item
    end,
  }
})

local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities = require('cmp_nvim_lsp').update_capabilities(capabilities)
capabilities.textDocument.completion.completionItem.snippetSupport = true

local on_attach = function(client, bufnr)

  require'lsp_signature'.on_attach()

  local function buf_set_keymap(...) vim.api.nvim_buf_set_keymap(bufnr, ...) end
  -- local function buf_set_option(...) vim.api.nvim_buf_set_option(bufnr, ...) end

  -- Mappings.
  local opts = { noremap=true, silent=true }

  -- See `:help vim.lsp.*` for documentation on any of the below functions
  buf_set_keymap('n', 'gD', '<cmd>lua vim.lsp.buf.declaration()<CR>', opts)
  buf_set_keymap('n', 'gd', '<cmd>lua vim.lsp.buf.definition()<CR>', opts)
  buf_set_keymap('n', 'K', '<cmd>lua vim.lsp.buf.hover({border="single"})<CR>', opts)
  buf_set_keymap('n', 'gim', '<cmd>lua vim.lsp.buf.implementation()<CR>', opts)
  -- buf_set_keymap('n', '<C-k>', '<cmd>lua vim.lsp.buf.signature_help()<CR>', opts)
  -- buf_set_keymap('n', '<leader>lwa', '<cmd>lua vim.lsp.buf.add_workspace_folder()<CR>', opts)
  -- buf_set_keymap('n', '<leader>lwr', '<cmd>lua vim.lsp.buf.remove_workspace_folder()<CR>', opts)
  -- buf_set_keymap('n', '<leader>lwl', '<cmd>lua print(vim.inspect(vim.lsp.buf.list_workspace_folders()))<CR>', opts)
  buf_set_keymap('n', '<leader>lD', '<cmd>lua vim.lsp.buf.type_definition()<CR>', opts)
  buf_set_keymap('n', '<leader>lrn', '<cmd>lua vim.lsp.buf.rename()<CR>', opts)
  buf_set_keymap('n', '<leader>lca', '<cmd>lua vim.lsp.buf.code_action()<CR>', opts)
  buf_set_keymap('n', 'gr', '<cmd>lua vim.lsp.buf.references()<CR>', opts)
  buf_set_keymap('n', '<leader>e', '<cmd>lua vim.lsp.diagnostic.show_line_diagnostics()<CR>', opts)
  buf_set_keymap('n', '[d', '<cmd>lua vim.lsp.diagnostic.goto_prev()<CR>', opts)
  buf_set_keymap('n', ']d', '<cmd>lua vim.lsp.diagnostic.goto_next()<CR>', opts)
  buf_set_keymap('n', '<leader>lq', '<cmd>lua vim.lsp.diagnostic.set_loclist()<CR>', opts)
  buf_set_keymap('n', '<leader>lf', '<cmd>lua vim.lsp.buf.formatting()<CR>', opts)
  -- buf_set_keymap('n', '<LeftMouse>', '<LeftMouse><cmd>lua vim.lsp.buf.hover({border = "single"})<CR>', opts)
  buf_set_keymap('n', '<LeftMouse>', '<LeftMouse><cmd>lua vim.lsp.diagnostic.show_line_diagnostics()<CR>', opts)
  buf_set_keymap('n', '<RightMouse>', '<LeftMouse><cmd>lua vim.lsp.buf.definition()<CR>', opts)

end

-- C/C++

require'lspconfig'.clangd.setup {
  capabilities = capabilities,
  on_attach = on_attach,
  cmd = {"clangd", "--background-index", "--cross-file-rename"},
  -- root_dir = vim.util.root_pattern("compile_commands.json", "compile_flags.txt", ".git")
}

-- Javascript

require'lspconfig'.tsserver.setup{
  capabilities = capabilities,
  on_attach = on_attach
}

-- Python

require'lspconfig'.pyright.setup {
  capabilities = capabilities,
  on_attach = on_attach
}

-- CSS

require'lspconfig'.cssls.setup {
  capabilities = capabilities,
  on_attach = on_attach
}

-- Flutter

-- require'flutter-tools'.setup{}


































-- Lua

-- https://github.com/sumneko/lua-language-server/wiki/Build-and-Run-(Standalone)
---[[
USER = vim.fn.expand('$USER')

local sumneko_root_path = ""
local sumneko_binary = ""

if vim.fn.has("mac") == 1 then
  sumneko_root_path = "/Users/" .. USER .. "/.config/nvim/lsp/lua-language-server"
  sumneko_binary = "/Users/" .. USER .. "/.config/nvim/lsp/lua-language-server/bin/macOS/lua-language-server"
elseif vim.fn.has("unix") == 1 then
  sumneko_root_path = "/home/" .. USER .. "/.config/nvim/lua-language-server"
  sumneko_binary = "/home/" .. USER .. "/.config/nvim/lua-language-server/bin/Linux/lua-language-server"
else
  print("Unsupported system for sumneko")
end

require'lspconfig'.sumneko_lua.setup {
  cmd = {sumneko_binary, "-E", sumneko_root_path .. "/main.lua"},
  settings = {
    Lua = {
      runtime = {
        -- Tell the language server which version of Lua you're using (most likely LuaJIT in the case of Neovim)
        version = 'LuaJIT',
        -- Setup your lua path
        path = vim.split(package.path, ';')
      },
      diagnostics = {
        -- Get the language server to recognize the `vim` global
        globals = {'vim'}
      },
      workspace = {
        -- Make the server aware of Neovim runtime files
        library = {
          [vim.fn.expand('$VIMRUNTIME/lua')] = true,
          [vim.fn.expand('$VIMRUNTIME/lua/vim/lsp')] = true,
          ["${3rd}/love2d/library"]
        = true};
        maxPreload = 2000;
        preloadFileSize = 1000;
        checkThirdParty = false
      }
    }
  }
}
--]]
