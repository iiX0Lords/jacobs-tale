local engine = require("engine.main")

local mainScene = engine:CreateScene("Main")

local shape = engine.Instance("Shape")
shape:SetScene(mainScene)
shape.Colour = engine.Colour.new(255, 0, 0)

local cam = engine.Instance("Camera")
cam:SetScene(mainScene)
cam:SetActive(true)

local fps = engine.Instance("Label")
fps:SetScene(mainScene)
fps.Colour = engine.Colour.new(0, 255, 0)


engine.services.Runservice:OnDraw("draw", function()
    fps.Text = "FPS: ".. tostring(love.timer.getFPS()).. "\nInstances: ".. tostring(#mainScene.Children)
end)