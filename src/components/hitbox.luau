return concord.component("Hitbox", function(self, size)
    self.Size = Vector2.new(50, 50)
    self.Hitboxes = {}
    self.Active = true
end)