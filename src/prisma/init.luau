
_G.concord = require("prisma/packages/concord")

--- @class Prisma
_G.prisma = {
    Colour = require("prisma/math/colour"),
    Vector2 = require("prisma/math/vector2")
}
love.graphics.setDefaultFilter("nearest", "nearest")

prisma.components = {}
prisma.systems = {}
concord.utils.loadNamespace("prisma/components", prisma.components)
concord.utils.loadNamespace("prisma/systems", prisma.systems)

prisma.scenes = {}

function prisma.CreateScene(name)
    prisma.scenes[name] = {
        Active = false,
        Workspace = concord.world()
    }
    return prisma.scenes[name]
end

function love.update(dt)
    for name, data in pairs(prisma.scenes) do
        if data.Active then
            data.Workspace:emit("update", dt)
        end
    end
end

function love.draw()
    for name, data in pairs(prisma.scenes) do
        if data.Active then
            data.Workspace:emit("draw")
        end
    end

    local lua_mem = collectgarbage("count")
    
    love.graphics.setColor(1, 0, 0, 1)
    love.graphics.print(string.format("RAM:    %.2f MB", lua_mem / 1024), 20, 35)
    love.graphics.print(string.format("FPS:        %d", love.timer.getFPS()), 20, 50)
end

prisma.Camera = {
    Position = prisma.Vector2.new(0, 0),
    Zoom = 1,
}

return prisma