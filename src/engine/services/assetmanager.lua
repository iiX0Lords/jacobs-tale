

local instance = require("engine.instances.instance")

local assetmanager = {}
assetmanager.__index = assetmanager
setmetatable(assetmanager, instance)
assetmanager.new = nil

function assetmanager.LoadImage(path)
    local exists = love.filesystem.getInfo(path)
    if exists then
        return love.graphics.newImage(path)
    end
    return nil
end

function assetmanager.AttemptRequire(path)
    local exists = love.filesystem.getInfo(path)
    if exists then
        if exists.type ~= "file" then return nil end
        local lua = string.find(path, ".lua")
        if not lua then return nil end
        local stripped = string.sub(path, 0, lua - 1)
        return require(stripped)
    end
    return nil
end

return assetmanager