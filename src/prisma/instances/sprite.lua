
local Shape = require('prisma.instances.shape')
local Vector2 = require('prisma.math.vector2')
local Colour = require('prisma.math.colour')

--- @class Sprite
local sprite = {}
sprite.__index = sprite
setmetatable(sprite, Shape)

function sprite.new()
    local self = setmetatable(Shape.new(), sprite)
    self.Name = "Sprite"
    self.ClassName = self.Name

    self.Image = nil
    self._previousImage = nil

    self.ImageSize = Vector2.new(0, 0)

    return self
end

--- Updates self.ImageSize based on new self.Image
function sprite:_updateVariables()
    self.ImageSize = Vector2.new(self.Image:getPixelWidth(), self.Image:getPixelHeight())
end

function sprite:Render()
    if self.Image == nil then return end
    if self.Image ~= self._previousImage then
        self._previousImage = self.Image
        self:_updateVariables()
    end

    love.graphics.push()

    love.graphics.scale(self.Parent.Camera.Zoom, self.Parent.Camera.Zoom)
    local wx, wy = love.graphics.inverseTransformPoint(0, 0)

    local camPos = self.Parent.Camera.Position
    local convertedPos = Vector2.new(-camPos.x + love.graphics.getWidth() / 2, -camPos.y + love.graphics.getHeight() / 2)


    love.graphics.translate(convertedPos.x, convertedPos.y)

    local scale = Vector2.new(
        self.Size.x / self.ImageSize.x,
        self.Size.y / self.ImageSize.y
    )

    love.graphics.draw(self.Image, self.Position.x , self.Position.y, self.Rotation, scale.x, scale.y, self.ImageSize.x / 2, self.ImageSize.y / 2)

    love.graphics.pop()
end

return sprite