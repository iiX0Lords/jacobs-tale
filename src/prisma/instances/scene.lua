
local Instance = require('prisma.instances.instance')

--- @class Scene
local scene = {}
scene.__index = scene
setmetatable(scene, Instance)

function scene.new()
    local self = setmetatable(Instance.new(), scene)
    self.Name = "Scene"
    self.ClassName = self.Name
    self.Children = {}
    self.Camera = nil

    return self
end

return scene