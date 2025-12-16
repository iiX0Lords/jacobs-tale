return concord.component("Physics", function(self, friction)
    self.Friction = friction or 0.1
    self.Velocity = Vector2.new(0, 0)
end)