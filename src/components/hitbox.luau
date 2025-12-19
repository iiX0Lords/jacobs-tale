return prisma.Concord.component("Hitbox", function(self, size)
    self.Size = prisma.Vector2.new(50, 50)
    self.Hitboxes = {}
    self.Active = true
end)