

local Instance = require('prisma.instances.instance')

--- @class AssetManager
local assetmanager = {}
assetmanager.__index = assetmanager
setmetatable(assetmanager, Instance)
assetmanager.new = nil

--- Attempts to load image using filepath
--- @param path string
function assetmanager.LoadImage(path)
    local exists = love.filesystem.getInfo(path)
    if exists then
        return love.graphics.newImage(path)
    end
    return nil
end

--- Attempts to require lua file at path
--- @param path string
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