local physicsHandler = prisma.Concord.system({
    pool = {"Physics", "Transform"},
})
physicsHandler.Priority = 2
physicsHandler.Default = true

function physicsHandler:update(dt)
    for _, entity in ipairs(self.pool) do
        local data = entity.Physics
        local transform = entity.Transform
        if data == nil or transform == nil then continue end

        local velocity = data.Velocity or prisma.Vector2.new(0, 0)
        transform.Position += velocity

        data.Velocity *= math.pow(data.Friction / 1000, dt)

        if data.Velocity:magnitude() < 0.1 then
            data.Velocity = prisma.Vector2.new(0, 0)
        end
    end
end
return physicsHandler