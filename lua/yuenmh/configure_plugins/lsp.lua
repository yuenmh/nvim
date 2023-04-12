local lsp = require('lsp-zero')
local cmp = require('cmp')

-- Don't know why this causes colors to change
lsp.preset('recommended')

lsp.ensure_installed({
    'lua_ls',
    'rust_analyzer',
})

local cmp_select = { behavior = cmp.SelectBehavior.Select }
cmp.setup({
    -- no idea what this does
    preselect = 'item',
    completion = {
        completeopt = 'menu,menuone,noinsert'
    },
    mapping = {
        ['<C-k>'] = cmp.mapping.select_prev_item(cmp_select),
        ['<C-j>'] = cmp.mapping.select_next_item(cmp_select),
        ['<Tab>'] = cmp.mapping.confirm({ select = true }),
        ['<C-space>'] = cmp.mapping.complete(),
    },
    sources = {
        { name = 'path' },
        { name = 'nvim_lsp' },
        { name = 'nvim_lua' },
        -- { name = 'buffer',  keyword_length = 3 },
        { name = 'luasnip', keyword_length = 2 },
    },
})

lsp.set_preferences({
    -- don't know what this does
    sign_icons = {}
})

lsp.on_attach(function(_, bufnr)
    lsp.buffer_autoformat()

    local opts = { buffer = bufnr, remap = false }

    vim.keymap.set("n", "gd", function() vim.lsp.buf.definition() end, opts)
    vim.keymap.set("n", "gh", function() vim.lsp.buf.hover() end, opts)
    -- I don't see any advantages of this over hover()
    -- vim.keymap.set("n", "gh", function() vim.lsp.buf.signature_help() end, opts)
    vim.keymap.set("n", "<leader>ca", function() vim.lsp.buf.code_action() end, opts)
    vim.keymap.set("n", "<leader>rn", function() vim.lsp.buf.rename() end, opts)
end)

require('lspconfig').lua_ls.setup {
    settings = {
        Lua = {
            diagnostics = {
                globals = { 'vim' }
            }
        }
    }
}

lsp.setup()
