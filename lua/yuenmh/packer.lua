-- bootstrapping snippet from https://github.com/wbthomason/packer.nvim#bootstrapping
local ensure_packer = function()
    local fn = vim.fn
    local install_path = fn.stdpath('data') .. '/site/pack/packer/start/packer.nvim'
    if fn.empty(fn.glob(install_path)) > 0 then
        fn.system({ 'git', 'clone', '--depth', '1', 'https://github.com/wbthomason/packer.nvim', install_path })
        vim.cmd.packadd('packer.nvim')
        return true
    end
    return false
end

local packer_bootstrap = ensure_packer()

vim.cmd.packadd('packer.nvim')

require('packer').startup(function(use)
    -- Packer can manage itself
    use 'wbthomason/packer.nvim'

    use {
        'nvim-telescope/telescope.nvim',
        tag = '0.1.1', requires = { { 'nvim-lua/plenary.nvim' } }
    }

    use 'folke/tokyonight.nvim'

    use {
        'nvim-treesitter/nvim-treesitter',
        run = ':TSUpdate',
        -- This might not actually be necessary
        -- commit = 'a82501244a',
    }

    use 'nvim-treesitter/playground'

    use 'theprimeagen/harpoon'

    use 'mbbill/undotree'

    use 'tpope/vim-fugitive'

    use {
        'VonHeikemen/lsp-zero.nvim',
        branch = 'v2.x',
        requires = {
            -- LSP Support
            { 'neovim/nvim-lspconfig' }, -- Required
            {
                -- Optional
                'williamboman/mason.nvim',
                run = function()
                    pcall(vim.cmd, 'MasonUpdate')
                end,
            },
            { 'williamboman/mason-lspconfig.nvim' }, -- Optional

            -- Autocompletion
            { 'hrsh7th/nvim-cmp' },     -- Required
            { 'hrsh7th/cmp-nvim-lsp' }, -- Required
            { 'L3MON4D3/LuaSnip' },     -- Required
        }
    }

    use {
        "zbirenbaum/copilot.lua",
        cmd = "Copilot",
        event = "InsertEnter",
        config = function()
            require("copilot").setup({
                panel = {
                    enabled = false,
                },
                suggestion = {
                    enabled = true,
                    auto_trigger = true,
                    debounce = 25,
                    keymap = {
                        accept = false,
                        accept_word = false,
                        accept_line = false,
                        next = false,
                        prev = false,
                        dismiss = false,
                    },
                },
                filetypes = {
                    gitcommit = false,
                    gitrebase = false,
                    ["*"] = true,
                },
                copilot_node_command = '/usr/bin/node', -- Node.js version must be > 16.x
                server_opts_overrides = {},
            })
            require("yuenmh.remap").copilot()
        end,
    }

    use 'nvim-treesitter/nvim-treesitter-context'

    use {
        'nvim-lualine/lualine.nvim',
        requires = { 'nvim-tree/nvim-web-devicons', opt = true }
    }

    -- Local plugins
    -- use {
    --     "/home/evan/source/handian.nvim",
    --     requires = {
    --         "nvim-lua/plenary.nvim",
    --         "kkharji/sqlite.lua",
    --     },
    --     config = function()
    --         local handian = require("handian")
    --         handian.setup({
    --             global_command = true,
    --         })
    --     end
    -- }

    -- put all plugins before this
    -- for bootstrapping
    if packer_bootstrap then
        require('packer').sync()
    end
end)

return not packer_bootstrap
