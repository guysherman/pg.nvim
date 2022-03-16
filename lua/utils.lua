local utils = {}

function utils.path_join(parts, sep)
    local path = table.concat(parts, sep)
    local cleaner_path = path:gsub('//+', '/')
    return cleaner_path
end


return utils
