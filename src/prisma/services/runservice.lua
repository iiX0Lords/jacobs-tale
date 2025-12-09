
--[[

    TODO
    -------
    Add priorities to loops
    Add core rendering to this service with high priority
    Add UnbindRenderstep & OnDraw

]]

local Instance = require('prisma.instances.instance')

--- @class RunService
local runservice = {}
runservice.__index = runservice
setmetatable(runservice, Instance)
runservice.new = nil

runservice.loops = {}
runservice.drawingloops = {}

--- Create a function that runs every frame
--- @param name string
--- @param callback function
function runservice:RenderStep(name, callback)
    table.insert(runservice.loops, {
        Name = name,
        Callback = callback
    })
end

--- Create a function that runs everytime love.draw is ran
--- @param name string
--- @param callback function
function runservice:OnDraw(name, callback)
    table.insert(runservice.drawingloops, {
        Name = name,
        Callback = callback
    })
end

return runservice