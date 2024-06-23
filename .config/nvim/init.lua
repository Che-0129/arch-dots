vim.opt.encoding = 'utf-8'
vim.opt.fileencoding = 'utf-8'
vim.scriptencoding = 'utf-8'
vim.opt.number = true
vim.opt.title = true
vim.opt.laststatus = 2
vim.opt.ruler = true
vim.opt.tabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true
vim.opt.matchtime = 1
vim.opt.showmatch = true
vim.opt.backup = false
vim.opt.swapfile = false
vim.opt.showcmd = true
vim.opt.autoread = true
vim.opt.incsearch = true
vim.opt.smartindent = true
vim.opt.autoindent = true
vim.opt.scrolloff = 5
vim.opt.sidescrolloff = 5
vim.opt.backspace = 'indent,eol,start'
vim.opt.syntax = 'on'
vim.opt.mouse = ''
vim.opt.hlsearch = false
vim.opt.termguicolors = true
vim.opt.clipboard = "unnamedplus"

if vim.fn.executable('fcitx5') then
    vim.cmd([[autocmd InsertLeave * :silent !fcitx5-remote -c]])
    vim.cmd([[autocmd CmdlineLeave * :silent !fcitx5-remote -c]])
end

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable",
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
    {"nvim-lualine/lualine.nvim", event = "VeryLazy"},
    {"rmehri01/onenord.nvim", event = "VeryLazy"},
    {"windwp/nvim-autopairs", event = "InsertEnter"},
    {"mcauley-penney/tidy.nvim", event = "InsertEnter"},
    {"lukas-reineke/indent-blankline.nvim", event = "BufNewFile", "BufRead"},
    {"norcalli/nvim-colorizer.lua", event = "BufNewFile", "BufRead"},
    {"mvllow/modes.nvim", event = "ModeChanged"},
    {"neovim/nvim-lspconfig", event = "LspAttach"},
    {"hrsh7th/nvim-cmp", event = "InsertEnter"},
    {"hrsh7th/cmp-nvim-lsp", event = "InsertEnter"},
    {"saadparwaiz1/cmp_luasnip", event = "InsertEnter"},
    {"L3MON4D3/LuaSnip", event = "InsertEnter"},
    {"williamboman/mason.nvim",
        cmd = {
            "Mason",
            "MasonInstall",
            "MasonUninstall",
            "MasonUninstallAll",
            "MasonLog",
            "MasonUpdate",
        }
    },
    {"williamboman/mason-lspconfig.nvim", event = "LspAttach"},
})

require('lualine').setup {
    option = {
        theme = 'onenord'
    }
}
require('onenord').setup()
require('nvim-autopairs').setup()
require('tidy').setup()
require('ibl').setup()
require('colorizer').setup()
require('modes').setup()
require("mason").setup()
require("mason-lspconfig").setup {
    ensure_installed = {"clangd", "html", "cssls", "pyright"},
}

local capabilities = require("cmp_nvim_lsp").default_capabilities()
local lspconfig = require('lspconfig')

local servers = { 'clangd', 'html', 'pyright', 'cssls' }
for _, lsp in ipairs(servers) do
  lspconfig[lsp].setup {
    capabilities = capabilities,
  }
end

local luasnip = require 'luasnip'

local cmp = require 'cmp'
cmp.setup {
  snippet = {
    expand = function(args)
      luasnip.lsp_expand(args.body)
    end,
  },
  mapping = cmp.mapping.preset.insert({
    ['<C-Space>'] = cmp.mapping.complete(),
    ['<CR>'] = cmp.mapping.confirm {
      behavior = cmp.ConfirmBehavior.Replace,
      select = true,
    },
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
  sources = {
    { name = 'nvim_lsp' },
    { name = 'luasnip' },
  },
}
