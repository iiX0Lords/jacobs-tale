
local instance = {}
instance.__index = instance

function instance.new()
    local self = setmetatable({}, instance)
    self.Name = "Instance"
    self.ClassName = "Instance"
    self.ZIndex = 0

    return self
end

function instance:IsA(classname)
    if self.ClassName == classname then
        return true
    else
        return false
    end
end

return instance