return concord.component("Renderer", function(self, colour)
    self.Image = nil
    self.Colour = colour or prisma.Colour.new(255, 255, 255, 255)

    self._previousImage = nil
    self.ImageSize = batteries.vec2(0, 0)
end)