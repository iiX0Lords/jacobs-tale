

local prisma = require("prisma/init")

local main = prisma.CreateScene("Main")
main.Active = true

main.Workspace:addSystems(
  prisma.systems.renderer
)

local test = concord.entity()
test:give("Transform", 50, 50, 100, 100)
test:give("Renderer")
test.Renderer.Image = love.graphics.newImage("assets/jacob.png")
prisma.Camera.Position = test.Transform.Position
prisma.Camera.Zoom = 1

main.Workspace:addEntity(test)

