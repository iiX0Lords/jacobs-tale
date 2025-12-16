
local mainScene = {
  Scene = prisma.CreateScene("Main")
}

mainScene.Scene.Workspace:addSystems(
  prisma.systems.renderer,
  prisma.systems.playercontroller,
  prisma.systems.physicshandler,
  prisma.systems.enemyhandler
)

function spawnEntity(image)
  if image == nil then return end
  local entity = concord.entity()
  entity:give("Transform")
  entity:give("Renderer")
  entity:give("Physics")
  entity.Renderer.Image = image
  mainScene.Scene.Workspace:addEntity(entity)
  return entity
end

local plr = spawnEntity(love.graphics.newImage("assets/jacobPIXEL.png"))
plr.Transform.Size = Vector2.new(50 * 2, 50 * 2)
plr.Renderer.ZIndex = 2
plr:give("Player", 20)


local enemy = spawnEntity(love.graphics.newImage("assets/diddy.png"))
enemy:give("Enemy")
enemy.Transform.Position = Vector2.new(50, 50)

return mainScene