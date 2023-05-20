local M = {}

-- Returns the plugin spec
function M.plugins()
    return {
        'nvim-treesitter/nvim-treesitter',
        'nvim-treesitter/playground',
        'theprimeagen/harpoon',
        'mbbill/undotree',
        'tpope/vim-fugitive',
        'nvim-treesitter/nvim-treesitter-context',
        {
            'nvim-telescope/telescope.nvim',
            tag = '0.1.1',
            dependencies = { 'nvim-lua/plenary.nvim' }
        },

        -- LSP
        {
            'VonHeikemen/lsp-zero.nvim',
            branch = 'v2.x',
            dependencies = {
                -- LSP Support
                'neovim/nvim-lspconfig',             -- Required
                'williamboman/mason.nvim',           -- Optional
                'williamboman/mason-lspconfig.nvim', -- Optional

                -- Autocompletion
                'hrsh7th/nvim-cmp',     -- Required
                'hrsh7th/cmp-nvim-lsp', -- Required
                'L3MON4D3/LuaSnip',     -- Required
            }
        },
        {
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
        },


        -- Cosmetic stuff
        {
            'folke/tokyonight.nvim',
            lazy = false,
            priority = 1000,
            config = function()
                require('yuenmh.colors').set_with_transparent_background("tokyonight")
            end
        },
        'nvim-lualine/lualine.nvim',
        -- 'nvim-tree/nvim-web-devicons', -- Not using because I can't find a Nerd Font that I like
        {
            'j-hui/fidget.nvim',
            config = function()
                require("fidget").setup({
                    text = {
                        spinner = "moon",
                    },
                    window = {
                        blend = 0,
                        -- border = "rounded",
                    }
                })
            end
        },
    }
end

return M
