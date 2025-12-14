local renderer = concord.system({
    pool = {"Renderer", "Transform"},
})

function renderer.DrawShape(entity)
    love.graphics.push()
    local camPos = prisma.Camera.Position
    local convertedPos = batteries.vec2(-camPos.x + love.graphics.getWidth() / 2, -camPos.y + love.graphics.getHeight() / 2)
	love.graphics.translate(entity.Transform.Position.x + convertedPos.x, entity.Transform.Position.y + convertedPos.y)
    love.graphics.scale(prisma.Camera.Zoom, prisma.Camera.Zoom)
	love.graphics.rotate(entity.Transform.Rotation)
	love.graphics.rectangle("fill", -entity.Transform.Size.x/2, -entity.Transform.Size.y/2, entity.Transform.Size.x, entity.Transform.Size.y)
	love.graphics.pop()
end

function renderer.UpdateVariables(entity)
    entity.Renderer.ImageSize = batteries.vec2(entity.Renderer.Image:getPixelWidth(), entity.Renderer.Image:getPixelHeight())
end

function renderer.DrawSprite(entity)
    if entity.Renderer.Image ~= entity.Renderer._previousImage then
        entity.Renderer._previousImage = entity.Renderer.Image
        renderer.UpdateVariables(entity)
    end

    love.graphics.push()

    love.graphics.scale(prisma.Camera.Zoom, prisma.Camera.Zoom)

    local camPos = prisma.Camera.Position
    local convertedPos = batteries.vec2(-camPos.x + love.graphics.getWidth() / 2, -camPos.y + love.graphics.getHeight() / 2)


    love.graphics.translate(convertedPos.x, convertedPos.y)

    local scale = batteries.vec2(
        entity.Transform.Size.x / entity.Renderer.ImageSize.x,
        entity.Transform.Size.y / entity.Renderer.ImageSize.y
    )

    love.graphics.draw(entity.Renderer.Image, entity.Transform.Position.x , entity.Transform.Position.y, entity.Transform.Rotation, scale.x, scale.y, entity.Renderer.ImageSize.x / 2, entity.Renderer.ImageSize.y / 2)

    love.graphics.pop()
end

function renderer:draw()
    for _, entity in ipairs(self.pool) do
        love.graphics.setColor(entity.Renderer.Colour.r / 255, entity.Renderer.Colour.g / 255, entity.Renderer.Colour.b / 255)
        if entity.Renderer.Image == nil then
            renderer.DrawShape(entity)
            else
            renderer.DrawSprite(entity)
        end
    end
end
return renderer