
local mainScene = {
  Scene = prisma.CreateScene("Main")
}

mainScene.Scene.Workspace:addSystems(
  prisma.systems.renderer,
  prisma.systems.collisionsystem,
  prisma.systems.playercontroller,
  prisma.systems.physicshandler,
  prisma.systems.enemyhandler
)


function spawnEntity(path)
  local entity = require(path)
  mainScene.Scene.Workspace:addEntity(entity)
  return entity
end
spawnEntity("entities/player")

local enemy = spawnEntity("entities/diddy")
enemy.Transform.Position = Vector2.new(50, 50)

return mainScene