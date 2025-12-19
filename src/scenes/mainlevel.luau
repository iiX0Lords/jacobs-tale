
local mainScene = {
  Scene = prisma.Scenes:CreateScene("Main")
}
prisma.Systemhandler:AddSystems(mainScene.Scene.Workspace)

function spawnEntity(path)
  local entity = require(path)
  mainScene.Scene.Workspace:addEntity(entity)
  return entity
end
spawnEntity("entities/player")

prisma.Time:Timer(5, function()
  local enemy = spawnEntity("entities/diddy")
  enemy.Transform.Position = prisma.Vector2.new(150, 50)
end)

return mainScene