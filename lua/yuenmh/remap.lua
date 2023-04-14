M = {}

function M.global()
    vim.g.mapleader = ' '
    vim.keymap.set('n', '<leader>pv', vim.cmd.Explore, { desc = "[p]roject [v]iew" })

    -- move selected lines up and down
    vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv")
    vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv")

    -- keep cursor centered when jumping half page
    vim.keymap.set("n", "<C-d>", "<C-d>zz")
    vim.keymap.set("n", "<C-u>", "<C-u>zz")

    -- same thing but searching
    vim.keymap.set("n", "n", "nzzzv")
    vim.keymap.set("n", "N", "Nzzzv")

    -- paste fix
    -- vim.keymap.set("x", "<leader>p", "\"_dP")

    -- disabling stuff I don't use
    vim.keymap.set("n", "Q", "<nop>")
end

-- Plugin specific keymaps

function M.copilot()
    local suggestion = require("copilot.suggestion")
    vim.keymap.set("i", "<C-j>", suggestion.accept, { desc = "accept copilot suggestion" })
    vim.keymap.set("i", "<C-l>", suggestion.accept_word, { desc = "accept word from copilot suggestion" })
end

function M.harpoon()
    local mark = require("harpoon.mark")
    local ui = require("harpoon.ui")

    vim.keymap.set("n", "<leader>a", mark.add_file)
    vim.keymap.set("n", "<leader>e", ui.toggle_quick_menu)

    vim.keymap.set("n", "<leader>1", function() ui.nav_file(1) end)
    vim.keymap.set("n", "<leader>2", function() ui.nav_file(2) end)
    vim.keymap.set("n", "<leader>3", function() ui.nav_file(3) end)
    vim.keymap.set("n", "<leader>4", function() ui.nav_file(4) end)
    vim.keymap.set("n", "<leader>5", function() ui.nav_file(5) end)
end

function M.telescope()
    local builtin = require('telescope.builtin')
    vim.keymap.set('n', '<leader>pf', builtin.find_files, { desc = "[p]roject [f]iles" })
    vim.keymap.set('n', '<leader>pg', builtin.git_files, { desc = "[p]roject [g]it files" })
    vim.keymap.set('n', '<leader>ps', builtin.lsp_workspace_symbols, { desc = "[p]roject [s]ymbols" })
    vim.keymap.set('n', '<leader>ds', builtin.lsp_document_symbols, { desc = "[d]ocument [s]ymbols" })
end

function KeymapReload()
    for _, plugin in pairs(M) do
        if type(plugin) == "function" then
            plugin()
        end
        print("Reloaded keymaps for " .. _)
    end
end

vim.api.nvim_create_user_command("KeymapReload", "lua KeymapReload()", {})

return M
