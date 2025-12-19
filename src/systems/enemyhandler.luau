local enemyHandler = prisma.Concord.system({
    pool = {"Enemy", "Transform", "Renderer", "Physics"},
    player = {"Player"}
})

local player = nil
local World = nil
local collisionSystem = nil

local function getLookVector(a, b)
    local ax, ay = a.x, a.y
    local bx, by = b.x, b.y
    local dx, dy = bx - ax, by - ay
    local len = math.sqrt(dx*dx + dy*dy)
    if len == 0 then return 0, 0 end
    return prisma.Vector2.new(dx / len, dy / len)
end


function enemyHandler:update(dt)
    for _, plr in ipairs(self.player) do
        player = plr
    end

    for _, entity in ipairs(self.pool) do
        if entity.Player ~= nil then continue end
        if player == nil then continue end

        local toPlayerVector = player.Transform.Position - entity.Transform.Position

        local distX = math.abs(toPlayerVector.x)
        local distY = math.abs(toPlayerVector.y)
        local attackRange = 65
        local speed = entity.Enemy.Speed

        local vx, vy = 0, 0

        if distX > attackRange then
            vx = (toPlayerVector.x / distX) * speed
        end

        if distY > attackRange then
            vy = (toPlayerVector.y / distY) * speed
        end

        entity.Physics.Velocity = prisma.Vector2.new(vx, vy)
    end
end

function enemyHandler:init(world)
    World = world
    collisionSystem = world:getSystem(prisma.Systems.collisionsystem)
end

return enemyHandler