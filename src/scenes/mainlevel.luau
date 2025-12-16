
local mainScene = {
    Scene = prisma.CreateScene("Main")
}

mainScene.Scene.Workspace:addSystems(
  prisma.systems.renderer,
  prisma.systems.playercontroller,
  prisma.systems.physicshandler
)

local plr = concord.entity()
plr:give("Transform", 50, 50, 100, 100)
plr:give("Renderer")
plr:give("Physics")
plr:give("Player", 20)
plr.Renderer.Image = love.graphics.newImage("assets/jacob.png")


mainScene.Scene.Workspace:addEntity(plr)

return mainScene