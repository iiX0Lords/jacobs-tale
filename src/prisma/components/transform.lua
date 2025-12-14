return concord.component("Transform", function(self, x, y, w, h, r)
    self.Position = batteries.vec2(x or 0, y or 0)
    self.Size = batteries.vec2(w or 0, h or 0)
    self.Rotation = r or 0
end)