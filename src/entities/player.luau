
local plr = prisma.Concord.entity()
plr:give("Player", 1)
plr:give("Transform")
plr:give("Renderer")
plr:give("Physics")
plr:give("Hitbox")
plr.Renderer.ZIndex = 2
plr.Renderer.Image = love.graphics.newImage("assets/jacob.png")
plr.Transform.Size = prisma.Vector2.new(50 * 1.5, 50 * 1.5)

plr.Hitbox.Hitboxes = {
  {
    Position = prisma.Vector2.new(0, 0),
    Size = plr.Transform.Size
  },
}

return plr