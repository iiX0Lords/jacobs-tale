
local Vector2 = {}
Vector2.__index = Vector2

function Vector2.new(x, y)
    return setmetatable({ x = x or 0, y = y or 0 }, Vector2)
end

function Vector2:clone()
    return Vector2.new(self.x, self.y)
end

function Vector2:magnitude()
    return math.sqrt(self.x * self.x + self.y * self.y)
end

function Vector2:sqrMagnitude()
    return self.x * self.x + self.y * self.y
end

function Vector2:normalized()
    local mag = self:magnitude()
    if mag == 0 then
        return Vector2.new(0, 0)
    end
    return Vector2.new(self.x / mag, self.y / mag)
end

function Vector2:normalize()
    local mag = self:magnitude()
    if mag == 0 then
        self.x, self.y = 0, 0
    else
        self.x = self.x / mag
        self.y = self.y / mag
    end
    return self
end

function Vector2:dot(v)
    return self.x * v.x + self.y * v.y
end

function Vector2:distance(v)
    local dx = v.x - self.x
    local dy = v.y - self.y
    return math.sqrt(dx*dx + dy*dy)
end


function Vector2:lerp(goal, percent)
    return Vector2.new(
        self.x + (goal.x - self.x) * percent,
        self.y + (goal.y - self.y) * percent
    )
end

function Vector2.__add(a, b)
    if type(b) == "number" then
        return Vector2.new(a.x + b, a.y + b)
    end
    return Vector2.new(a.x + b.x, a.y + b.y)
end

function Vector2.__sub(a, b)
    if type(b) == "number" then
        return Vector2.new(a.x - b, a.y - b)
    end
    return Vector2.new(a.x - b.x, a.y - b.y)
end

function Vector2.__unm(a)
    return Vector2.new(-a.x, -a.y)
end

function Vector2.__mul(a, b)
    if type(a) == "number" then
        return Vector2.new(a * b.x, a * b.y)
    elseif type(b) == "number" then
        return Vector2.new(a.x * b, a.y * b)
    end
    return Vector2.new(a.x * b.x, a.y * b.y)
end

function Vector2.__div(a, b)
    if type(b) == "number" then
        return Vector2.new(a.x / b, a.y / b)
    end
    return Vector2.new(a.x / b, a.y / b)
end

function Vector2.__eq(a, b)
    return a.x == b.x and a.y == b.y
end

function Vector2.__tostring(v)
    return string.format("Vector2(%g, %g)", v.x, v.y)
end

export type Vector2 = {
    x: number,
    y: number,

    clone: (self: Vector2) -> Vector2,
    magnitude: (self: Vector2) -> number,
    sqrMagnitude: (self: Vector2) -> number,
    normalized: (self: Vector2) -> Vector2,
    normalize: (self: Vector2) -> Vector2,
    dot: (self: Vector2, v: Vector2) -> number,
    distance: (self: Vector2, v: Vector2) -> number,
    lerp: (self: Vector2, goal: Vector2, percent: number) -> Vector2,

    __add: ((self: Vector2, b: Vector2 | number) -> Vector2),
    __sub: ((self: Vector2, b: Vector2 | number) -> Vector2),
    __mul: ((self: Vector2, b: Vector2 | number) -> Vector2),
    __div: ((self: Vector2, b: number) -> Vector2),
    __unm: (self: Vector2) -> Vector2,
    __tostring: (self: Vector2) -> string,
}

type Vector2Static = {
    __index: Vector2Static,
    new: (x: number?, y: number?) -> Vector2,
}

return Vector2
