vim.loader.enable()
vim.o.number = true
vim.o.title = true
vim.o.tabstop = 4
vim.o.softtabstop = 4
vim.o.shiftwidth = 4
vim.o.shiftround = true
vim.o.expandtab = true
vim.o.swapfile = false
vim.o.autoread = true
vim.o.incsearch = true
vim.o.smartindent = true
vim.o.scrolloff = 5
vim.o.sidescrolloff = 5
vim.o.mouse = ""
vim.o.hlsearch = false
vim.o.termguicolors = true
vim.o.guicursor = "i:ver100-blinkon500-blinkoff500"
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
vim.api.nvim_create_autocmd({ "InsertLeave", "CmdlineLeave" }, {
    callback = function()
        vim.fn.jobstart({ "fcitx5-remote", "-c" }, { detach = true })
    end
})

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
        {
            "rmehri01/onenord.nvim",
            event = "VimEnter",
            opts = {}
        },

        {
            "nvim-lualine/lualine.nvim",
            event = "VimEnter",
            opts = {}
        },

        {
            "sphamba/smear-cursor.nvim",
            event = "VeryLazy",
            opts = {
                trailing_stiffness = 0.5,
                stiffness_insert_mode = 0.7,
                trailing_stiffness_insert_mode = 0.7,
                damping = 0.8,
                damping_insert_mode = 0.8,
                distance_stop_animating = 0.5
            }
        },

        {
            "karb94/neoscroll.nvim",
            event = "VeryLazy",
            opts = {}
        },

        {
            "johnfrankmorgan/whitespace.nvim",
            event = {
                "BufReadPost",
                "BufNewFile"
            },
            opts = {}
        },

        {
            "norcalli/nvim-colorizer.lua",
            event = {
                "BufReadPost",
                "BufNewFile"
            },
            opts = {
                "*",
                css = { rgb_fn = true }
            }
        },

        {
            "RRethy/vim-illuminate",
            event = {
                "BufReadPost",
                "BufNewFile"
            },
            main = "illuminate"
        },

        {
            "folke/which-key.nvim",
            event = "VeryLazy"
        },

        {
            "mvllow/modes.nvim",
            event = "VeryLazy",
            opts = {}
        },

        {
            "Saghen/blink.cmp",
            version = not vim.g.lazyvim_blink_main and "*",
            build = vim.g.lazyvim_blink_main and "cargo build --release",
            event = {
                "InsertEnter",
                "CmdlineEnter"
            },
            dependencies = {
                "L3MON4D3/LuaSnip",
                version = "v2.*",
                build = "make install_jsregexp",
                dependencies = { "rafamadriz/friendly-snippets" }
            },
            opts = {
                completion = {
                    documentation = {
                        auto_show = true,
                        window = { border = "rounded" }
                    },
                    menu = { border = "rounded" }
                },
                keymap = {
                    preset = "enter",
                    ["<C-y>"] = { "accept", "fallback" }
                },
                sources = {
                    default = {
                        "lsp",
                        "path",
                        "snippets",
                        "buffer"
                    }
                }
            }
        },

        {
            "Saghen/blink.pairs",
            event = {
                "BufReadPost",
                "BufNewFile"
            },
            build = "cargo build --release",
            opts = {}
        },

        {
            "Saghen/blink.indent",
            event = {
                "BufReadPost",
                "BufNewFile"
            },
            opts = {}
        },

        {
            "mason-org/mason-lspconfig.nvim",
            dependencies = {
                {
                    "mason-org/mason.nvim",
                    opts = {}
                },
                "neovim/nvim-lspconfig"
            },
            opts = {
                ensure_installed = {
                    "clangd",
                    "cssls",
                    "html",
                    "lua_ls",
                    "pyright"
                }
            }
        }
    },
    checker = { enabled = true }
})
