if require('yuenmh.packer') then
    local remap = require('yuenmh.remap')
    remap.global()
    require('yuenmh.set')
    require('yuenmh.configure_plugins')
    require('yuenmh.colors')
else
    print("Failed to load packer, skipped loading plugins")
end

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
