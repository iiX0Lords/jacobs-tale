
local instance = require("engine.instances.instance")
local vector2 = require("engine.math.vector2")
local colour = require("engine.math.colour")

local shape = {}
shape.__index = shape
setmetatable(shape, instance)

function shape.new()
    local self = instance.new()
    setmetatable(self, shape)
    self.Name = "Shape"
    self.ClassName = self.Name
    self.Size = vector2.new(100, 100)
    self.Position = vector2.new(0, 0)
    self.Rotation = 0
    self.Colour = colour.new(255, 255, 255)

    self.Parent = nil

    return self
end

function shape:Destroy()
    if self.Parent then
        local children = self.Parent.Children
        for i = #children, 1, -1 do
            if children[i] == self then
                table.remove(children, i)
                break
            end
        end
    end

    self.Parent = nil
    self.Position = nil
    self.Size = nil
    self.Colour = nil
    self.Image = nil
    setmetatable(self, nil)

    for k in pairs(self) do
        self[k] = nil
    end
end

function shape:Render()
    love.graphics.push()
    local camPos = self.Parent.Camera.Position
    local convertedPos = vector2.new(-camPos.x + love.graphics.getWidth() / 2, -camPos.y + love.graphics.getHeight() / 2)
	love.graphics.translate(self.Position.x + convertedPos.x, self.Position.y + convertedPos.y)
    love.graphics.scale(self.Parent.Camera.Zoom, self.Parent.Camera.Zoom)
	love.graphics.rotate(self.Rotation)
	love.graphics.rectangle("fill", -self.Size.x/2, -self.Size.y/2, self.Size.x, self.Size.y)
	love.graphics.pop()
end

function shape:IsVisible()
    local size = self.Size
    local pos = self.Position

    local camera = self.Parent.Camera
    if camera then
        pos = camera:ToScreenSpace(pos)
    end

    local screenW = love.graphics.getWidth()
    local screenH = love.graphics.getHeight()

    local halfW = size.x / 2
    local halfH = size.y / 2

    local left   = pos.x - halfW
    local right  = pos.x + halfW
    local top    = pos.y - halfH
    local bottom = pos.y + halfH

    if right < 0 then
        return false
    end
    if left > screenW then
        return false
    end
    if bottom < 0 then
        return false
    end
    if top > screenH then
        return false
    end

    return true
end


function shape:SetScene(scene)
    self.Parent = scene
    table.insert(scene.Children, self)
end

return shape