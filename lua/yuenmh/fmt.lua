local M = {}

--- @param formatter_specs (string | string[])[]
function M.first(formatter_specs)
    --- @param bufnr number
    local function f(bufnr)
        local formatters = {}
        for _, formatter_spec in ipairs(formatter_specs) do
            if type(formatter_spec) == 'string' then
                table.insert(formatters, formatter_spec)
            else
                local formatter_to_use = nil
                for _, formatter in ipairs(formatter_spec) do
                    if require('conform').get_formatter_info(formatter, bufnr).available then
                        formatter_to_use = formatter
                        break
                    end
                end
                formatter_to_use = formatter_to_use or formatter_spec[#formatter_spec]
                table.insert(formatters, formatter_to_use)
            end
        end
        return formatters
    end
    return f
end

return M
