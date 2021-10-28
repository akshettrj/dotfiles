local ls = require"luasnip"
local s = ls.snippet
local sn = ls.snippet_node
local isn = ls.indent_snippet_node
local t = ls.text_node
local i = ls.insert_node
local f = ls.function_node
local c = ls.choice_node
local d = ls.dynamic_node
local events = require("luasnip.util.events")

local rec_ls
rec_ls = function()
  return sn(nil, {
      c(1, {
          -- important!! Having the sn(...) as the first choice will cause infinite recursion.
          t({""}),
          -- The same dynamicNode as in the snippet (also note: self reference).
          sn(nil, {t({"", "\t\\item "}), i(1), d(2, rec_ls, {})}),
        }),
    });
end

local function char_count_same(c1, c2)
  local line = vim.api.nvim_get_current_line()
  -- '%'-escape chars to force explicit match (gsub accepts patterns).
  -- second return value is number of substitutions.
  local _, ct1 = string.gsub(line, '%'..c1, '')
  local _, ct2 = string.gsub(line, '%'..c2, '')
  return ct1 == ct2
end

local function even_count(c)
  local line = vim.api.nvim_get_current_line()
  local _, ct = string.gsub(line, c, '')
  return ct % 2 == 0
end

local function neg(fn, ...)
  return not fn(...)
end

local function part(fn, ...)
  local args = {...}
  return function() return fn(unpack(args)) end
end

-- This makes creation of pair-type snippets easier.
local function pair(pair_begin, pair_end, expand_func, ...)
  -- triggerd by opening part of pair, wordTrig=false to trigger anywhere.
  -- ... is used to pass any args following the expand_func to it.
  return s({trig = pair_begin, wordTrig=false},{
      t({pair_begin}), i(1), t({pair_end})
    }, {
      condition = part(expand_func, part(..., pair_begin, pair_end))
    })
end


ls.snippets = {
  tex = {
    s("ls", {
        t({"\\begin{itemize}",
          "\t\\item "}), i(1), d(2, rec_ls, {}),
      t({"", "\\end{itemize}"}), i(0)
    }),
    pair("(", ")", neg, char_count_same),
    pair("{", "}", neg, char_count_same),
    pair("[", "]", neg, char_count_same),
    pair("<", ">", neg, char_count_same),
    pair("'", "'", neg, even_count),
    pair('"', '"', neg, even_count),
    pair("`", "`", neg, even_count)
  }
}

require("luasnip/loaders/from_vscode").lazy_load()
