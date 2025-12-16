return concord.component("Enemy", function(self, speed, strength, health)
    self.Speed = speed
    self.Strength = strength or 10
    self.Health = health or 100
end)