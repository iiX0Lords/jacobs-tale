
local input = {
    Events = {
        KeyPressed = {},
        KeyReleased = {}
    }
}

function input.KeyDown(callback)
    table.insert(prisma.Input.Events.KeyPressed, callback)
end

function input.KeyReleased(callback)
    table.insert(prisma.Input.Events.KeyReleased, callback)
end

function love.keypressed(key, scancode, isrepeat)
    for _, callback in pairs(prisma.Input.Events.KeyPressed) do
        callback(key, scancode, isrepeat)
    end
end
function love.keyreleased(key, scancode, isrepeat)
    for _, callback in pairs(prisma.Input.Events.KeyReleased) do
        callback(key, scancode, isrepeat)
    end
end

return input