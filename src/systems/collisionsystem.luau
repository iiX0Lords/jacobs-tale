local collisionSystem = concord.system({
    pool = {"Transform", "Hitbox", "Renderer"},
})

local CELLSIZE = 100

local cells = {}
local objects = {}
local pool = {}

local function rectOverlap(posA, sizeA, posB, sizeB)
    return posA.x < posB.x + sizeB.x and
           posB.x < posA.x + sizeA.x and
           posA.y < posB.y + sizeB.y and
           posB.y < posA.y + sizeA.y
end

local function getEntityBounds(entity)
    local pos = entity.Transform.Position
    local hitboxes = entity.Hitbox.Hitboxes

    if not hitboxes or #hitboxes == 0 then
        local halfW = entity.Hitbox.Size.x / 2
        local halfH = entity.Hitbox.Size.y / 2
        return pos.x - halfW, pos.y - halfH, pos.x + halfW, pos.y + halfH
    end

    local minX, minY = math.huge, math.huge
    local maxX, maxY = -math.huge, -math.huge

    for _, hb in ipairs(hitboxes) do
        local absX = pos.x + hb.Position.x
        local absY = pos.y + hb.Position.y
        
        local halfW = hb.Size.x / 2
        local halfH = hb.Size.y / 2

        local left = absX - halfW
        local right = absX + halfW
        local top = absY - halfH
        local bottom = absY + halfH
        
        if left < minX then minX = left end
        if top < minY then minY = top end
        
        if right > maxX then maxX = right end
        if bottom > maxY then maxY = bottom end
    end
    
    return minX, minY, maxX, maxY
end

function intersects(a, b)
    local posA = a.Transform.Position
    local posB = b.Transform.Position
    
    for _, hbA in ipairs(a.Hitbox.Hitboxes) do
        local absPosA = posA + hbA.Position 
        local topLeftA = Vector2.new(absPosA.x - hbA.Size.x/2, absPosA.y - hbA.Size.y/2)
        
        for _, hbB in ipairs(b.Hitbox.Hitboxes) do
            local absPosB = posB + hbB.Position
            local topLeftB = Vector2.new(absPosB.x - hbB.Size.x/2, absPosB.y - hbB.Size.y/2)
            
            if rectOverlap(topLeftA, hbA.Size, topLeftB, hbB.Size) then
                return true
            end
        end
    end

    return false
end

function getKey(x, y)
    return x .. ":" .. y
end

function collisionSystem:update(dt)
    for key, cellList in pairs(cells) do
        for i = #cellList, 1, -1 do
            cellList[i] = nil
        end
        table.insert(pool, cellList)
    end
    cells = {}

    for _, entity in ipairs(self.pool) do
        if entity.Hitbox.Active then
            local minX, minY, maxX, maxY = getEntityBounds(entity)
            
            local startX = math.floor(minX / CELLSIZE)
            local startY = math.floor(minY / CELLSIZE)
            local endX   = math.floor(maxX / CELLSIZE)
            local endY   = math.floor(maxY / CELLSIZE)

            for cx = startX, endX do
                for cy = startY, endY do
                    local key = getKey(cx, cy)

                    if not cells[key] then
                        local newCell
                        if #pool > 0 then
                            newCell = table.remove(pool)
                        else
                            newCell = {}
                        end
                        cells[key] = newCell
                    end
                    
                    table.insert(cells[key], entity)
                end
            end
        end
    end
end

function collisionSystem:query(entity)
    local results = {}
    local seen = {}

    local minX, minY, maxX, maxY = getEntityBounds(entity)
    
    local startX = math.floor(minX / CELLSIZE)
    local startY = math.floor(minY / CELLSIZE)
    local endX   = math.floor(maxX / CELLSIZE)
    local endY   = math.floor(maxY / CELLSIZE)
    
    for cx = startX, endX do
        for cy = startY, endY do
            local key = getKey(cx, cy)
            local cell = cells[key]
            
            if cell then
                for _, other in ipairs(cell) do
                    if other ~= entity and not seen[other] then
                        seen[other] = true

                        if intersects(entity, other) then
                            table.insert(results, other)
                        end
                    end
                end
            end
        end
    end

    return results
end

function draw(position, size)
    love.graphics.push()
    local camPos = prisma.Camera.Position
    local convertedPos = prisma.Vector2.new(-camPos.x + love.graphics.getWidth() / 2, -camPos.y + love.graphics.getHeight() / 2)
	love.graphics.translate(position.x + convertedPos.x, position.y + convertedPos.y)
    love.graphics.scale(prisma.Camera.Zoom, prisma.Camera.Zoom)
	love.graphics.rectangle("line", -size.x/2, -size.y/2, size.x, size.y)
	love.graphics.pop()
end

VISUALIZE = true

function collisionSystem:ToggleDebug()
    VISUALIZE = not VISUALIZE
end

function collisionSystem:draw()
    if not VISUALIZE then return end
    for _, entity in ipairs(self.pool) do
        if entity.Hitbox.Active then
            local pos = entity.Transform.Position
            local hitboxes = entity.Hitbox.Hitboxes
            love.graphics.setColor(1, 0, 0, 1)

            if hitboxes and #hitboxes > 0 then
                for _, hb in ipairs(hitboxes) do
                    local absX = pos.x + hb.Position.x
                    local absY = pos.y + hb.Position.y

                    draw(Vector2.new(absX, absY), hb.Size)
                end
            else
                draw(pos, entity.Hitbox.Size)
            end
        end
    end

    love.graphics.setColor(0, 1, 0, 0.5)
    for key, _ in pairs(cells) do
        local cx, cy = key:match("(-?%d+):(-?%d+)")
        cx, cy = tonumber(cx), tonumber(cy)
        
        if cx and cy then
            draw(Vector2.new(cx * CELLSIZE, cy * CELLSIZE), Vector2.new(CELLSIZE, CELLSIZE))
        end
    end
    love.graphics.setColor(1, 1, 1, 1)
end

return collisionSystem