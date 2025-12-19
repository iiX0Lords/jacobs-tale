
local diddy = prisma.Concord.entity()
diddy:give("Enemy", 0.5)
diddy:give("Transform")
diddy:give("Renderer")
diddy:give("Physics", 0)
diddy:give("Hitbox")
diddy.Renderer.Image = love.graphics.newImage("assets/diddy.png")


return diddy