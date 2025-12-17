
local plr = concord.entity()
plr:give("Player", 20)
plr:give("Transform")
plr:give("Renderer")
plr:give("Physics")
plr:give("Hitbox")
plr.Transform.Size = Vector2.new(50 * 2, 50 * 2)
plr.Renderer.ZIndex = 2
plr.Renderer.Image = love.graphics.newImage("assets/jacobPIXEL.png")

plr.Hitbox.Hitboxes = {
  {
    Position = Vector2.new(0, 0),
    Size = Vector2.new(25, 100)
  },
}

return plr