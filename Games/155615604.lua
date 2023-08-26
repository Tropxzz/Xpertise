-- [Varibles]
local plr = game.Players.LocalPlayer
local char = plr.Character
local hum = char.Humanoid
local hrp = char.HumanoidRootPart
local connections = {}
local cam = game.Workspace.Camera
local fornotifications = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()
local FLYING = false
local Mouse = plr:GetMouse()
local vfly = 1
local iyflyspeed = 1

-- [Services]
local runService = game:GetService("RunService")
local UserInputService = game.UserInputService
local Players = game.Players
local Workspace = workspace

-- ISONMOBLIE
local IsOnMobile = table.find({Enum.Platform.IOS, Enum.Platform.Android}, UserInputService:GetPlatform())

-- [Aimbot shit]
local Camera = workspace.CurrentCamera
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local LocalPlayer = Players.LocalPlayer
local Holding = false

_G.AimbotEnabled = true
_G.TeamCheck = true -- If set to true then the script would only lock your aim at enemy team members.
_G.AimPart = "Head" -- Where the aimbot script would lock at.
_G.Sensitivity = 0 -- How many seconds it takes for the aimbot script to officially lock onto the target's aimpart.

-- [Functions]

local function GetClosestPlayer()
	local MaximumDistance = math.huge
	local Target = nil
  
  	coroutine.wrap(function()
    		wait(20); MaximumDistance = math.huge -- Reset the MaximumDistance so that the Aimbot doesn't remember it as a very small variable and stop capturing players...
  	end)()

	for _, v in next, Players:GetPlayers() do
		if v.Name ~= LocalPlayer.Name then
			if _G.TeamCheck == true then
				if v.Team ~= LocalPlayer.Team then
					if v.Character ~= nil then
						if v.Character:FindFirstChild("HumanoidRootPart") ~= nil then
							if v.Character:FindFirstChild("Humanoid") ~= nil and v.Character:FindFirstChild("Humanoid").Health ~= 0 then
								local ScreenPoint = Camera:WorldToScreenPoint(v.Character:WaitForChild("HumanoidRootPart", math.huge).Position)
								local VectorDistance = (Vector2.new(UserInputService:GetMouseLocation().X, UserInputService:GetMouseLocation().Y) - Vector2.new(ScreenPoint.X, ScreenPoint.Y)).Magnitude
								
								if VectorDistance < MaximumDistance then
									Target = v
                  							MaximumDistance = VectorDistance
								end
							end
						end
					end
				end
			else
				if v.Character ~= nil then
					if v.Character:FindFirstChild("HumanoidRootPart") ~= nil then
						if v.Character:FindFirstChild("Humanoid") ~= nil and v.Character:FindFirstChild("Humanoid").Health ~= 0 then
							local ScreenPoint = Camera:WorldToScreenPoint(v.Character:WaitForChild("HumanoidRootPart", math.huge).Position)
							local VectorDistance = (Vector2.new(UserInputService:GetMouseLocation().X, UserInputService:GetMouseLocation().Y) - Vector2.new(ScreenPoint.X, ScreenPoint.Y)).Magnitude
							
							if VectorDistance < MaximumDistance then
								Target = v
               							MaximumDistance = VectorDistance
							end
						end
					end
				end
			end
		end
	end

	return Target
end

function NOFLY()
	FLYING = false
	if flyKeyDown or flyKeyUp then flyKeyDown:Disconnect() flyKeyUp:Disconnect() end
	if hum then
		Players.LocalPlayer.Character:FindFirstChildOfClass('Humanoid').PlatformStand = false
	end
	pcall(function() workspace.CurrentCamera.CameraType = Enum.CameraType.Custom end)
end

function getRoot(char)
	local rootPart = char:FindFirstChild('HumanoidRootPart') or char:FindFirstChild('Torso') or char:FindFirstChild('UpperTorso')
	return rootPart
end

   local function ShowESP()
    for _, player in ipairs(game.Players:GetPlayers()) do
        -- Create an ESP object for each player and adjust its properties
        local esp = Instance.new("BoxHandleAdornment")
        esp.Adornee = player.Character:FindFirstChild("HumanoidRootPart")
        esp.Size = esp.Adornee.Size
        esp.Color3 = Color3.fromRGB(255, 0, 0) -- Choose your desired color
        esp.Transparency = 0.5 -- Choose your desired transparency
        esp.ZIndex = 5
        esp.AlwaysOnTop = true
        esp.Visible = true
        esp.Parent = esp.Adornee
    end
end

local function DisableESP()
    for _, player in ipairs(game.Players:GetPlayers()) do
        -- Find and remove the ESP object from each player
        local esp = player.Character.HumanoidRootPart:FindFirstChild("BoxHandleAdornment")
        if esp then
            esp:Destroy()
        end
    end
end

function sFLY(vfly)
	repeat wait() until Players.LocalPlayer and Players.LocalPlayer.Character and getRoot(Players.LocalPlayer.Character) and Players.LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
	repeat wait() until Mouse
	if flyKeyDown or flyKeyUp then flyKeyDown:Disconnect() flyKeyUp:Disconnect() end

	local T = getRoot(Players.LocalPlayer.Character)
	local CONTROL = {F = 0, B = 0, L = 0, R = 0, Q = 0, E = 0}
	local lCONTROL = {F = 0, B = 0, L = 0, R = 0, Q = 0, E = 0}
	local SPEED = 0

	local function FLY()
		FLYING = true
		local BG = Instance.new('BodyGyro')
		local BV = Instance.new('BodyVelocity')
		BG.P = 9e4
		BG.Parent = T
		BV.Parent = T
		BG.maxTorque = Vector3.new(9e9, 9e9, 9e9)
		BG.cframe = T.CFrame
		BV.velocity = Vector3.new(0, 0, 0)
		BV.maxForce = Vector3.new(9e9, 9e9, 9e9)
		task.spawn(function()
			repeat wait()
				if not vfly and Players.LocalPlayer.Character:FindFirstChildOfClass('Humanoid') then
					Players.LocalPlayer.Character:FindFirstChildOfClass('Humanoid').PlatformStand = true
				end
				if CONTROL.L + CONTROL.R ~= 0 or CONTROL.F + CONTROL.B ~= 0 or CONTROL.Q + CONTROL.E ~= 0 then
					SPEED = 50
				elseif not (CONTROL.L + CONTROL.R ~= 0 or CONTROL.F + CONTROL.B ~= 0 or CONTROL.Q + CONTROL.E ~= 0) and SPEED ~= 0 then
					SPEED = 0
				end
				if (CONTROL.L + CONTROL.R) ~= 0 or (CONTROL.F + CONTROL.B) ~= 0 or (CONTROL.Q + CONTROL.E) ~= 0 then
					BV.velocity = ((workspace.CurrentCamera.CoordinateFrame.lookVector * (CONTROL.F + CONTROL.B)) + ((workspace.CurrentCamera.CoordinateFrame * CFrame.new(CONTROL.L + CONTROL.R, (CONTROL.F + CONTROL.B + CONTROL.Q + CONTROL.E) * 0.2, 0).p) - workspace.CurrentCamera.CoordinateFrame.p)) * SPEED
					lCONTROL = {F = CONTROL.F, B = CONTROL.B, L = CONTROL.L, R = CONTROL.R}
				elseif (CONTROL.L + CONTROL.R) == 0 and (CONTROL.F + CONTROL.B) == 0 and (CONTROL.Q + CONTROL.E) == 0 and SPEED ~= 0 then
					BV.velocity = ((workspace.CurrentCamera.CoordinateFrame.lookVector * (lCONTROL.F + lCONTROL.B)) + ((workspace.CurrentCamera.CoordinateFrame * CFrame.new(lCONTROL.L + lCONTROL.R, (lCONTROL.F + lCONTROL.B + CONTROL.Q + CONTROL.E) * 0.2, 0).p) - workspace.CurrentCamera.CoordinateFrame.p)) * SPEED
				else
					BV.velocity = Vector3.new(0, 0, 0)
				end
				BG.cframe = workspace.CurrentCamera.CoordinateFrame
			until not FLYING
			CONTROL = {F = 0, B = 0, L = 0, R = 0, Q = 0, E = 0}
			lCONTROL = {F = 0, B = 0, L = 0, R = 0, Q = 0, E = 0}
			SPEED = 0
			BG:Destroy()
			BV:Destroy()
			if Players.LocalPlayer.Character:FindFirstChildOfClass('Humanoid') then
				Players.LocalPlayer.Character:FindFirstChildOfClass('Humanoid').PlatformStand = false
			end
		end)
	end
	flyKeyDown = Mouse.KeyDown:Connect(function(KEY)
		if KEY:lower() == 'w' then
			CONTROL.F = (vfly and vehicleflyspeed or iyflyspeed)
		elseif KEY:lower() == 's' then
			CONTROL.B = - (vfly and vehicleflyspeed or iyflyspeed)
		elseif KEY:lower() == 'a' then
			CONTROL.L = - (vfly and vehicleflyspeed or iyflyspeed)
		elseif KEY:lower() == 'd' then 

			CONTROL.R = (vfly and vehicleflyspeed or iyflyspeed)
		elseif QEfly and KEY:lower() == 'e' then
			CONTROL.Q = (vfly and vehicleflyspeed or iyflyspeed)*2
		elseif QEfly and KEY:lower() == 'q' then
			CONTROL.E = -(vfly and vehicleflyspeed or iyflyspeed)*2
		end
		pcall(function() workspace.CurrentCamera.CameraType = Enum.CameraType.Track end)
	end)
	flyKeyUp = Mouse.KeyUp:Connect(function(KEY)
		if KEY:lower() == 'w' then
			CONTROL.F = 0
		elseif KEY:lower() == 's' then
			CONTROL.B = 0
		elseif KEY:lower() == 'a' then
			CONTROL.L = 0
		elseif KEY:lower() == 'd' then
			CONTROL.R = 0
		elseif KEY:lower() == 'e' then
			CONTROL.Q = 0
		elseif KEY:lower() == 'q' then
			CONTROL.E = 0
		end
	end)
	FLY()
end


local function teleport(cframe)
        connections["Heartbeat"] = runService.Heartbeat:Connect(function()
            local oldVelocity = hrp.Velocity

            hrp.Velocity = Vector3.new(0, -550, 0)
            runService.RenderStepped:Wait()
            hrp.Velocity = oldVelocity

            task.wait(.4)
            connections["Heartbeat"]:Disconnect()
        end)

        task.wait(.2)
        hrp.CFrame = cframe
    end

    function Notify(T, C, D)
fornotifications:Notify({
   Title = T,
   Content = C,
   Duration = D,
   Image = 4483362458,
   Actions = { -- Notification Buttons
      Ignore = {
         Name = "Okay!",
         Callback = function()
      end
   },
},
})
    end

-- [UI START UP]
local ui = loadstring(game:HttpGet("https://raw.githubusercontent.com/laderite/bleklib/main/library.lua"))()

local win = ui:Create({
    Name = "Xpertise",
    StartupSound = {
        Toggle = false,
        SoundID = "rbxassetid://6958727243",
        TimePosition = 1
    }
})

local Player = win:Tab('Player')
local GunMods = win:Tab('Gun Mods')
local RA = win:Tab('Remote Abusing')
local V = win:Tab('Visuals')
local Misc = win:Tab('Misc')
local Settings = win:Tab('Settings')

--[[ 
    [Code]
    [Player]
]]

Player:Slider('FOV', 70, 70, 1000, function(v) -- default, 10 -- min, 300 -- max, function(a)
    cam.FieldOfView = v
end)

Player:Slider('WalkSpeed', 16, 16, 1000, function(v) -- default, 10 -- min, 300 -- max, function(a)
    hum.WalkSpeed = v
end)

Player:Slider('JumpPower', 50, 50, 1000, function(v) -- default, 10 -- min, 300 -- max, function(a)
    hum.JumpPower = v
end)

Player:Toggle('Fly from IY (PC)', function(v)
if v then
       if not IsOnMobile then
		NOFLY()
		wait()
		sFLY()
        else
        Notify("error", "ur not on pc", 1.1)         
      end
      else
     NOFLY()
    end
end)

local nc
Player:Toggle('Noclip', function(v)
    if v then
     for i,v in pairs(char:GetChildren()) do
      nc = v
      if v:IsA("Part") or v:IsA("MeshPart") then
        v.CanCollide = false
      end
     end
     else
     if nc:IsA("Part") or nc:IsA("MeshPart") then
       nc.CanCollide = true
     end
    end
end)

Player:Textbox('To', function(v)
       v = v:lower() -- Convert input to lowercase for case-insensitive comparison
    local targetPlayer = nil

    for _, player in pairs(game.Players:GetPlayers()) do
        local playerName = player.Name:lower() -- Convert player name to lowercase
        if playerName:sub(1, #v) == v then
            targetPlayer = player
            break
        end
    end

    if targetPlayer then
        teleport(targetPlayer.Character.HumanoidRootPart.CFrame)
    else
        print("Player not found.")
    end
end)

-- [Gun Mods >:)]

GunMods:Button('Remington 870', function()
    local gunStates

if game.Players.LocalPlayer.Backpack:FindFirstChild("Remington 870") then
    gunStates = require(game.Players.LocalPlayer.Backpack["Remington 870"].GunStates)
elseif game.Players.LocalPlayer.Character["Remington 870"] then
    gunStates = require(game.Players.LocalPlayer.Character["Remington 870"].GunStates)
end

if gunStates then
    gunStates.MaxAmmo = math.huge
    gunStates.CurrentAmmo = math.huge
    gunStates.FireRate = 0.000000001
    gunStates.AutoFire = true

    local ins = Instance.new("Animation")
    ins.Name = "best ongongongoog"
    ins.AnimationId = "rbxassetid://14572961720"

    gunStates.ShootAnim = ins
    print(gunStates.ShootAnim)
else
    print("GunStates not found")
end
end)

GunMods:Button('Ak-47', function()
    local gunStates

if game.Players.LocalPlayer.Backpack:FindFirstChild("AK-47") then
    gunStates = require(game.Players.LocalPlayer.Backpack["AK-47"].GunStates)
elseif game.Players.LocalPlayer.Character["AK-47"] then
    gunStates = require(game.Players.LocalPlayer.Character["AK-47"].GunStates)
end

if gunStates then
    gunStates.MaxAmmo = math.huge
    gunStates.CurrentAmmo = math.huge
    gunStates.FireRate = 0.000000001
    gunStates.AutoFire = true
    local ins = Instance.new("Animation")
    ins.Name = "best ongongongoog"
    ins.AnimationId = "rbxassetid://14572961720"

    gunStates.ShootAnim = ins
    print(gunStates.ShootAnim)
else
    print("GunStates not found")
end
end)

GunMods:Button('M9', function()
    local gunStates

if game.Players.LocalPlayer.Backpack:FindFirstChild("M9") then
    gunStates = require(game.Players.LocalPlayer.Backpack["M9"].GunStates)
elseif game.Players.LocalPlayer.Character["M9"] then
    gunStates = require(game.Players.LocalPlayer.Character["M9"].GunStates)
    else
    print("No M9 ")
end

if gunStates then
    gunStates.MaxAmmo = math.huge
    gunStates.CurrentAmmo = math.huge
    gunStates.FireRate = 0.000000001
    gunStates.AutoFire = true

    local ins = Instance.new("Animation")
    ins.Name = "best ongongongoog"
    ins.AnimationId = "rbxassetid://14572961720"

    gunStates.ShootAnim = ins
    print(gunStates.ShootAnim)
else
    print("GunStates not found")
end
end)

GunMods:Button('Taser', function()
    local gunStates

if game.Players.LocalPlayer.Backpack:FindFirstChild("Taser") then
    gunStates = require(game.Players.LocalPlayer.Backpack["Taser"].GunStates)
elseif game.Players.LocalPlayer.Character["Taser"] then
    gunStates = require(game.Players.LocalPlayer.Character["Taser"].GunStates)
    else
    print("No Taser ")
end

if gunStates then
    gunStates.MaxAmmo = math.huge
    gunStates.CurrentAmmo = math.huge
    gunStates.FireRate = 0.000000001
    gunStates.AutoFire = true

    local ins = Instance.new("Animation")
    ins.Name = "best ongongongoog"
    ins.AnimationId = "rbxassetid://14572961720"

    gunStates.ShootAnim = ins
    print(gunStates.ShootAnim)
else
    print("GunStates not found")
end
end)

GunMods:Button('M4A1', function()
    local gunStates

if game.Players.LocalPlayer.Backpack:FindFirstChild("M4A1") then
    gunStates = require(game.Players.LocalPlayer.Backpack["M4A1"].GunStates)
elseif game.Players.LocalPlayer.Character["M4A1"] then
    gunStates = require(game.Players.LocalPlayer.Character["M4A1"].GunStates)
    else
    print("No M4A1 ")
end

if gunStates then
    gunStates.MaxAmmo = math.huge
    gunStates.CurrentAmmo = math.huge
    gunStates.FireRate = 0.000000001
    gunStates.AutoFire = true

    local ins = Instance.new("Animation")
    ins.Name = "best ongongongoog"
    ins.AnimationId = "rbxassetid://14572961720"

    gunStates.ShootAnim = ins
    print(gunStates.ShootAnim)
else
    print("GunStates not found")
end
end)

-- [Remote abusing (this is gonna be fun)]
RA:Textbox('Arrest', function(daplr)
    daplr = daplr:lower() -- Convert input to lowercase for case-insensitive comparison
    local targetPlayer = nil

    for _, player in pairs(game.Players:GetPlayers()) do
        local playerName = player.Name:lower() -- Convert player name to lowercase
        if playerName:sub(1, #daplr) == daplr then
            targetPlayer = player
            break
        end
    end
    targetPlayer = targetPlayer.Name

    if targetPlayer then
local hrpCFrame = Instance.new("Part",workspace)
   hrpCFrame.CFrame = game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame
   hrpCFrame.Anchored = true
   hrpCFrame.CanCollide = false
   hrpCFrame.Transparency = 1
   game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = game.Players[targetPlayer].Character.HumanoidRootPart.CFrame
   wait(0)
workspace.Remote.arrest:InvokeServer(game.Players[targetPlayer].Character:FindFirstChild("Left Leg"))
wait()
game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = hrpCFrame.CFrame
   hrpCFrame:Destroy()

local hrpCFrame = Instance.new("Part",workspace)
   hrpCFrame.CFrame = game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame
   hrpCFrame.Anchored = true
   hrpCFrame.CanCollide = false
   hrpCFrame.Transparency = 1
   game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = game.Players[targetPlayer].Character.HumanoidRootPart.CFrame
   wait(0)
workspace.Remote.arrest:InvokeServer(game.Players[targetPlayer].Character:FindFirstChild("Left Leg"))
wait()
game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = hrpCFrame.CFrame
   hrpCFrame:Destroy()

local hrpCFrame = Instance.new("Part",workspace)
   hrpCFrame.CFrame = game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame
   hrpCFrame.Anchored = true
   hrpCFrame.CanCollide = false
   hrpCFrame.Transparency = 1
   game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = game.Players[targetPlayer].Character.HumanoidRootPart.CFrame
   wait(0)
workspace.Remote.arrest:InvokeServer(game.Players[targetPlayer].Character:FindFirstChild("Left Leg"))
wait()
game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = hrpCFrame.CFrame
   hrpCFrame:Destroy()

local hrpCFrame = Instance.new("Part",workspace)
   hrpCFrame.CFrame = game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame
   hrpCFrame.Anchored = true
   hrpCFrame.CanCollide = false
   hrpCFrame.Transparency = 1
   game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = game.Players[targetPlayer].Character.HumanoidRootPart.CFrame
   wait(0)
workspace.Remote.arrest:InvokeServer(game.Players[targetPlayer].Character:FindFirstChild("Left Leg"))
wait()
game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = hrpCFrame.CFrame
   hrpCFrame:Destroy()

local hrpCFrame = Instance.new("Part",workspace)
   hrpCFrame.CFrame = game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame
   hrpCFrame.Anchored = true
   hrpCFrame.CanCollide = false
   hrpCFrame.Transparency = 1
   game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = game.Players[targetPlayer].Character.HumanoidRootPart.CFrame
   wait(0)
workspace.Remote.arrest:InvokeServer(game.Players[targetPlayer].Character:FindFirstChild("Left Leg"))
wait()
game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = hrpCFrame.CFrame
   hrpCFrame:Destroy()

local hrpCFrame = Instance.new("Part",workspace)
   hrpCFrame.CFrame = game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame
   hrpCFrame.Anchored = true
   hrpCFrame.CanCollide = false
   hrpCFrame.Transparency = 1
   game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = game.Players[targetPlayer].Character.HumanoidRootPart.CFrame
   wait(0)
workspace.Remote.arrest:InvokeServer(game.Players[targetPlayer].Character:FindFirstChild("Left Leg"))
wait()
game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = hrpCFrame.CFrame
   hrpCFrame:Destroy()

local hrpCFrame = Instance.new("Part",workspace)
   hrpCFrame.CFrame = game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame
   hrpCFrame.Anchored = true
   hrpCFrame.CanCollide = false
   hrpCFrame.Transparency = 1
   game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = game.Players[targetPlayer].Character.HumanoidRootPart.CFrame
   wait(0)
workspace.Remote.arrest:InvokeServer(game.Players[targetPlayer].Character:FindFirstChild("Left Leg"))
wait()
game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = hrpCFrame.CFrame
   hrpCFrame:Destroy()

local hrpCFrame = Instance.new("Part",workspace)
   hrpCFrame.CFrame = game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame
   hrpCFrame.Anchored = true
   hrpCFrame.CanCollide = false
   hrpCFrame.Transparency = 1
   game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = game.Players[targetPlayer].Character.HumanoidRootPart.CFrame
   wait(0)
workspace.Remote.arrest:InvokeServer(game.Players[targetPlayer].Character:FindFirstChild("Left Leg"))
wait()
game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = hrpCFrame.CFrame
   hrpCFrame:Destroy()
    else
        print("Player not found.")
    end
end)

-- [Visuals]

V:Toggle('Aimbot (color doesnt work)', function(v)
_G.AimbotEnabled = v

if v then
while _G.AimbotEnabled == true do
            local closestPlayer = GetClosestPlayer()
                local aimPartPosition = closestPlayer.Character[_G.AimPart].Position
                local aimCFrame = CFrame.new(Camera.CFrame.Position, aimPartPosition)
                TweenService:Create(Camera, TweenInfo.new(_G.Sensitivity, Enum.EasingStyle.Sine, Enum.EasingDirection.Out), {CFrame = aimCFrame}):Play()
                wait(0.3)
            end
            else
            print('s')
            end
end)

V:Toggle("Esp", function(v)
 if v ~= false then
ShowESP()
else
DisableESP()
 end
end)

-- [Misc]

Misc:Button('Auto Report (ty the person i skidded from)', function(callback)
    local lib = {
	['notification'] = loadstring(game:HttpGet(("https://raw.githubusercontent.com/AbstractPoo/Main/main/Notifications.lua"), true))(),
	['cooldown'] = false,
	['username'] = 'unknown',
	['bw'] = 'unknown'
}

local words = {
	['gay'] = 'Bullying',
	['trans'] = 'Bullying',
	['lgbt'] = 'Bullying',
	['lesbian'] = 'Bullying',
	['suicide'] = 'Bullying',
	['cum'] = 'Swearing',
	['f@g0t'] = 'Bullying',
	['cock'] = 'Swearing',
	['penis'] = 'Swearing',
	['furry'] = 'Bullying',
	['furries'] = 'Bullying',
	['dick'] = 'Swearing',
	['nigger'] = 'Bullying',
	['bible'] = 'Bullying',
	['nigga'] = 'Bullying',
	['cheat'] = 'Scamming',
	['report'] = 'Bullying',
	['niga'] = 'Bullying',
	['bitch'] = 'Bullying',
	['sex'] = 'Swearing',
	['cringe'] = 'Bullying',
	['trash'] = 'Bullying',
	['allah'] = 'Bullying',
	['dumb'] = 'Bullying',
	['idiot'] = 'Bullying',
	['kid'] = 'Bullying',
	['clown'] = 'Bullying',
	['bozo'] = 'Bullying',
	['faggot'] = 'Bullying',
	['autist'] = 'Bullying',
	['autism'] = 'Bullying',
	['get a life'] = 'Bullying',
	['nolife'] = 'Bullying',
	['no life'] = 'Bullying',
	['adopted'] = 'Bullying',
	['skill issue'] = 'Bullying',
	['muslim'] = 'Bullying',
	['gender'] = 'Bullying',
	['parent'] = 'Bullying',
	['islam'] = 'Bullying',
	['christian'] = 'Bullying',
	['noob'] = 'Bullying',
	['retard'] = 'Bullying',
	['burn'] = 'Bullying',
	['stupid'] = 'Bullying',
	['wthf'] = 'Swearing',
	['pride'] = 'Bullying',
	['mother'] = 'Bullying',
	['father'] = 'Bullying',
	['homo'] = 'Bullying',
	['hate'] = 'Bullying',
	['exploit'] = 'Scamming',
	['hack'] = 'Scamming',
	['download'] = 'Scamming',
	['youtube'] = 'Offsite Links',
    ['Tropxz'] = 'Bullying',
    ['Hacker'] = "Bullying"
}

local players = game:GetService('Players')
local user = game:GetService('Players').LocalPlayer

function lib.notify()
	lib.notification:message{
		Title = "AutoReport",
		Description = "Reported " .. lib.username .. ' for saying "' .. lib.bw .. '"',
		Icon = 6023426926
	}
end

function lib.report(user, name, rs)
	if user and lib.cooldown == false then
		lib.username = name
		local suc, er = pcall(function()
			players:ReportAbuse(players:FindFirstChild(name), rs, 'breaking TOS')
		end)
		if not suc then
			return warn("Couldn't report due to the reason: " .. er .. ' | AR')
		else
			lib.notify()
		end
		lib.cooldown = true
		task.wait(5)
		lib.username = 'unknown'
		lib.bw = 'unknown'
		lib.cooldown = false
	end
end

players.PlayerChatted:Connect(function(chatType, plr, msg)
	msg = string.lower(msg)
	if chatType ~= Enum.PlayerChatType.Whisper and plr ~= user then
		for i, v in next, words do
			if string.find(msg, i) then
				lib.bw = i
				lib.report(plr.UserId, plr.Name,v)
			end
		end
	end
end)

lib.notification:message{
	Title = "AutoReport",
	Description = "loaded",
	Icon = 6023426926
}
end)

Misc:Button('Destroy GUI', function()
    win:Exit()
end)

Misc:Button('Police Team', function()
              Workspace.Remote.TeamEvent:FireServer("Bright blue")
                if #game:GetService("Teams").Guards:GetPlayers() >= 8 then
   
                    game:GetService("Players").LocalPlayer.PlayerGui.Home.hud.AddedGui.tooltip.TextLabel.TextXAlignment = "Left"
                    require(game:GetService("ReplicatedStorage").Modules_client.TooltipModule).update("")
                    local v1 = "  ".."Guard team is full, try again later."
                    for v2 = 1, #v1 do
                        game:GetService("Players").LocalPlayer.PlayerGui.Home.hud.AddedGui.tooltip.TextLabel.Text = string.sub(v1, 1, v2)
                    wait(0.05)
                    end
   
                end
end)

Misc:Button('Naturel Team', function()
      Workspace.Remote.TeamEvent:FireServer("Medium stone grey")
end)

Misc:Button('Inmate', function()
               Workspace.Remote.TeamEvent:FireServer("Bright orange")
end)

Misc:Button('Crim', function()
Crim = game.Workspace["Criminals Spawn"].SpawnLocation
       Crim.CanCollide = false
       Crim.Size = Vector3.new(51.05, 24.12, 54.76)
       Crim.CFrame = game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame
       Crim.Transparency = 1
      wait()
       Crim.CFrame = CFrame.new(-920.510803, 92.2271957, 2138.27002, 0, 0, -1, 0, 1, 0, 1, 0, 0)
       Crim.Size = Vector3.new(6, 0.2, 6)
       Crim.Transparency = 0
end)

-- [Settings]
Settings:Slider('FLyspeed', 1,1,1000, function(v)
iyflyspeed = v
end)

Settings:Textbox('FLyspeed', function(v)
iyflyspeed = v
end)

game:GetService("Players").LocalPlayer.PlayerGui.Home.hud.AddedGui.tooltip.TextLabel.TextXAlignment = "Left"
require(game:GetService("ReplicatedStorage").Modules_client.TooltipModule).update("")
local v1 = "  ".."Made by tropx__z#0, Xpertise on top."
for v2 = 1, #v1 do
   game:GetService("Players").LocalPlayer.PlayerGui.Home.hud.AddedGui.tooltip.TextLabel.Text = string.sub(v1, 1, v2)
end

