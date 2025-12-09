
--- @class Instance
local instance = {}
instance.__index = instance

function instance.new()
    local self = setmetatable({}, instance)
    self.Name = "Instance"
    self.ClassName = "Instance"
    self.ZIndex = 0
    self.Parent = nil

    return self
end

--- Checks if self is a certain class
--- @param classname string
--- @return boolean
function instance:IsA(classname)
    if self.ClassName == classname then
        return true
    else
        return false
    end
end

--- Sets self's parent to a scene
--- @param scene Instance
function instance:SetScene(scene)
    self.Parent = scene
    table.insert(scene.Children, self)
end

return instance