vim.opt.encoding = 'utf-8'
vim.opt.fileencoding = 'utf-8'
vim.scriptencoding = 'utf-8'
vim.opt.number = true
vim.opt.title = true
vim.opt.laststatus = 2
vim.opt.ruler = true
vim.opt.tabstop = 4
vim.opt.softtabstop = 4
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
vim.opt.guicursor = "i:ver100-blinkon500-blinkoff500"
vim.api.nvim_create_autocmd("VimLeave", {
    pattern = "*",
    command = "set guicursor=a:ver25-blinkon500-blinkoff500",
})
vim.api.nvim_create_augroup("RetabBeforeWrite", {
    clear = true
})
vim.api.nvim_create_autocmd("BufWritePre", {
    group = "RetabBeforeWrite",
    pattern = "*",
    command = "retab"
})
vim.api.nvim_create_autocmd("TextYankPost", {
    callback = function()
        local yank_type = vim.v.event.operator
        if yank_type == "y" then
            vim.fn.setreg("+", vim.fn.getreg("\""))
        end
  end,
})

if vim.fn.executable('fcitx5') then
    vim.cmd([[autocmd InsertLeave * :silent !fcitx5-remote -c]])
    vim.cmd([[autocmd CmdlineLeave * :silent !fcitx5-remote -c]])
end

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
    local lazyrepo = "https://github.com/folke/lazy.nvim.git"
    local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
    if vim.v.shell_error ~= 0 then
        vim.api.nvim_echo({
            { "Failed to clone lazy.nvim:\n", "ErrorMsg" },
            { out, "WarningMsg" },
            { "\nPress any key to exit..." },
        }, true, {})
        vim.fn.getchar()
        os.exit(1)
    end
end
vim.opt.rtp:prepend(lazypath)

vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

require("lazy").setup({
    spec = {
        { "folke/which-key.nvim", opts = {} },
        { "HiPhish/rainbow-delimiters.nvim", opts = {} },
        { "j-hui/fidget.nvim",
            opts = {
                text = {
                    spinner = "meter"
                }
            }
        },
        { "johnfrankmorgan/whitespace.nvim", opts = {} },
        { "karb94/neoscroll.nvim", opts = {} },
        { "lukas-reineke/indent-blankline.nvim",
            main = "ibl",
            opts = {}
        },
        { "mason-org/mason-lspconfig.nvim",
            opts = {
                ensure_installed = {
                    "clangd",
                    "cssls",
                    "html",
                    "pyright"
                }
            }
        },
        { "mason-org/mason.nvim", opts = {} },
        { "mvllow/modes.nvim", opts = {} },
        { "neovim/nvim-lspconfig" },
        { "norcalli/nvim-colorizer.lua",
            main = "colorizer",
            opts = {
                "*",
                css = {
                    rgb_fn = true
                }
            }
        },
        { "nvim-lualine/lualine.nvim", opts = {} },
        { "rmehri01/onenord.nvim", opts = {} },
        { "RRethy/vim-illuminate", main = "illuminate" },
        { "Saghen/blink.cmp",
            dependencies = {
                "rafamadriz/friendly-snippets"
            },
            version = "*",
            opts = {},
            sources = {
                "lsp",
                "path",
                "snippets",
                "buffer"
            },
            fuzzy = {
                implementation = "prefer_rust_with_warning"
            },
        },
        { "sphamba/smear-cursor.nvim",
            opts = {
                stiffness = 0.8,
                trailing_stiffness = 0.5,
                stiffness_insert_mode = 0.7,
                trailing_stiffness_insert_mode = 0.7,
                damping = 0.8,
                damping_insert_mode = 0.8,
                distance_stop_animating = 0.5
            }
        },
        { "windwp/nvim-autopairs", opts = {} }
    },
    checker = { enabled = true },
})
