
require("prisma/packages/print")

love.graphics.setDefaultFilter("nearest", "nearest")

_G.prisma = {
    Colour = require("prisma/math/colour"),
    Vector2 = require("prisma/math/vector2"),
    Concord = require("prisma/packages/concord"),
    Components = {},
    Systems = {}
}
prisma.Concord.utils.loadNamespace("components", prisma.Components)
prisma.Concord.utils.loadNamespace("systems", prisma.Systems)

function requireDir(path)
    local files = {}
    local items = love.filesystem.getDirectoryItems(path)
    for _, file in ipairs(items) do
        local filePath = path .. "/" .. file
        if love.filesystem.getInfo(filePath).type == "file" and file:sub(-4) == ".lua" then
            local moduleName = file:sub(1, -5)

            local requirePath = path:gsub("/", ".") .. "." .. moduleName
            files[moduleName] = require(requirePath)
        end
    end
    return files
end

for name,value in pairs(requireDir("prisma/services")) do
    name = (name:gsub("^%l", string.upper))
    prisma[name] = value
end

function love.update(dt)
    for name, data in pairs(prisma.Scenes.Scenes) do
        if data.Active then
            data.Workspace:emit("update", dt)
        end
    end

    prisma.Time:tick(dt)
end

function love.draw()
    for name, data in pairs(prisma.Scenes.Scenes) do
        if data.Active then
            data.Workspace:emit("draw")
        end
    end

    prisma.Debug:DrawStats()
end

return prisma