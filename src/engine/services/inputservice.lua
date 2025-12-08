
local instance = require("engine.instances.instance")
local vector2 = require("engine.math.vector2")

local inputservice = {}
inputservice.__index = inputservice
setmetatable(inputservice, instance)
inputservice.new = nil

local inputEvents = {}

function inputservice.OnKeypressed(callback)
    table.insert(inputEvents, {
        Type = "Keyboard",
        OnPress = true,
        Callback = callback
    })
end
function inputservice.OnKeyreleased(callback)
    table.insert(inputEvents, {
        Type = "Keyboard",
        OnPress = false,
        Callback = callback
    })
end

function inputservice.OnMousedown(callback)
    table.insert(inputEvents, {
        Type = "Mouse",
        OnPress = true,
        Callback = callback
    })
end
function inputservice.OnMouserelease(callback)
    table.insert(inputEvents, {
        Type = "Mouse",
        OnPress = false,
        Callback = callback
    })
end

function love.keypressed(key, scancode, isrepeat)
    for _, event in pairs(inputEvents) do
        if event.Type == "Keyboard" and event.OnPress then
           event.Callback(key, scancode, isrepeat) 
        end
    end
end
function love.keyreleased(key, scancode)
    for _, event in pairs(inputEvents) do
        if event.Type == "Keyboard" and not event.OnPress then
           event.Callback(key, scancode) 
        end
    end
end

function love.mousepressed(x, y, button, istouch, presses)
    for _, event in pairs(inputEvents) do
        if event.Type == "Mouse" and event.OnPress then
           event.Callback(x, y, button, istouch, presses) 
        end
    end
end
function love.mousereleased(x, y, button, istouch, presses)
    for _, event in pairs(inputEvents) do
        if event.Type == "Mouse" and not event.OnPress then
           event.Callback(x, y, button, istouch, presses)
        end
    end
end

return inputservice