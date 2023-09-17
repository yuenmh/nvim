local M = {}

---@param name string
---@return string | nil
function M.find_binary(name)
    local result = ""
    local handle = io.popen(table.concat({ 'which', name }, ' '))
    if handle ~= nil then
        result = handle:read("*a")
    end
    if result == "" then
        return nil
    else
        return result
    end
end

-- Returns the plugin spec
function M.plugins()
    return {
        {
            'nvim-treesitter/nvim-treesitter',
            lazy = false,
            config = function()
                require('yuenmh.plugin_config.treesitter').setup()
            end,
        },
        'nvim-treesitter/playground',
        {
            'theprimeagen/harpoon',
            keys = {
                { '<leader>a', function() require('harpoon.mark').add_file() end,        desc = '[a]dd file', },
                { '<leader>e', function() require('harpoon.ui').toggle_quick_menu() end, desc = '[e]xplorer', },
                { '<leader>1', function() require('harpoon.ui').nav_file(1) end,         desc = 'tab [1]', },
                { '<leader>2', function() require('harpoon.ui').nav_file(2) end,         desc = 'tab [2]', },
                { '<leader>3', function() require('harpoon.ui').nav_file(3) end,         desc = 'tab [3]', },
                { '<leader>4', function() require('harpoon.ui').nav_file(4) end,         desc = 'tab [4]', },
                { '<leader>5', function() require('harpoon.ui').nav_file(5) end,         desc = 'tab [5]', },
            },
            config = function()
                require('harpoon').setup({})
            end,
        },
        'mbbill/undotree',
        'tpope/vim-fugitive',
        'nvim-treesitter/nvim-treesitter-context',
        {
            'nvim-telescope/telescope.nvim',
            tag = '0.1.1',
            dependencies = { 'nvim-lua/plenary.nvim' },
            cmd = 'Telescope',
            keys = {
                {
                    '<leader>pf',
                    function() require('telescope.builtin').find_files() end,
                    desc = '[p]roject [f]iles',
                },
                {
                    '<leader>pg',
                    function() require('telescope.builtin').live_grep() end,
                    desc = '[p]roject [g]rep',
                },
                {
                    '<leader>ps',
                    function() require('telescope.builtin').lsp_workspace_symbols() end,
                    desc = '[p]roject [s]ymbols',
                },
                {
                    '<leader>pd',
                    function() require('telescope.builtin').diagnostics() end,
                    desc = '[p]roject [d]iagnostics',
                },
                {
                    '<leader>ds',
                    function() require('telescope.builtin').lsp_document_symbols() end,
                    desc = '[d]ocument [s]ymbols',
                },
                {
                    '<leader>gr',
                    function() require('telescope.builtin').lsp_references() end,
                    desc = '[g]oto [r]eferences',
                },
                {
                    '<leader>gd',
                    function() require('telescope.builtin').lsp_definitions() end,
                    desc = '[g]oto [d]efinitions',
                },
            },
            config = function()
                require('telescope').setup {
                    defaults = {
                        mappings = {
                            n = {
                                ['<leader>qf'] = function(bufnr)
                                    require('telescope.actions').send_to_qflist(bufnr)
                                    vim.cmd('copen')
                                end,
                            },
                        },
                    },
                }
            end,
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
            },
            lazy = false,               -- TODO try to make this one lazily loaded
            config = function()
                require('yuenmh.plugin_config.lsp').setup()
            end,
        },
        {
            "zbirenbaum/copilot.lua",
            cmd = "Copilot",
            event = "InsertEnter",
            lazy = false, -- TODO make copilot lazily loaded on certain file types
            keys = {
                {
                    '<C-j>',
                    mode = 'i',
                    function() require('copilot.suggestion').accept() end,
                    desc = 'accept copilot suggestion',
                },
                {
                    '<C-l>',
                    mode = 'i',
                    function() require('copilot.suggestion').accept_word() end,
                    desc = 'accept 1 word from copilot suggestion',
                },
            },
            config = function()
                -- Check if node exists because copilot is not necessary
                -- TODO: Add checks for if Node.js version > 16.x
                local node_path = M.find_binary("node")
                if node_path == nil then
                    vim.notify('Node binary not found: Copilot disabled.')
                    return
                end

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
                    copilot_node_command = node_path,
                    server_opts_overrides = {},
                })
            end,
        },
        {
            'jose-elias-alvarez/null-ls.nvim',
            requires = 'nvim-lua/plenary.nvim',
            lazy = false,
            config = function()
                local null_ls = require('null-ls')
                null_ls.setup({
                    sources = {
                        null_ls.builtins.formatting.prettierd,
                        null_ls.builtins.formatting.ocamlformat,
                    },
                })
            end,
        },

        -- Cosmetic stuff
        {
            'folke/tokyonight.nvim',
            lazy = false,
            priority = 1000,
            config = function()
                require('yuenmh.colors').set_with_transparent_background("tokyonight")
            end,
        },
        {
            'nvim-lualine/lualine.nvim',
            lazy = false,
            config = function() require('yuenmh.plugin_config.lualine').setup() end,
        },
        -- 'nvim-tree/nvim-web-devicons', -- Not using because I can't find a Nerd Font that I like
        {
            'j-hui/fidget.nvim',
            lazy = false,
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
            end,
        },
    }
end

return M
