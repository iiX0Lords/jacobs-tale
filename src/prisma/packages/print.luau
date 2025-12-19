
local old_print = print

local function table_to_string(tbl, indent, visited)
    indent = indent or 0
    visited = visited or {}

    if visited[tbl] then
        return "<cycle to " .. tostring(tbl) .. ">"
    end
    visited[tbl] = true

    local formatting = string.rep("  ", indent)
    local result = "{\n"

    for k, v in pairs(tbl) do
        local format_k = formatting .. "  [" .. tostring(k) .. "] = "
        
        if type(v) == "table" then
            result = result .. format_k .. table_to_string(v, indent + 1, visited) .. ",\n"
        elseif type(v) == "string" then
            result = result .. format_k .. '"' .. v .. '",\n'
        else
            result = result .. format_k .. tostring(v) .. ",\n"
        end
    end

    return result .. formatting .. "}"
end

print = function(...)
    local args = {...}
    local str_args = {}
    
    for i, v in ipairs(args) do
        if type(v) == "table" then
            table.insert(str_args, table_to_string(v, 0, {}))
        else
            table.insert(str_args, tostring(v))
        end
    end
    
    old_print(unpack(str_args))
end