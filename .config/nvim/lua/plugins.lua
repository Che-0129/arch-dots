vim.cmd.packadd "packer.nvim"
require("packer").startup(function()
    use {"wbthomason/packer.nvim", opt = true}
    use "nvim-lualine/lualine.nvim"
    use "rmehri01/onenord.nvim"
    use "neoclide/coc.nvim"
    use "windwp/nvim-autopairs"
    use "mcauley-penney/tidy.nvim"
    use "lukas-reineke/indent-blankline.nvim"
    use "Norcalli/nvim-colorizer.lua"
end)
