local OrionLib = loadstring(game:HttpGet(('https://githubusercontent.com')))()

-- 1. Создаем основное окно
local Window = OrionLib:MakeWindow({
    Name = "VioGlide MM2", 
    HidePremium = true, 
    SaveConfig = false, 
    IntroText = "⚡"
})
OrionLib:SetTheme("Purple")

-- Докапываемся до UI Orion, чтобы управлять видимостью окна
local MainGui = game:GetService("CoreGui"):FindFirstChild("Orion") or game:GetService("Players").LocalPlayer:WaitForChild("PlayerGui"):FindFirstChild("Orion")
local Container = MainGui and MainGui:FindFirstChild("Main")

-- 2. СОЗДАЕМ КНОПКУ МИНИМИЗАЦИИ (Сверху посередине)
local ScreenGui = Instance.new("ScreenGui")
local ToggleBtn = Instance.new("TextButton")
local UICorner = Instance.new("UICorner")
local UIStroke = Instance.new("UIStroke")

ScreenGui.Name = "VioGlideToggle"
ScreenGui.Parent = game:GetService("CoreGui")
ScreenGui.ResetOnSpawn = false

ToggleBtn.Name = "ToggleBtn"
ToggleBtn.Parent = ScreenGui
ToggleBtn.Size = UDim2.new(0, 45, 0, 45)
ToggleBtn.Position = UDim2.new(0.5, -22, 0, 15) -- Сверху по центру экрана
ToggleBtn.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
ToggleBtn.Text = "⚡"
ToggleBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
ToggleBtn.TextSize = 22
ToggleBtn.Font = Enum.Font.SourceSansBold
ToggleBtn.Active = true
ToggleBtn.Draggable = true -- Можно двигать пальцем, если мешает

UICorner.CornerRadius = UDim.new(1, 0) -- Делаем круглой
UICorner.Parent = ToggleBtn

UIStroke.Thickness = 2
UIStroke.Color = Color3.fromRGB(147, 51, 234) -- Фиолетовая обводка
UIStroke.Parent = ToggleBtn

-- Логика скрытия/открытия меню при нажатии на молнию
ToggleBtn.MouseButton1Click:Connect(function()
    if Container then
        Container.Visible = not Container.Visible
    end
end)

-- 3. ВКЛАДКИ
local TabMain = Window:MakeTab({ Name = "Главная", Icon = "" })
local TabVisuals = Window:MakeTab({ Name = "Визуалы", Icon = "" })

-- АНТИ-ФЛИНГ
TabMain:AddToggle({
    Name = "Анти-Флинг",
    Default = false,
    Callback = function(Value)
        _G.VioAntiFling = Value
        task.spawn(function()
            while _G.VioAntiFling do
                pcall(function()
                    for _, player in pairs(game:GetService("Players"):GetPlayers()) do
                        if player ~= game:GetService("Players").LocalPlayer and player.Character then
                            for _, part in pairs(player.Character:GetChildren()) do
                                if part:IsA("BasePart") then
                                    part.CanCollide = false
                                    part.Velocity = Vector3.new(0, 0, 0)
                                    part.RotVelocity = Vector3.new(0, 0, 0)
                                end
                            end
                        end
                    end
                end)
                task.wait(0.1)
            end
        end)
    end    
})

-- АНТИ-АФК
TabMain:AddToggle({
    Name = "Анти-АФК",
    Default = false,
    Callback = function(Value)
        _G.VioAntiAFK = Value
        if Value then
            local VirtualUser = game:GetService("VirtualUser")
            _G.VioAFKConnect = game:GetService("Players").LocalPlayer.Idled:Connect(function()
                if _G.VioAntiAFK then
                    VirtualUser:CaptureController()
                    VirtualUser:ClickButton2(Vector2.new(0,0))
                end
            end)
        else
            if _G.VioAFKConnect then _G.VioAFKConnect:Disconnect() end
        end
    end    
})

-- ПОЛЕ ЗРЕНИЯ
TabMain:AddSlider({
    Name = "Поле зрения (FOV)",
    Min = 60,
    Max = 120,
    Default = 70,
    Color = Color3.fromRGB(147, 51, 234),
    Increment = 1,
    ValueName = "deg",
    Callback = function(Value)
        workspace.CurrentCamera.FieldOfView = Value
    end    
})

-- УБРАТЬ МЫЛО
TabVisuals:AddButton({
    Name = "Убрать мыло / Буст FPS",
    Callback = function()
        for _, v in pairs(workspace:GetDescendants()) do
            if v:IsA("BasePart") and not v:IsA("MeshPart") then
                v.Material = Enum.Material.SmoothPlastic
            elseif v:IsA("Decal") or v:IsA("Texture") then
                v:Destroy()
            end
        end
    end
})

-- СМЕНА АНИМАЦИЙ
TabVisuals:AddDropdown({
    Name = "Паки анимаций",
    Default = "Стандарт",
    Options = {"Стандарт", "Oldschool", "Ninja", "Toy"},
    Callback = function(Value)
        print("Выбран пак: " .. Value)
    end    
})

OrionLib:Init()
