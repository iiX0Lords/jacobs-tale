
--[[

    TODO
    -------
    Add priorities to loops
    Add core rendering to this service with high priority
    Add UnbindRenderstep & OnDraw

]]

local instance = require("engine.instances.instance")

local runservice = {}
runservice.__index = runservice
setmetatable(runservice, instance)
runservice.new = nil

runservice.loops = {}
runservice.drawingloops = {}

function runservice:RenderStep(name, callback)
    table.insert(runservice.loops, {
        Name = name,
        Callback = callback
    })
end

function runservice:OnDraw(name, callback)
    table.insert(runservice.drawingloops, {
        Name = name,
        Callback = callback
    })
end

return runservice