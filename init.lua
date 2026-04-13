vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

vim.g.have_nerd_font = true

vim.g.terminal_command = 'fish'

vim.opt.termguicolors = true

vim.opt.mouse = 'a'

vim.opt.number = true
vim.opt.relativenumber = true

vim.opt.tabstop = 4
vim.opt.softtabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true
vim.opt.smartindent = true

-- command for when I typo ':w'
vim.api.nvim_create_user_command('Write', function() vim.cmd.write() end, {})

-- standard behavior keeps highlight after searching
vim.opt.hlsearch = true
vim.keymap.set('n', '<Esc>', function() vim.cmd.nohlsearch() end)

-- diagnostics
vim.opt.signcolumn = 'yes' -- horrible jumping when diagnostics appear and disappear
vim.diagnostic.config {
    virtual_text = true,
    signs = true,
    underline = true,
    update_in_insert = true,
    severity_sort = true,
}
vim.keymap.set('n', 'gl', vim.diagnostic.open_float, { desc = 'Open Float' })

---@param src string
local function gh(src) return 'https://github.com/' .. src end

vim.pack.add { gh 'folke/tokyonight.nvim' }
vim.cmd.colorscheme 'tokyonight-night'

vim.pack.add { gh 'neovim/nvim-lspconfig', gh 'mason-org/mason.nvim' }
require 'mason'.setup()

vim.lsp.enable 'lua_ls'
vim.lsp.enable 'rust_analyzer'
vim.lsp.enable 'basedpyright'
vim.lsp.enable 'clangd'
vim.lsp.enable 'gopls'
vim.lsp.enable 'ts_ls'
vim.lsp.enable 'tinymist'

vim.lsp.config('rust_analyzer', {
    settings = {
        ['rust-analyzer'] = {
            check = {
                command = 'clippy',
            },
        },
    },
})

vim.lsp.config('basedpyright', {
    settings = {
        basedpyright = {
            analysis = {
                typeCheckingMode = 'standard',
                autoImportCompletions = true,
            },
        },
    },
})

vim.api.nvim_create_autocmd('LspAttach', {
    callback = function(event)
        vim.keymap.set('n', 'gh', vim.lsp.buf.hover, { buffer = event.buf, desc = 'LSP: Hover' })
        vim.keymap.set('n', '<leader>cn', vim.lsp.buf.rename, { buffer = event.buf, desc = 'LSP: Rename' })
        vim.keymap.set('n', '<leader>ca', require 'fzf-lua'.lsp_code_actions,
            { buffer = event.buf, desc = 'LSP: Code Actions' })
    end
})

vim.api.nvim_create_autocmd('BufWritePre', {
    callback = function()
        vim.lsp.buf.format { async = true }
    end
})

vim.pack.add { { src = gh 'saghen/blink.cmp', version = 'v1' } }
require 'blink.cmp'.setup {
    keymap = {
        preset = 'default',
        ['<Tab>'] = { 'snippet_forward', 'accept', 'fallback' },
    },
    sources = { default = { 'lsp', 'path', 'buffer' } },
    completion = {
        documentation = { auto_show = true }
    }
}

vim.pack.add { gh 'ibhagwan/fzf-lua' }
require 'fzf-lua'.setup {
    keymap = {
        fzf = {
            ["ctrl-u"] = 'half-page-up',
            ["ctrl-d"] = 'half-page-down',
        }
    },
    winopts = {
        border = 'none',
        preview = {
            border = 'none',
        },
    }
}
vim.keymap.set('n', '<leader>sf', require 'fzf-lua'.files, { desc = 'Search Files In CWD' })
vim.keymap.set('n', '<leader>/', require 'fzf-lua'.grep_curbuf, { desc = 'search current buffer' })
vim.keymap.set('n', '<leader>ds', require 'fzf-lua'.lsp_document_symbols, { desc = 'search current buffer' })

vim.pack.add { gh 'j-hui/fidget.nvim' }
require 'fidget'.setup {
    progress = {
        display = {
            progress_icon = {
                pattern = 'moon',
                period = 1,
            },
        },
    },
}

vim.pack.add { { src = gh 'nvim-treesitter/nvim-treesitter' } }
vim.api.nvim_create_autocmd('FileType', {
    callback = function()
        pcall(vim.treesitter.start)
        vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
    end,
})

vim.pack.add { gh 'stevearc/oil.nvim', gh 'nvim-mini/mini.icons' }
require 'mini.icons'.setup()
require 'oil'.setup {
    default_file_explorer = true,
    columns = {
        'icon'
    },
    lsp_file_methods = {
        autosave_changes = true,
    },
    view_options = {
        show_hidden = true,
    }
}
vim.keymap.set('n', '<leader>pv', require 'oil'.open, { desc = 'Open File Explorer' })

vim.pack.add { gh 'lewis6991/gitsigns.nvim' }
require 'gitsigns'.setup()

vim.pack.add { gh 'nvim-lualine/lualine.nvim', gh 'nvim-tree/nvim-web-devicons' }
require 'nvim-web-devicons'.setup()
require 'lualine'.setup {
    options = {
        icons_enabled = true,
        component_separators = { left = '', right = '' },
        section_separators = { left = '', right = '' },
    },
    sections = {
        lualine_a = {
            { 'mode', fmt = function(mode) return mode:sub(1, 1) end },
        },
        lualine_c = {
            { 'filename', path = 1 --[[Relative path]] },
        },
        lualine_x = {
            'encoding',
            'filetype',
        },
    },
}
