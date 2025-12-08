
local instance = require("engine.instances.instance")
local vector2 = require("engine.math.vector2")
local colour = require("engine.math.colour")

local label = {}
label.__index = label
setmetatable(label, instance)

function label.new()
    local self = instance.new()
    setmetatable(self, label)
    self.Name = "label"
    self.ClassName = self.Name
    self.Size = vector2.new(1, 1)
    self.Position = vector2.new(0, 0)
    self.Rotation = 0
    self.Colour = colour.new(255, 255, 255)
    self.ZIndex = 0

    self.Parent = nil

    self.Text = "Label"

    return self
end

function label:Render()
    love.graphics.print(self.Text, self.Position.x, self.Position.y, self.Rotation, self.Size.x, self.Size.y)
end

function label:IsVisible(bool)
    return true
end

function label:SetScene(scene)
    self.Parent = scene
    table.insert(scene.Children, self)
end

return label