-- =================================================================
-- VioGlide MM2 | Чистый скрипт без внешних библиотек
-- =================================================================

-- Защита от повторного запуска скрипта
if game:GetService("CoreGui"):FindFirstChild("VioGlide_GUI") then
    game:GetService("CoreGui"):FindFirstChild("VioGlide_GUI"):Destroy()
end
if game:GetService("CoreGui"):FindFirstChild("VioGlideToggle") then
    game:GetService("CoreGui"):FindFirstChild("VioGlideToggle"):Destroy()
end

-- СОЗДАНИЕ ИНТЕРФЕЙСА (ЧИСТЫЙ ROBLOX GUI)
local ScreenGui = Instance.new("ScreenGui")
local MainFrame = Instance.new("Frame")
local Title = Instance.new("TextLabel")
local MenuCorner = Instance.new("UICorner")
local MenuStroke = Instance.new("UIStroke")
local ContentFrame = Instance.new("Frame")
local UIListLayout = Instance.new("UIListLayout")

ScreenGui.Name = "VioGlide_GUI"
ScreenGui.Parent = game:GetService("CoreGui")
ScreenGui.ResetOnSpawn = false

-- Главное окно меню
MainFrame.Name = "MainFrame"
MainFrame.Parent = ScreenGui
MainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
MainFrame.Position = UDim2.new(0.5, -150, 0.5, -100)
MainFrame.Size = UDim2.new(0, 300, 0, 250)
MainFrame.Active = true
MainFrame.Draggable = true
MainFrame.Visible = true

MenuCorner.CornerRadius = UDim.new(0, 10)
MenuCorner.Parent = MainFrame

MenuStroke.Thickness = 2
MenuStroke.Color = Color3.fromRGB(147, 51, 234) -- Неоново-фиолетовая обводка окна
MenuStroke.Parent = MainFrame

-- Заголовок
Title.Name = "Title"
Title.Parent = MainFrame
Title.BackgroundTransparency = 1
Title.Size = UDim2.new(1, 0, 0, 35)
Title.Font = Enum.Font.SourceSansBold
Title.Text = "⚡ VioGlide MM2 ⚡"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.TextSize = 20

-- Контейнер для функций
ContentFrame.Name = "ContentFrame"
ContentFrame.Parent = MainFrame
ContentFrame.BackgroundTransparency = 1
ContentFrame.Position = UDim2.new(0, 10, 0, 40)
ContentFrame.Size = UDim2.new(1, -20, 1, -50)

UIListLayout.Parent = ContentFrame
UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
UIListLayout.Padding = UDim.new(0, 8)

-- ФУНКЦИЯ ДЛЯ ДОБАВЛЕНИЯ КНОПОК-ПЕРЕКЛЮЧАТЕЛЕЙ
local function AddToggle(text, callback)
    local Button = Instance.new("TextButton")
    local BtnCorner = Instance.new("UICorner")
    local BtnStroke = Instance.new("UIStroke")
    local enabled = false
    
    Button.Size = UDim2.new(1, 0, 0, 35)
    Button.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    Button.Font = Enum.Font.SourceSans
    Button.Text = text .. " [ВЫКЛ]"
    Button.TextColor3 = Color3.fromRGB(200, 200, 200)
    Button.TextSize = 16
    Button.Parent = ContentFrame
    
    BtnCorner.CornerRadius = UDim.new(0, 6)
    BtnCorner.Parent = Button
    
    BtnStroke.Thickness = 1
    BtnStroke.Color = Color3.fromRGB(60, 60, 60)
    BtnStroke.Parent = Button
    
    Button.MouseButton1Click:Connect(function()
        enabled = not enabled
        if enabled then
            Button.BackgroundColor3 = Color3.fromRGB(50, 20, 80)
            Button.Text = text .. " [ВКЛ]"
            Button.TextColor3 = Color3.fromRGB(200, 100, 255)
            BtnStroke.Color = Color3.fromRGB(147, 51, 234)
        else
            Button.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
            Button.Text = text .. " [ВЫКЛ]"
            Button.TextColor3 = Color3.fromRGB(200, 200, 200)
            BtnStroke.Color = Color3.fromRGB(60, 60, 60)
        end
        callback(enabled)
    end)
end

-- ФУНКЦИЯ ДЛЯ ОБЫЧНЫХ КНОПОК
local function AddButton(text, callback)
    local Button = Instance.new("TextButton")
    local BtnCorner = Instance.new("UICorner")
    
    Button.Size = UDim2.new(1, 0, 0, 35)
    Button.BackgroundColor3 = Color3.fromRGB(147, 51, 234)
    Button.Font = Enum.Font.SourceSansBold
    Button.Text = text
    Button.TextColor3 = Color3.fromRGB(255, 255, 255)
    Button.TextSize = 16
    Button.Parent = ContentFrame
    
    BtnCorner.CornerRadius = UDim.new(0, 6)
    BtnCorner.Parent = Button
    
    Button.MouseButton1Click:Connect(callback)
end

-- ==================== ПОДКЛЮЧЕНИЕ ФУНКЦИЙ ====================

-- 1. АНТИ-ФЛИНГ
AddToggle("Анти-Флинг", function(state)
    _G.VioAntiFling = state
    if state then
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
end)

-- 2. АНТИ-АФК
AddToggle("Анти-АФК", function(state)
    _G.VioAntiAFK = state
    if state then
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
end)

-- 3. ИЗМЕНЕНИЕ FOV (Кнопка быстрого переключения)
local currentFov = 70
AddButton("Изменить Поле Зрения (FOV: 70 -> 110)", function()
    if currentFov == 70 then
        currentFov = 110
        workspace.CurrentCamera.FieldOfView = 110
    else
        currentFov = 70
        workspace.CurrentCamera.FieldOfView = 70
    end
end)

-- 4. ОПТИМИЗАЦИЯ (УБРАТЬ МЫЛО)
AddButton("Убрать мыло & Оптимизация", function()
    for _, v in pairs(workspace:GetDescendants()) do
        if v:IsA("BasePart") and not v:IsA("MeshPart") then
            v.Material = Enum.Material.SmoothPlastic
        elseif v:IsA("Decal") or v:IsA("Texture") then
            v:Destroy()
        end
    end
end)

-- ==================== КНОПКА МИНИМИЗАЦИИ (⚡) ====================
local ToggleGui = Instance.new("ScreenGui")
local ToggleBtn = Instance.new("TextButton")
local TCorner = Instance.new("UICorner")
local TStroke = Instance.new("UIStroke")

ToggleGui.Name = "VioGlideToggle"
ToggleGui.Parent = game:GetService("CoreGui")
ToggleGui.ResetOnSpawn = false

ToggleBtn.Name = "ToggleBtn"
ToggleBtn.Parent = ToggleGui
ToggleBtn.Size = UDim2.new(0, 45, 0, 45)
ToggleBtn.Position = UDim2.new(0.5, -22, 0, 15) -- Сверху по центру экрана
ToggleBtn.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
ToggleBtn.Text = "⚡"
ToggleBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
ToggleBtn.TextSize = 22
ToggleBtn.Font = Enum.Font.SourceSansBold
ToggleBtn.Active = true
ToggleBtn.Draggable = true

TCorner.CornerRadius = UDim.new(1, 0)
TCorner.Parent = ToggleBtn

TStroke.Thickness = 2
TStroke.Color = Color3.fromRGB(147, 51, 234)
TStroke.Parent = ToggleBtn

ToggleBtn.MouseButton1Click:Connect(function()
    MainFrame.Visible = not MainFrame.Visible
end)
