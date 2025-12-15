return concord.component("Transform", function(self, x, y, w, h, r)
    self.Position = prisma.Vector2.new(x or 0, y or 0)
    self.Size = prisma.Vector2.new(w or 0, h or 0)
    self.Rotation = r or 0
end)