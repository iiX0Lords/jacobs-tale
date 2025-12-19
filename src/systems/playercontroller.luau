local playercontroller = prisma.Concord.system({
    pool = {"Player", "Transform", "Physics"},
})
playercontroller.Default = true

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
    local moveSpeed = entity.Player.Speed * dt

    local inputX, inputY = 0, 0

    if love.keyboard.isDown(KEYBINDS.Forward) then inputY = inputY - 1 end
    if love.keyboard.isDown(KEYBINDS.Backward) then inputY = inputY + 1 end
    if love.keyboard.isDown(KEYBINDS.Left) then inputX = inputX - 1 end
    if love.keyboard.isDown(KEYBINDS.Right) then inputX = inputX + 1 end

    if inputX ~= 0 or inputY ~= 0 then
        local length = math.sqrt(inputX^2 + inputY^2)
        inputX = (inputX / length) * moveSpeed
        inputY = (inputY / length) * moveSpeed
    end

    physics.Velocity.x = inputX / dt
    physics.Velocity.y = inputY / dt
end

function playercontroller:update(dt)
    if World == nil then return end
    for _, entity in ipairs(self.pool) do
        playercontroller.ProcessInput(entity, dt)

        prisma.Camera.Position = prisma.Camera.Position:lerp(entity.Transform.Position, 0.1)
    end
end

function playercontroller:init(world)
    World = world
    collisionSystem = World:getSystem(prisma.Systems.collisionsystem)
end

return playercontroller