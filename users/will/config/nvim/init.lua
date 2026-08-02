vim.lsp.enable('nixd')
vim.lsp.enable('lua_ls')
vim.lsp.codelens.enable(true)
vim.lsp.inlay_hint.enable(true)

local cmp = require('cmp')
local luasnip = require('luasnip')

cmp.setup({
  snippet = {
    -- Required: link the snippet engine to nvim-cmp
    expand = function(args)
      luasnip.lsp_expand(args.body)
    end,
  },
  mapping = cmp.mapping.preset.insert({
    ['<C-b>'] = cmp.mapping.scroll_docs(-4),
    ['<C-f>'] = cmp.mapping.scroll_docs(4),
    ['<C-Space>'] = cmp.mapping.complete(), -- Manually trigger suggestions
    ['<C-e>'] = cmp.mapping.abort(),        -- Close completion menu
    ['<CR>'] = cmp.mapping.confirm({ select = true }), -- Accept current suggestion
    
    -- Use Tab and Shift-Tab to navigate the popup menu
    ['<Tab>'] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_next_item()
      elseif luasnip.expand_or_jumpable() then
        luasnip.expand_or_jump()
      else
        fallback()
      end
    end, { 'i', 's' }),
    ['<S-Tab>'] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_prev_item()
      elseif luasnip.jumpable(-1) then
        luasnip.jump(-1)
      else
        fallback()
      end
    end, { 'i', 's' }),
  }),

  -- Set priority order for your autocomplete suggestions
  sources = cmp.config.sources({
    { name = 'nvim_lsp' }, -- High priority: Code intelligence
    { name = 'luasnip' },  -- Snippets
  }, {
    { name = 'buffer' },   -- Text from open file
    { name = 'path' },     -- Local file paths
  })
})

vim.keymap.set('n', '<leader>lr', function()
  require('telescope.builtin').lsp_references()
end, { desc = "Find References" })

-- Apply the "fix available" recommendation
vim.keymap.set('n', '<leader>ca', vim.lsp.buf.code_action, { desc = 'LSP Code Action' })

-- Optional: Add other helpful diagnostic keymaps
vim.keymap.set('n', 'gd', vim.lsp.buf.definition, { desc = 'Go to definition' })
vim.keymap.set('n', 'K', vim.lsp.buf.hover, { desc = 'Show documentation' })


-- ────────────────────────────────────────────────────────────
-- Options
-- ────────────────────────────────────────────────────────────
vim.opt.background = "dark"
vim.opt.mouse = "a"
vim.opt.number = true
vim.opt.cursorline = true
vim.opt.softtabstop = 2
vim.opt.shiftwidth = 2
vim.opt.expandtab = true
vim.opt.wildmenu = true
vim.opt.laststatus = 2
vim.opt.incsearch = true
vim.opt.hlsearch = true
vim.opt.showcmd = true
vim.opt.showmatch = true
vim.opt.smartcase = true
vim.opt.autowrite = true
vim.diagnostic.enable(true)
vim.diagnostic.config({
  virtual_lines = true,
})

-- System clipboard (needs wl-clipboard installed)
vim.opt.clipboard:append("unnamedplus")

-- Folding
vim.opt.foldenable = true
vim.opt.foldlevelstart = 10
vim.opt.foldnestmax = 10
vim.opt.foldmethod = "indent"

-- Leader key
vim.g.mapleader = ","
vim.g.maplocalleader = ","

-- ────────────────────────────────────────────────────────────
-- Highlights (transparent background)
-- ────────────────────────────────────────────────────────────
-- vim.api.nvim_set_hl(0, "Normal",  { ctermbg = "NONE", guibg = "NONE" })
-- vim.api.nvim_set_hl(0, "NonText", { ctermbg = "NONE", guibg = "NONE" })
-- vim.api.nvim_set_hl(0, "LineNr",  { ctermbg = "NONE", guibg = "NONE" })

-- ────────────────────────────────────────────────────────────
-- Keymaps
-- ────────────────────────────────────────────────────────────
vim.keymap.set("n", "<leader><space>", ":nohlsearch<CR>", { desc = "Clear search highlights" })

-- Visual mode Ctrl+Shift+C → system clipboard (optional, since +unnamedplus handles this)
vim.keymap.set("v", "<C-S-c>", '"+y', { desc = "Copy to system clipboard" })

-- ────────────────────────────────────────────────────────────
-- Autocommands: restore cursor position
-- ────────────────────────────────────────────────────────────
vim.api.nvim_create_autocmd("BufReadPost", {
  pattern = "*",
  callback = function()
    local mark = vim.api.nvim_buf_get_mark(0, '"')
    local line = mark[1]
    if line > 1 and line <= vim.api.nvim_buf_line_count(0) then
      vim.api.nvim_win_set_cursor(0, { line, mark[2] })
    end
  end,
})

-- ────────────────────────────────────────────────────────────
-- Colorscheme
-- ────────────────────────────────────────────────────────────
vim.cmd("colorscheme badwolf")

