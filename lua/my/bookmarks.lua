local M = {}

---@class Config
---@field project_root_files string[] list of files to identify project root, e.g. .git, Cargo.toml, etc. Set to an empty list to disable this behavior and just use CWD instead.

local state = {
    ---@type Config
    config = {
        project_root_files = { ".git" }
    },
    is_open = false
}


--- opens a centered floating window and dims the background
---@param opts { lines: string[], cb: fun(edited_lines: string[]) }
local function open_edit_window(opts)
    if state.is_open then
        vim.notify('bookmarks window is already open', vim.log.levels.WARN)
        return
    end
    state.is_open = true
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
            state.is_open = false
            opts.cb(edited_text)
        end,
    })
end


local function get_project_dir()
    return vim.fs.root(0, state.config.project_root_files) or vim.fn.getcwd()
end

local function plugin_path()
    return vim.fs.joinpath(vim.fn.stdpath('data'), 'bookmarks')
end

---@param project_dir string
local function state_file(project_dir)
    return vim.fs.joinpath(plugin_path(), project_dir:gsub('/', '%%') .. '.json')
end

---@class State
---@field bookmarks string[] list of bookmarked files (relative to project root)

local function empty_state()
    return { bookmarks = {} }
end

---@param opts {project_dir: string}
---@return State
local function load_state(opts)
    local file = io.open(state_file(opts.project_dir), "r")
    if not file then return empty_state() end
    local content = file:read("*a")
    file:close()
    if not content or content == '' then return empty_state() end
    return vim.json.decode(content)
end

---@param opts {project_dir: string, state: State}
local function save_state(opts)
    local file = io.open(state_file(opts.project_dir), "w")
    if not file then
        vim.notify('Failed to save bookmarks state', vim.log.levels.ERROR)
        return
    end
    file:write(vim.json.encode(opts.state))
    file:close()
end

---Configure the plugin. The provided config is merged with the default config.
---@param config Config | nil
function M.setup(config)
    if vim.fn.isdirectory(plugin_path()) == 0 then
        vim.fn.mkdir(plugin_path(), 'p')
    end
    if config == nil then return end
    state.config = vim.tbl_deep_extend('force', config, config)
end

function M.edit_bookmarks()
    local project_dir = get_project_dir()
    open_edit_window {
        lines = load_state { project_dir = project_dir }.bookmarks,
        cb = function(edited_text)
            save_state {
                project_dir = project_dir,
                state = {
                    bookmarks = vim.iter(edited_text)
                        :map(function(line) return line:match("^%s*(.-)%s*$") end)
                        :filter(function(line) return line ~= '' end)
                        :totable()
                },
            }
        end,
    }
end

---Add the buffer to the bookmarks list. If not specified, adds the current buffer (bufnr 0).
---@param bufnr integer | nil
function M.add_buffer(bufnr)
    local project_dir = get_project_dir()
    local st = load_state { project_dir = project_dir }
    local buf_path = vim.fs.relpath(get_project_dir(), vim.api.nvim_buf_get_name(bufnr or 0))
    assert(buf_path ~= nil)
    if not vim.list_contains(st.bookmarks, buf_path) then
        vim.notify('Added ' .. buf_path .. ' to bookmarks')
        vim.list_extend(st.bookmarks, { buf_path })
    else
        vim.notify(buf_path .. ' is already in bookmarks', vim.log.levels.INFO)
    end
    save_state { project_dir = project_dir, state = st }
end

---@param number integer The bookmark index to jump to (starts with 1)
function M.jump_to_boookmark(number)
    local st = load_state { project_dir = get_project_dir() }
    local path = st.bookmarks[number]
    if path == nil then
        vim.notify('No bookmark found at index ' .. number, vim.log.levels.ERROR)
        return
    end
    vim.cmd.edit(vim.fs.joinpath(get_project_dir(), path))
    local mark = vim.api.nvim_buf_get_mark(0, '"')
    local lcount = vim.api.nvim_buf_line_count(0)
    if mark[1] > 0 and mark[1] <= lcount then
        pcall(vim.api.nvim_win_set_cursor, 0, mark)
    end
end

return M
