
local Instance = require('prisma.instances.instance')
local Vector2 = require('prisma.math.vector2')
local Colour = require('prisma.math.colour')

--- @class Label
local label = {}
label.__index = label
setmetatable(label, Instance)

function label.new()
    local self = setmetatable(Instance.new(), label)
    self.Name = "label"
    self.ClassName = self.Name
    self.Size = Vector2.new(1, 1)
    self.Position = Vector2.new(0, 0)
    self.Rotation = 0
    self.Colour = Colour.new(255, 255, 255)
    self.ZIndex = 0

    self.Parent = nil

    self.Text = "Label"

    return self
end

--- Render this object for this frame
function label:Render()
    love.graphics.print(self.Text, self.Position.x, self.Position.y, self.Rotation, self.Size.x, self.Size.y)
end

--- Checks if self is currently visible (Always returns true for labels)
--- @return boolean
function label:IsVisible(bool)
    return true
end

return label