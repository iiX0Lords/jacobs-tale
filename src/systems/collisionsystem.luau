local collisionSystem = prisma.Concord.system({
    pool = {"Transform", "Hitbox", "Renderer"},
})

local CELLSIZE = 100

local cells = {}
local pool = {}
local debugRays = {}

local function project(vertices, axis)
    local min, max = math.huge, -math.huge
    for _, v in ipairs(vertices) do
        local dot = v.x * axis.x + v.y * axis.y
        if dot < min then min = dot end
        if dot > max then max = dot end
    end
    return min, max
end

local function checkPolygonsIntersect(polyA, polyB)
    local polygons = {polyA, polyB}
    for i = 1, 2 do
        local polygon = polygons[i]
        for j = 1, #polygon do
            local p1 = polygon[j]
            local p2 = polygon[(j % #polygon) + 1]
            local normal = {x = p1.y - p2.y, y = p2.x - p1.x}
            local minA, maxA = project(polyA, normal)
            local minB, maxB = project(polyB, normal)
            if maxA < minB or maxB < minA then return false end
        end
    end
    return true
end

local function getHitboxVertices(entity, hb)
    local pos = entity.Transform.Position
    local rot = entity.Transform.Rotation or 0 
    local cos, sin = math.cos(rot), math.sin(rot)

    local ox, oy = hb.Position.x, hb.Position.y
    local cx = pos.x + (ox * cos - oy * sin)
    local cy = pos.y + (ox * sin + oy * cos)
    
    local hw, hh = hb.Size.x / 2, hb.Size.y / 2
    local corners = {{-hw, -hh}, {hw, -hh}, {hw, hh}, {-hw, hh}}
    local vertices = {}
    
    for _, c in ipairs(corners) do
        table.insert(vertices, {
            x = cx + (c[1] * cos - c[2] * sin),
            y = cy + (c[1] * sin + c[2] * cos)
        })
    end
    return vertices
end

local function rayIntersectsSegment(px, py, dx, dy, x1, y1, x2, y2)
    local rx, ry = x2 - x1, y2 - y1
    local cross = dx * ry - dy * rx

    if math.abs(cross) < 1e-6 then return nil end

    local t = ((x1 - px) * ry - (y1 - py) * rx) / cross
    local u = ((x1 - px) * dy - (y1 - py) * dx) / cross

    if t >= 0 and u >= 0 and u <= 1 then
        return t, {x = px + dx * t, y = py + dy * t}
    end
    return nil
end

local function rayIntersectsPolygon(origin, direction, vertices)
    local minDist = math.huge
    local hitPoint = nil
    
    for i = 1, #vertices do
        local p1 = vertices[i]
        local p2 = vertices[(i % #vertices) + 1]
        
        local dist, point = rayIntersectsSegment(origin.x, origin.y, direction.x, direction.y, p1.x, p1.y, p2.x, p2.y)
        
        if dist and dist < minDist then
            minDist = dist
            hitPoint = point
        end
    end
    
    return minDist, hitPoint
end

local function getEntityBounds(entity)
    local hitboxes = entity.Hitbox.Hitboxes
    if not hitboxes or #hitboxes == 0 then
        hitboxes = {{Position = prisma.Vector2.new(0,0), Size = entity.Hitbox.Size}}
    end

    local minX, minY, maxX, maxY = math.huge, math.huge, -math.huge, -math.huge
    for _, hb in ipairs(hitboxes) do
        local verts = getHitboxVertices(entity, hb)
        for _, v in ipairs(verts) do
            if v.x < minX then minX = v.x end
            if v.y < minY then minY = v.y end
            if v.x > maxX then maxX = v.x end
            if v.y > maxY then maxY = v.y end
        end
    end
    return minX, minY, maxX, maxY
end

function intersects(a, b)
    local hitboxesA = a.Hitbox.Hitboxes
    if not hitboxesA or #hitboxesA == 0 then
        hitboxesA = {{Position=prisma.Vector2.new(0,0), Size=a.Hitbox.Size}}
    end

    local hitboxesB = b.Hitbox.Hitboxes
    if not hitboxesB or #hitboxesB == 0 then
        hitboxesB = {{Position=prisma.Vector2.new(0,0), Size=b.Hitbox.Size}}
    end

    for _, hbA in ipairs(hitboxesA) do
        local polyA = getHitboxVertices(a, hbA)
        for _, hbB in ipairs(hitboxesB) do
            local polyB = getHitboxVertices(b, hbB)
            if checkPolygonsIntersect(polyA, polyB) then return true end
        end
    end
    return false
end

function getKey(x, y) 
    return x .. ":" .. y
end

function collisionSystem:raycast(origin, direction, maxDistance, filter)
    maxDistance = maxDistance or 1000
    filter = filter or {}
    
    local len = math.sqrt(direction.x^2 + direction.y^2)
    if len == 0 then return nil end
    local dx, dy = direction.x/len, direction.y/len
    
    table.insert(debugRays, {
        start = origin,
        dir = {x=dx, y=dy},
        dist = maxDistance,
        hit = false
    })

    local cellX = math.floor(origin.x / CELLSIZE)
    local cellY = math.floor(origin.y / CELLSIZE)

    local stepX = (dx > 0) and 1 or -1
    local stepY = (dy > 0) and 1 or -1
    
    local tDeltaX = (dx ~= 0) and math.abs(CELLSIZE / dx) or math.huge
    local tDeltaY = (dy ~= 0) and math.abs(CELLSIZE / dy) or math.huge
    
    local tMaxX, tMaxY
    if dx > 0 then
        tMaxX = ((cellX + 1) * CELLSIZE - origin.x) / dx
    elseif dx < 0 then
        tMaxX = (origin.x - cellX * CELLSIZE) / -dx
    else
        tMaxX = math.huge
    end

    if dy > 0 then
        tMaxY = ((cellY + 1) * CELLSIZE - origin.y) / dy
    elseif dy < 0 then
        tMaxY = (origin.y - cellY * CELLSIZE) / -dy
    else
        tMaxY = math.huge
    end

    local closestEntity = nil
    local closestDist = maxDistance
    local closestPoint = nil
    local visited = {}

    while true do
        local key = getKey(cellX, cellY)
        local cell = cells[key]

        if cell then
            for _, entity in ipairs(cell) do
                local isFiltered = false
                if table.find then
                    isFiltered = table.find(filter, entity)
                else
                    for _, f in ipairs(filter) do if f == entity then isFiltered = true break end end
                end

                if not isFiltered and not visited[entity] then
                    visited[entity] = true
                    
                    local hitboxes = entity.Hitbox.Hitboxes
                    if not hitboxes or #hitboxes == 0 then
                        hitboxes = {{Position = prisma.Vector2.new(0,0), Size = entity.Hitbox.Size}}
                    end

                    for _, hb in ipairs(hitboxes) do
                        local verts = getHitboxVertices(entity, hb)
                        local dist, point = rayIntersectsPolygon(origin, {x=dx, y=dy}, verts)

                        if dist and dist < closestDist then
                            closestDist = dist
                            closestEntity = entity
                            closestPoint = point
                        end
                    end
                end
            end
        end

        if closestEntity and closestDist < math.min(tMaxX, tMaxY) then
            break
        end

        if math.min(tMaxX, tMaxY) > maxDistance then
            break
        end

        if tMaxX < tMaxY then
            cellX = cellX + stepX
            tMaxX = tMaxX + tDeltaX
        else
            cellY = cellY + stepY
            tMaxY = tMaxY + tDeltaY
        end
    end
    
    if closestEntity then
        debugRays[#debugRays].dist = closestDist
        debugRays[#debugRays].hit = true
    end

    return {
        hit = closestEntity,
        point = closestPoint,
        distance = closestDist
    }
end

function collisionSystem:update(dt)
    debugRays = {}
    
    for key, cellList in pairs(cells) do
        for i = #cellList, 1, -1 do cellList[i] = nil end
        table.insert(pool, cellList)
    end
    cells = {}

    for _, entity in ipairs(self.pool) do
        if entity.Hitbox.Active then
            local minX, minY, maxX, maxY = getEntityBounds(entity)
            local startX, startY = math.floor(minX / CELLSIZE), math.floor(minY / CELLSIZE)
            local endX, endY = math.floor(maxX / CELLSIZE), math.floor(maxY / CELLSIZE)

            for cx = startX, endX do
                for cy = startY, endY do
                    local key = getKey(cx, cy)
                    if not cells[key] then
                        cells[key] = (#pool > 0) and table.remove(pool) or {}
                    end
                    table.insert(cells[key], entity)
                end
            end
        end
    end
end

function collisionSystem:query(entity)
    local results, seen = {}, {}
    local minX, minY, maxX, maxY = getEntityBounds(entity)
    local startX, startY = math.floor(minX/CELLSIZE), math.floor(minY/CELLSIZE)
    local endX, endY = math.floor(maxX/CELLSIZE), math.floor(maxY/CELLSIZE)
    
    for cx = startX, endX do
        for cy = startY, endY do
            local cell = cells[getKey(cx, cy)]
            if cell then
                for _, other in ipairs(cell) do
                    if other ~= entity and not seen[other] then
                        seen[other] = true
                        if intersects(entity, other) then table.insert(results, other) end
                    end
                end
            end
        end
    end
    return results
end

local function draw(position, size)
    love.graphics.push()
    local camPos = prisma.Camera.Position
    local convertedPos = prisma.Vector2.new(-camPos.x + love.graphics.getWidth() / 2, -camPos.y + love.graphics.getHeight() / 2)
	love.graphics.translate(position.x + convertedPos.x, position.y + convertedPos.y)
    love.graphics.scale(prisma.Camera.Zoom, prisma.Camera.Zoom)
	love.graphics.rectangle("line", -size.x/2, -size.y/2, size.x, size.y)
	love.graphics.pop()
end

local function drawPolygon(vertices)
    love.graphics.push()
    local camPos = prisma.Camera.Position
    local convertedPos = prisma.Vector2.new(-camPos.x + love.graphics.getWidth() / 2, -camPos.y + love.graphics.getHeight() / 2)
    love.graphics.translate(convertedPos.x, convertedPos.y)
    love.graphics.scale(prisma.Camera.Zoom, prisma.Camera.Zoom)
    
    local points = {}
    for _, v in ipairs(vertices) do table.insert(points, v.x); table.insert(points, v.y) end
    if #points >= 6 then love.graphics.polygon("line", points) end
    love.graphics.pop()
end

local function drawRay(ray)
    love.graphics.push()
    local camPos = prisma.Camera.Position
    local convertedPos = prisma.Vector2.new(-camPos.x + love.graphics.getWidth() / 2, -camPos.y + love.graphics.getHeight() / 2)
    love.graphics.translate(convertedPos.x, convertedPos.y)
    love.graphics.scale(prisma.Camera.Zoom, prisma.Camera.Zoom)
    
    if ray.hit then love.graphics.setColor(0, 1, 0, 1) 
    else love.graphics.setColor(0, 1, 1, 0.5) end

    local x1, y1 = ray.start.x, ray.start.y
    local x2 = x1 + ray.dir.x * ray.dist
    local y2 = y1 + ray.dir.y * ray.dist
    
    love.graphics.line(x1, y1, x2, y2)
    
    if ray.hit then
        love.graphics.circle("fill", x2, y2, 5)
    end
    
    love.graphics.pop()
end

VISUALIZE = true
function collisionSystem:ToggleDebug() VISUALIZE = not VISUALIZE end

function collisionSystem:draw()
    if not VISUALIZE then return end

    for _, entity in ipairs(self.pool) do
        if entity.Hitbox.Active then
            love.graphics.setColor(1, 0, 0, 1)
            local hitboxes = entity.Hitbox.Hitboxes
            if not hitboxes or #hitboxes == 0 then
                hitboxes = {{Position = prisma.Vector2.new(0,0), Size = entity.Hitbox.Size}}
            end
            for _, hb in ipairs(hitboxes) do
                drawPolygon(getHitboxVertices(entity, hb))
            end
        end
    end

    love.graphics.setColor(0, 1, 0, 0.5)
    for key, _ in pairs(cells) do
        local cx, cy = key:match("(-?%d+):(-?%d+)")
        if cx and cy then
            local centerX = (tonumber(cx) * CELLSIZE) + (CELLSIZE / 2)
            local centerY = (tonumber(cy) * CELLSIZE) + (CELLSIZE / 2)
            draw(prisma.Vector2.new(centerX, centerY), prisma.Vector2.new(CELLSIZE, CELLSIZE))
        end
    end
    
    for _, ray in ipairs(debugRays) do
        drawRay(ray)
    end
    
    love.graphics.setColor(1, 1, 1, 1)
end

return collisionSystem