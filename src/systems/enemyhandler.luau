local enemyHandler = concord.system({
    pool = {"Enemy", "Transform", "Renderer", "Physics"},
    player = {"Player"}
})

local player = nil

local function getLookVector(a, b)
    local ax, ay = a.x, a.y
    local bx, by = b.x, b.y
    local dx, dy = bx - ax, by - ay
    local len = math.sqrt(dx*dx + dy*dy)
    if len == 0 then return 0, 0 end
    return Vector2.new(dx / len, dy / len)
end


function enemyHandler:update(dt)
    for _, plr in ipairs(self.player) do
        player = plr
    end

    for _, entity in ipairs(self.pool) do
        if entity.Player ~= nil then continue end
        if player == nil then continue end

        local data = entity.Enemy
        local distance = (player.Transform.Position - entity.Transform.Position):magnitude()
        local dir = getLookVector(entity.Transform.Position, player.Transform.Position)

        if distance > 8 then
            entity.Physics.Velocity = dir * 0.5
        end
    end
end
return enemyHandler