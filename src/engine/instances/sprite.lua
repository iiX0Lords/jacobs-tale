
local shape = require("engine.instances.shape")
local vector2 = require("engine.math.vector2")
local colour = require("engine.math.colour")

local sprite = {}
sprite.__index = sprite
setmetatable(sprite, shape)

function sprite.new()
    local self = shape.new()
    setmetatable(self, sprite)
    self.Name = "Sprite"
    self.ClassName = self.Name

    self.Image = nil
    self._previousImage = nil

    self.ImageSize = vector2.new(0, 0)

    return self
end

function sprite:_updateVariables()
    self.ImageSize = vector2.new(self.Image:getPixelWidth(), self.Image:getPixelHeight())
end

function sprite:Render()
    if self.Image == nil then return end

    if self.Image ~= self._previousImage then
        self._previousImage = self.Image
        self:_updateVariables()
    end

    love.graphics.push()

    love.graphics.translate(self.Parent.Camera.Position.x, self.Parent.Camera.Position.y)
    love.graphics.scale(self.Parent.Camera.Zoom, self.Parent.Camera.Zoom)

    local scale = vector2.new(
        self.Size.x / self.ImageSize.x,
        self.Size.y / self.ImageSize.y
    )

    love.graphics.draw(self.Image, self.Position.x , self.Position.y, self.Rotation, scale.x, scale.y, self.ImageSize.x / 2, self.ImageSize.y / 2)

    love.graphics.pop()
end

return sprite