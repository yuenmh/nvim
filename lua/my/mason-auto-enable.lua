local M = {}

local mason_registry = require 'mason-registry'

--- support all the functionality I actually want from mason-lspconfig without the large dependency
function M.setup()
    local mason_to_lspconfig = {}
    for _, spec in ipairs(mason_registry.get_all_package_specs()) do
        local mason_name = spec.name
        local lspconfig_name = vim.tbl_get(spec, 'neovim', 'lspconfig')
        if lspconfig_name then
            mason_to_lspconfig[mason_name] = lspconfig_name
        end
    end
    for _, mason_package in ipairs(mason_registry.get_installed_package_names()) do
        local lspconfig_name = mason_to_lspconfig[mason_package]
        if lspconfig_name then
            vim.lsp.enable(lspconfig_name)
        end
    end
end

return M
