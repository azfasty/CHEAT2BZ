local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/xHeptc/Kavo-UI-Library/main/source.lua"))()
local Window = Library.CreateLib("ICE SPICE V1", "BloodTheme")
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

----------##############
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local player = game.Players.LocalPlayer
local mouse = player:GetMouse()

local flying = false
local speed = 50
local flyConnection

local function startFly()
    local character = player.Character or player.CharacterAdded:Wait()
    local hrp = character:WaitForChild("HumanoidRootPart")
    local humanoid = character:WaitForChild("Humanoid")

    humanoid.PlatformStand = true -- Désactive physique standard (chute, gravité)

    flyConnection = RunService.RenderStepped:Connect(function()
        if not flying then return end

        local moveVector = Vector3.new(0, 0, 0)

        -- Récupère les touches ZQSD (WASD) pour déplacement
        if UserInputService:IsKeyDown(Enum.KeyCode.W) then
            moveVector = moveVector + (workspace.CurrentCamera.CFrame.LookVector)
        end
        if UserInputService:IsKeyDown(Enum.KeyCode.S) then
            moveVector = moveVector - (workspace.CurrentCamera.CFrame.LookVector)
        end
        if UserInputService:IsKeyDown(Enum.KeyCode.A) then
            moveVector = moveVector - (workspace.CurrentCamera.CFrame.RightVector)
        end
        if UserInputService:IsKeyDown(Enum.KeyCode.D) then
            moveVector = moveVector + (workspace.CurrentCamera.CFrame.RightVector)
        end

        -- Montée / Descente avec E (haut) et Q (bas)
        if UserInputService:IsKeyDown(Enum.KeyCode.E) then
            moveVector = moveVector + Vector3.new(0, 1, 0)
        end
        if UserInputService:IsKeyDown(Enum.KeyCode.Q) then
            moveVector = moveVector - Vector3.new(0, 1, 0)
        end

        -- Normalize pour garder la vitesse constante quand diagonal
        if moveVector.Magnitude > 0 then
            moveVector = moveVector.Unit * speed
        end

        -- Applique la vélocité
        hrp.Velocity = moveVector
        hrp.RotVelocity = Vector3.new(0, 0, 0) -- pour éviter rotation bizarre
    end)
end

local function stopFly()
    flying = false
    local character = player.Character
    if not character then return end
    local hrp = character:FindFirstChild("HumanoidRootPart")
    local humanoid = character:FindFirstChild("Humanoid")
    if hrp then
        hrp.Velocity = Vector3.new(0, 0, 0)
    end
    if humanoid then
        humanoid.PlatformStand = false
    end
    if flyConnection then
        flyConnection:Disconnect()
        flyConnection = nil
    end
end

-- Keybind toggle Fly (ici avec ta Section:NewKeybind)
Section:NewKeybind("Fly toggle", "Appuie sur F pour fly / atterrir", Enum.KeyCode.F, function()
    flying = not flying
    if flying then
        print("✈️ Fly activé")
        startFly()
    else
        print("🛬 Fly désactivé")
        stopFly()
    end
end)

-----------##########


local Tab = Window:NewTab("PLAYERS")
local Section = Tab:NewSection("PLAYERS")

local Players = game:GetService("Players")
local player = Players.LocalPlayer
local targetName = nil

-- TextBox pour entrer le pseudo du joueur
Section:NewTextBox("Player", "Met ton joueur fdp", function(txt)
    targetName = txt
    print("👤 Joueur ciblé :", targetName)
end)

-- Bouton Steal Outfit
Section:NewButton("Steal Outfit", "Vole son drip 💀", function()
    if not targetName then
        warn("⚠️ Aucun joueur entré")
        return
    end

    local target = Players:FindFirstChild(targetName)
    if not target then
        warn("❌ Joueur introuvable")
        return
    end

    local targetCharacter = target.Character
    local myCharacter = player.Character
    if not (targetCharacter and myCharacter) then
        warn("❌ Les deux personnages doivent être chargés")
        return
    end

    -- Supprimer les accessoires et vêtements existants
    for _, item in ipairs(myCharacter:GetChildren()) do
        if item:IsA("Accessory") or item:IsA("Shirt") or item:IsA("Pants") or item:IsA("CharacterMesh") then
            item:Destroy()
        end
    end

    -- Copier accessoires et vêtements
    for _, item in ipairs(targetCharacter:GetChildren()) do
        if item:IsA("Accessory") or item:IsA("Shirt") or item:IsA("Pants") or item:IsA("CharacterMesh") then
            local clone = item:Clone()
            clone.Parent = myCharacter
        end
    end

    -- Copier HumanoidDescription pour plus de fiabilité (si R15)
    local humanoid = myCharacter:FindFirstChildOfClass("Humanoid")
    local targetHumanoid = targetCharacter:FindFirstChildOfClass("Humanoid")
    if humanoid and targetHumanoid then
        local description = targetHumanoid:GetAppliedDescription()
        humanoid:ApplyDescription(description)
    end

    print("✅ Outfit volé à :", targetName)
end)





local Tab = Window:NewTab("SETTINGS")
local Section = Tab:NewSection("BINDS")
Section:NewKeybind("Touche pour m'ouvrir 😇", "Chez ton père", Enum.KeyCode.F, function()
    Library:ToggleUI()
end)
