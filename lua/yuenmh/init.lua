if require('yuenmh.packer') then
    require('yuenmh.remap')
    require('yuenmh.set')
    require('yuenmh.configure_plugins')
    require('yuenmh.colors')
else
    print("Failed to load packer, skipped loading plugins")
end
