local M = {}

local is_open = false

--- opens a centered floating window and dims the background
---@param opts { lines: string[], cb: fun(edited_lines: string[]) }
local function open_edit_window(opts)
    if is_open then
        vim.notify('bookmarks window is already open', vim.log.levels.WARN)
        return
    end
    is_open = true
    local buf = vim.api.nvim_create_buf(false, true)
    vim.api.nvim_buf_set_lines(buf, 0, -1, false, opts.lines)
    local width = math.floor(vim.o.columns * 0.6)
    local height = math.floor(vim.o.lines * 0.3)
    local row = math.floor((vim.o.lines - height) / 2)
    local col = math.floor((vim.o.columns - width) / 2)

    local float_zindex = 50
    local backdrop_hl = 'BookmarksBackdrop'

    local backdrop_buf = vim.api.nvim_create_buf(false, true)
    local back_winnr = vim.api.nvim_open_win(backdrop_buf, true, {
        relative = 'editor',
        width = vim.o.columns,
        height = vim.o.lines,
        row = 0,
        col = 0,
        style = 'minimal',
        border = 'none',
        zindex = float_zindex - 1,
        focusable = false,
    })
    vim.api.nvim_set_hl(0, backdrop_hl, { bg = '#000000', default = true })
    vim.wo[back_winnr].winblend = 60
    vim.wo[back_winnr].winhighlight = 'Normal:' .. backdrop_hl

    local main_winnr = vim.api.nvim_open_win(buf, true, {
        relative = 'editor',
        width = width,
        height = height,
        row = row,
        col = col,
        style = 'minimal',
        border = 'none',
        zindex = float_zindex,
    })
    vim.wo[main_winnr].winhighlight = 'Normal:NormalFloat'
    vim.wo[main_winnr].winblend = 0
    vim.wo[main_winnr].number = true
    vim.wo[main_winnr].relativenumber = false

    vim.keymap.set('n', '<Esc>', function()
        vim.api.nvim_win_close(0, true)
    end, { buffer = buf, desc = 'Close Hello World Window' })
    vim.api.nvim_create_autocmd({ 'BufLeave' }, {
        buffer = buf,
        callback = function()
            local edited_text = vim.api.nvim_buf_get_lines(buf, 0, -1, false)
            vim.api.nvim_win_close(back_winnr, true)
            vim.api.nvim_buf_delete(buf, { force = true })
            vim.api.nvim_buf_delete(backdrop_buf, { force = true })
            is_open = false
            opts.cb(edited_text)
        end,
    })
end

function M.setup()
end

function M.edit_bookmarks()
    open_edit_window {
        lines = { 'file1', 'file2' },
        cb = function(edited_text)
            print('edited bookmarks:', vim.inspect(edited_text))
        end,
    }
end

return M
