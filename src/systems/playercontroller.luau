local playercontroller = concord.system({
    pool = {"Player", "Transform", "Physics"},
})

KEYBINDS = {
    Forward = {"w", "up"},
    Backward = {"s", "down"},
    Left = {"a", "left"},
    Right = {"d", "right"}
}

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
    for _, entity in ipairs(self.pool) do
        playercontroller.ProcessInput(entity, dt)
    end
end
return playercontroller