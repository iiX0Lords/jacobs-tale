--[[

    TODO
]]

local sceneManager = require('prisma.instances.scene')

local scenes = {}

--- @class Prisma
local engine = {
    Vector2 = require('prisma.math.vector2')
}

engine.instances = {
    Shape = require('prisma.instances.shape')
}
engine.services = {
    Runservice = require('prisma.services.runservice'),
    AssetManager = require('prisma.services.assetmanager'),
    InputService = require('prisma.services.inputservice')
}
engine.Colour = require('prisma.math.colour')

--- Create a new scene.
--- @param name string
--- @return Instance
function engine:CreateScene(name)
    local newScene = sceneManager.new()
    newScene.Name = name
    newScene.Active = true
    table.insert(scenes, newScene)

    return newScene
end

--- Get ZIndex based on instance type.
--- @param instance Instance
--- @return number
function GetZ(instance)
    if instance:IsA("label") then
        return instance.ZIndex + 100000
    end
    return instance.ZIndex
end

--- Render a single frame.
function engine:Render()
    for _, scene in pairs(scenes) do
        if scene.Active == true then
            table.sort(scene.Children, function(a, b)
                return GetZ(a) < GetZ(b)
            end)
            for _, instance in ipairs(scene.Children) do
                if instance.Render then
                    if instance:IsVisible() then
                        love.graphics.setColor(instance.Colour.r / 255, instance.Colour.g / 255, instance.Colour.b / 255)
                        instance:Render()
                    end
                end
            end
        end
    end
end

--- Create a new instance.
--- @param classname string
--- @return Instance
function engine.Instance(classname)
    return engine.services.AssetManager.AttemptRequire("prisma/instances/".. string.lower(classname) ..".lua").new()
end

function love.update(dt)
    for _, loop in pairs(engine.services.Runservice.loops) do
        loop.Callback(dt)
    end
end
function love.draw()
    engine:Render()
    for _, loop in pairs(engine.services.Runservice.drawingloops) do
        loop.Callback()
    end
    
end

print("Prisma loaded")

return engine