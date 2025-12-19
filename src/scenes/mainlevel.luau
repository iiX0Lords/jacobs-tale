
local mainScene = {
  Scene = prisma.Scenes:CreateScene("Main")
}

mainScene.Scene.Workspace:addSystems(
  prisma.Systems.renderer,
  prisma.Systems.physicshandler,
  prisma.Systems.collisionsystem,
  prisma.Systems.playercontroller,
  prisma.Systems.enemyhandler
)

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