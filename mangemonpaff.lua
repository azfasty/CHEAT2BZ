local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/xHeptc/Kavo-UI-Library/main/source.lua"))()
local Window = Library.CreateLib("ICE SPICE V1", "DarkTheme")
local Tab = Window:NewTab("MAIN")
local Section = Tab:NewSection("SELF")

local flying = false
local speed = 50
local RunService = game:GetService("RunService")
local player = game.Players.LocalPlayer

local hrp
local flyConnection

-- Variables pour la vitesse
local normalSpeed = 16
local fastSpeed = 100
local speedToggleOn = false

-- Fonction pour récupérer le HumanoidRootPart à chaque fois (respawn inclus)
local function updateCharacterParts()
    local character = player.Character or player.CharacterAdded:Wait()
    hrp = character:WaitForChild("HumanoidRootPart")
    local humanoid = character:WaitForChild("Humanoid")
    return character, humanoid
end

-- Appliquer la vitesse en fonction du toggle
local function applySpeed(humanoid)
    if speedToggleOn then
        humanoid.WalkSpeed = fastSpeed
    else
        humanoid.WalkSpeed = normalSpeed
    end
end

-- Initial setup au lancement
local character, humanoid = updateCharacterParts()
applySpeed(humanoid)

-- Écoute le respawn du personnage
player.CharacterAdded:Connect(function(char)
    hrp = char:WaitForChild("HumanoidRootPart")
    humanoid = char:WaitForChild("Humanoid")
    
    -- Reconnecter le vol si actif
    if flying then
        if flyConnection then
            flyConnection:Disconnect()
            flyConnection = nil
        end
        flyConnection = RunService.RenderStepped:Connect(function()
            if flying and hrp then
                hrp.Velocity = Vector3.new(0, speed, 0)
            end
        end)
    end

    -- Re-appliquer la vitesse
    applySpeed(humanoid)
end)

----


---

-- Toggle vol
Section:NewToggle("TU T'ENVOLES DANS LE CIEL ", "DEBUG BY INTERPOL 👹", function(state)
    if state then
        print("Toggle On")
        flying = true
        hrp = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
        if not hrp then
            hrp = player.CharacterAdded:Wait():WaitForChild("HumanoidRootPart")
        end

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

        if hrp then
            hrp.Velocity = Vector3.new(0, 0, 0)
        end
    end
end)

-- Toggle vitesse
Section:NewToggle("cours t’as mère", "bztp sayer", function(state)
    speedToggleOn = state
    local character, humanoid = updateCharacterParts()

    if state then
        print("⚡ Vitesse activée")
    else
        print("🐢 Vitesse normale")
    end

    applySpeed(humanoid)
end)


local noclip = false
local RunService = game:GetService("RunService")

Section:NewKeybind("Noclip", "Appuie pour traverser les murs", Enum.KeyCode.F, function()
	noclip = not noclip
	print(noclip and "🚪 Noclip activé" or "🚧 Noclip désactivé")

	local character = game.Players.LocalPlayer.Character
	if not character then return end

	if noclip then
		-- Activer le noclip à chaque frame
		RunService.Stepped:Connect(function()
			if noclip and character then
				for _, part in pairs(character:GetDescendants()) do
					if part:IsA("BasePart") and part.CanCollide == true then
						part.CanCollide = false
					end
				end
			end
		end)
	else
		-- Désactiver le noclip
		for _, part in pairs(character:GetDescendants()) do
			if part:IsA("BasePart") then
				part.CanCollide = true
			end
		end
	end
end)


local Tab = Window:NewTab("PLAYERS")

Section:NewTextBox("Player", "Met ton joueur fdp", function(txt)
	print(txt)
end)





local Tab = Window:NewTab("SETTINGS")
local Section = Tab:NewSection("BINDS")
Section:NewKeybind("Touche pour m'ouvrir 😇", "Chez ton père", Enum.KeyCode.F, function()
    Library:ToggleUI()
end)
