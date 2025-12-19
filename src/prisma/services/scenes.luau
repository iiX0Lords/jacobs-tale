
local scenesManager = {
    Scenes = {}
}

function scenesManager:CreateScene(name : string)
    scenesManager.Scenes[name] = {
        Active = false,
        Workspace = prisma.Concord.world()
    }
    return scenesManager.Scenes[name]
end

return scenesManager