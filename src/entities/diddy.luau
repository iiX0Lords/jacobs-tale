
local diddy = concord.entity()
diddy:give("Enemy")
diddy:give("Transform")
diddy:give("Renderer")
diddy:give("Physics")
diddy:give("Hitbox")
diddy.Renderer.Image = love.graphics.newImage("assets/diddy.png")


return diddy