
local camera = {}

camera.Position = prisma.Vector2.new(0, 0)
camera.Zoom = 1

function camera.ToWorldSpace(screenPos)
    local camX, camY = prisma.Camera.Position.x, prisma.Camera.Position.y
    local zoom = prisma.Camera.Zoom or 1

    local screenW = love.graphics.getWidth()
    local screenH = love.graphics.getHeight()

    local dx = (screenPos.x - screenW / 2) / zoom
    local dy = (screenPos.y - screenH / 2) / zoom

    local worldX = camX + dx
    local worldY = camY + dy

    return prisma.Vector2.new(worldX, worldY)
end
function camera.ToScreenSpace(worldPos)
    local camX, camY = prisma.Camera.Position.x, prisma.Camera.Position.y
    local zoom = prisma.Camera.Zoom or 1

    local screenW = love.graphics.getWidth()
    local screenH = love.graphics.getHeight()

    local dx = (worldPos.x - camX) * zoom
    local dy = (worldPos.y - camY) * zoom

    local screenX = dx + (screenW / 2)
    local screenY = dy + (screenH / 2)

    return prisma.Vector2.new(screenX, screenY)
end

return camera