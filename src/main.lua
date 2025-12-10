local engine = require('prisma')

local mainScene = engine:CreateScene("Main")

local shape = engine.Instance("Shape")
shape:SetScene(mainScene)
shape.Colour = engine.Colour.new(255, 0, 0)

local plr = engine.Instance("Sprite")
plr:SetScene(mainScene)
plr.Image = engine.services.AssetManager.LoadImage("assets/test.png")
plr.Position = engine.Vector2.new(500, 500)

local cam = engine.Instance("Camera")
cam:SetScene(mainScene)
cam:SetActive(true)

local fps = engine.Instance("Label")
fps:SetScene(mainScene)
fps.Colour = engine.Colour.new(0, 255, 0)

engine.services.Runservice:RenderStep("Camera", function(dt)
    local x, y = plr.Position.x, plr.Position.y
    cam.Position = cam.Position:lerp(plr.Position, 0.1)
end)

engine.services.InputService.OnMousedown(function(x, y, button)
    if button == 1 then
        plr.Position = cam:ToWorldSpace(engine.Vector2.new(x, y))
    end
end)

engine.services.Runservice:OnDraw("draw", function()
    fps.Text = "FPS: ".. tostring(love.timer.getFPS()).. "\nInstances: ".. tostring(#mainScene.Children)
end)

local fullscreen = false
engine.services.InputService.OnKeypressed(function(key)
    if key == "f11" then
		fullscreen = not fullscreen
		love.window.setFullscreen(fullscreen, "desktop")
	end
end)