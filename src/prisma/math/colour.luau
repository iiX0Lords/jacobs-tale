
--- @class Colour
local colour = {}
colour.__index = colour


function colour.new(red, green, blue, alpha)
    local self = setmetatable({}, colour)
    self.r = red or 0
    self.g = green or 0
    self.b = blue or 0
    self.a = alpha or 255
    return self
end



return colour