
local instance = require("engine.instances.instance")
local vector2 = require("engine.math.vector2")
local colour = require("engine.math.colour")

local camera = {}
camera.__index = camera
setmetatable(camera, instance)

function camera.new()
    local self = instance.new()
    setmetatable(self, camera)
    self.Name = "camera"
    self.ClassName = self.Name
    self.Zoom = 1.0
    self.Position = vector2.new(0, 0)
    self.Active = false

    self.Parent = nil

    return self
end

function camera:SetScene(scene)
    self.Parent = scene
    table.insert(scene.Children, self)
end

function camera:SetActive(bool)
    if self.Parent == nil then return end
    if bool then
        self.Parent.Camera = self
    else
        if self.Parent.Camera == self then
            self.Parent.Camera = nil
        end
    end
end

function camera:ToWorldSpace(screenPos)
    local cx, cy = self.Position.x, self.Position.y
    local angle = 0
    local sx = self.Zoom
    local sy = self.Zoom

    local dx = screenPos.x - cx
    local dy = screenPos.y - cy

    local c = math.cos(-angle)
    local s = math.sin(-angle)

    local rotatedX = dx * c - dy * s
    local rotatedY = dx * s + dy * c

    local worldX = rotatedX / sx
    local worldY = rotatedY / sy

    return vector2.new(worldX, worldY)
end

function camera:ToScreenSpace(worldPos)
    local cx, cy = self.Position.x, self.Position.y
    local angle = 0
    local sx = self.Zoom
    local sy = self.Zoom

    local scaledX = worldPos.x * sx
    local scaledY = worldPos.y * sy

    local c = math.cos(angle)
    local s = math.sin(angle)

    local rotatedX = scaledX * c - scaledY * s
    local rotatedY = scaledX * s + scaledY * c

    local screenX = rotatedX + cx
    local screenY = rotatedY + cy

    return vector2.new(screenX, screenY)
end

return camera