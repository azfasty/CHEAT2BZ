local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/xHeptc/Kavo-UI-Library/main/source.lua"))()
local Window = Library.CreateLib("LE KZ", "DarkTheme")
local Tab = Window:NewTab("LE PAFF A NEYZ")
local Section = Tab:NewSection("LE ZIZOU ESP")

local flying = false
local speed = 50
local RunService = game:GetService("RunService")
local player = game.Players.LocalPlayer

local hrp
local flyConnection

-- Fonction pour toujours récupérer le HumanoidRootPart actuel
local function getHRP()
	local character = player.Character or player.CharacterAdded:Wait()
	return character:WaitForChild("HumanoidRootPart")
end

Section:NewToggle("TU T'ENVOLES DANS LE CIEL ", "DEBUG BY INTERPOL 👹", function(state)
    if state then
        print("Toggle On")
        flying = true
        hrp = getHRP()

        flyConnection = RunService.RenderStepped:Connect(function()
            if flying and hrp then
                hrp.Velocity = Vector3.new(0, speed, 0)
            end
        end)
    else
        print("Toggle Off")
        flying = false
        if flyConnection then
            flyConnection:Disconnect()
            flyConnection = nil
        end

        -- Toujours vérifier si le personnage est encore là avant de modifier sa vitesse
        if hrp then
            hrp.Velocity = Vector3.new(0, 0, 0)
        end
    end
end)
