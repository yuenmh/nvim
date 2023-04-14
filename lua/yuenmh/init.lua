if require('yuenmh.packer') then
    local remap = require('yuenmh.remap')
    remap.global()
    require('yuenmh.set')
    require('yuenmh.configure_plugins')
    require('yuenmh.colors')
else
    print("Failed to load packer, skipped loading plugins")
end
