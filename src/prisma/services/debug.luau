
local debug = {}

function debug:DrawStats()
    local lua_mem = collectgarbage("count")
    love.graphics.setColor(1, 0, 0, 1)
    love.graphics.print(string.format("RAM:    %.2f MB", lua_mem / 1024), 20, 35)
    love.graphics.print(string.format("FPS:        %d", love.timer.getFPS()), 20, 50)
end

return debug