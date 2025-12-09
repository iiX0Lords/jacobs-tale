
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
    local camX, camY = self.Position.x, self.Position.y
    local zoom = self.Zoom

    local screenW = love.graphics.getWidth()
    local screenH = love.graphics.getHeight()

    local dx = (screenPos.x - screenW / 2) / zoom
    local dy = (screenPos.y - screenH / 2) / zoom

    local worldX = camX + dx
    local worldY = camY + dy

    return vector2.new(worldX, worldY)
end


function camera:ToScreenSpace(worldPos)
    local camX, camY = self.Position.x, self.Position.y
    local zoom = self.Zoom

    local screenW = love.graphics.getWidth()
    local screenH = love.graphics.getHeight()

    local dx = (worldPos.x - camX) * zoom
    local dy = (worldPos.y - camY) * zoom

    local screenX = dx + (screenW / 2)
    local screenY = dy + (screenH / 2)

    return vector2.new(screenX, screenY)
end


return camera