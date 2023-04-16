---Set the color scheme and then make the background transparent
---@param color string
function ColorMyPencils(color)
    vim.cmd.colorscheme(color)
    vim.api.nvim_set_hl(0, "Normal", { bg = "none" })
    -- vim.api.nvim_set_hl(0, "NormalFloat", { bg = "none" })
    vim.api.nvim_set_hl(0, "NormalNC", { bg = "none" })
    -- vim.api.nvim_set_hl(0, "StatusLine", { bg = "none" })
    vim.api.nvim_set_hl(0, "SignColumn", { bg = "none" })
end

vim.api.nvim_create_user_command("ColorMyPencils", "lua ColorMyPencils(<f-args>)", { nargs = 1 })

ColorMyPencils("tokyonight")
