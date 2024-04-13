local M = {}

---@class FiletypeAssociation
---@field pattern string[] | string
---@field filetype string

-- Associate a filetype with a file pattern
---@param assoc FiletypeAssociation
function M.associate(assoc)
    vim.api.nvim_create_autocmd({ 'BufRead', 'BufEnter' }, {
        pattern = assoc.pattern,
        group = vim.api.nvim_create_augroup('yuenmh-filetype-' .. assoc.filetype, { clear = true }),
        callback = function()
            vim.bo.filetype = assoc.filetype
        end,
    })
end

return M
