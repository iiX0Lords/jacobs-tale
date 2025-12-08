
local instance = require("engine.instances.instance")

local scene = {}
scene.__index = scene
setmetatable(scene, instance)

function scene.new()
    local self = instance.new()
    setmetatable(self, scene)
    self.Name = "Scene"
    self.ClassName = self.Name
    self.Children = {}
    self.Camera = nil

    return self
end

return scene