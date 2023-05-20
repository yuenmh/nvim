local lazypath = vim.fn.stdpath('data') .. '/lazy/lazy.nvim'
if not vim.loop.fs_stat(lazypath) then
    vim.fn.system({
        'git',
        'clone',
        '--filter=blob:none',
        'https://github.com/folke/lazy.nvim.git',
        '--branch=stable', -- latest stable release
        lazypath,
    })
end
vim.opt.rtp:prepend(lazypath)
require('lazy').setup(require('yuenmh.plugins').plugins(), {})

local remap = require('yuenmh.remap')
remap.global()
require('yuenmh.set')
require('yuenmh.configure_plugins')
require('yuenmh.colors')

---Reload module
---@param mod string
---@return unknown
function R(mod)
    package.loaded[mod] = nil
    local module = require(mod)
    return module
end

---Print table
---@param table table
---@return table
function P(table)
    print(vim.inspect(table))
    return table
end
