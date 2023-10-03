local M = {}

function M.setup()
    local lsp = require('lsp-zero')
    local cmp = require('cmp')

    -- Don't know why this causes colors to change
    lsp.preset('recommended')

    lsp.ensure_installed({
        'lua_ls',
    })

    local cmp_select = { behavior = cmp.SelectBehavior.Select }
    cmp.setup({
        -- no idea what this does
        preselect = 'item',
        completion = {
            completeopt = 'menu,menuone,noinsert'
        },
        mapping = {
            ['<Tab>'] = cmp.mapping.confirm({ select = true }),
            ['<C-space>'] = cmp.mapping.complete(),
            ['<C-e>'] = cmp.mapping.close(),
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
        local group = vim.api.nvim_create_augroup('FormatOnSave', { clear = true })
        vim.api.nvim_create_autocmd('BufWritePre', {
            callback = function()
                vim.lsp.buf.format({
                    filter = function(client)
                        return (
                            client.name ~= 'tsserver'
                            and vim.bo.filetype ~= 'tex'
                        )
                    end
                })
            end,
            group = group,
        })

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
                runtime = {
                    version = 'LuaJIT',
                },
                diagnostics = {
                    globals = { 'vim' }
                },
                workspace = {
                    -- Make the server aware of Neovim runtime files
                    library = vim.api.nvim_get_runtime_file("", true),
                    -- https://github.com/LuaLS/lua-language-server/wiki/Settings#workspacecheckthirdparty
                    -- This should stop it from always asking or generating .luarc.json files
                    checkThirdParty = false,
                },
            }
        }
    }

    require('lspconfig').ocamllsp.setup({})

    if require('yuenmh.plugins').find_binary('tailwindcss-language-server') ~= nil then
        require('lspconfig').tailwindcss.setup({
            settings = {
                tailwindCSS = {
                    experimental = {
                        classRegex = {
                            "\\/\\*\\s*@tw\\s*\\*\\/\\s*['\"]([^'\"]+)['\"]",
                        }
                    }
                }
            }
        })
    end

    lsp.setup()
end

return M
