local playercontroller = concord.system({
    pool = {"Player", "Transform", "Physics"},
})

KEYBINDS = {
    Forward = {"w", "up"},
    Backward = {"s", "down"},
    Left = {"a", "left"},
    Right = {"d", "right"}
}

local World = nil
local collisionSystem = nil

function playercontroller.ProcessInput(entity, dt)
    local physics = entity.Physics
    if love.keyboard.isDown(KEYBINDS.Forward) then
        physics.Velocity.y = -(entity.Player.Speed * 10) * dt
    end
    if love.keyboard.isDown(KEYBINDS.Backward) then
        physics.Velocity.y = (entity.Player.Speed * 10) * dt
    end
    if love.keyboard.isDown(KEYBINDS.Left) then
        physics.Velocity.x = -(entity.Player.Speed * 10) * dt
    end
    if love.keyboard.isDown(KEYBINDS.Right) then
        physics.Velocity.x = (entity.Player.Speed * 10) * dt
    end
end

function playercontroller:update(dt)
    if World == nil then return end
    for _, entity in ipairs(self.pool) do
        playercontroller.ProcessInput(entity, dt)

        prisma.Camera.Position = prisma.Camera.Position:lerp(entity.Transform.Position, 0.1)

        entity.Transform.Rotation += 0.5 * dt

        local results = collisionSystem:query(entity)
        for _, other in pairs(results) do
            print("Colliding", dt)
        end

        local mousePos = Vector2.new(love.mouse.getX(), love.mouse.getY())
        local direction = -(entity.Transform.Position - prisma.Camera.ToWorldSpace(mousePos)):normalized()
        local closestEntity, closestPoint, closestDist = collisionSystem:raycast(entity.Transform.Position, direction, 1000, {entity})
        print(closestEntity, closestPoint, closestDist)
    end
end

function playercontroller:init(world)
    World = world
    collisionSystem = World:getSystem(prisma.systems.collisionsystem)
end

return playercontroller