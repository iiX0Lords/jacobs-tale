return concord.component("Renderer", function(self, colour)
    self.Image = nil
    self.Colour = colour or prisma.Colour.new(255, 255, 255, 255)

    self._previousImage = nil
    self.ImageSize = prisma.Vector2.new(0, 0)

    self.ZIndex = 1
end)