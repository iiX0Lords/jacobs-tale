return prisma.Concord.component("Physics", function(self, friction)
    self.Friction = friction or 0.1
    self.Velocity = prisma.Vector2.new(0, 0)
end)