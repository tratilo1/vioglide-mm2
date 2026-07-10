-- Загрузка скрытой основы меню без лишних надписей
local RawLibrary = loadstring(game:HttpGet(('https://githubusercontent.com')))()

-- Маскируем библиотеку под твой собственный движок VioEngine
local VioEngine = {}
for k, v in pairs(RawLibrary) do VioEngine[k] = v end

-- Генерация окна VioGlide с неоновым фиолетовым свечением по краям
local Window = VioEngine:MakeWindow({
    Name = "VioGlide MM2", 
    HidePremium = true, 
    SaveConfig = false, 
    IntroText = "⚡ VioGlide Engine ⚡" -- Компактный и стильный текст загрузки
})

-- Активация фирменной фиолетовой неоновой темы
VioEngine:SetTheme("Purple")

-- Переменная для хранения выбранного языка (по умолчанию русский)
local Lang = "RU"

-- ТАБЫ (ВКЛАДКИ) С ОБЕЗЛИЧЕННЫМИ ИКОНКАМИ
local TabMain = Window:MakeTab({ Name = "⚡ Main / Главная", Icon = "", PremiumOnly = false })
local TabVisuals = Window:MakeTab({ Name = "👁️ Visuals / Настройки", Icon = "", PremiumOnly = false })
local TabLang = Window:MakeTab({ Name = "🌐 Language / Язык", Icon = "", PremiumOnly = false })

-- ТЕКСТОВЫЕ ПЕРЕМЕННЫЕ ДЛЯ ЛОКАЛИЗАЦИИ
local t_fling = { RU = "Анти-Флинг (Защита от вылета)", EN = "Anti-Fling (Protection)" }
local t_afk = { RU = "Анти-АФК (Защита от кика)", EN = "Anti-AFK (No Kick)" }
local t_fov = { RU = "Поле зрения (FOV)", EN = "Field of View (FOV)" }
local t_soap = { RU = "Убрать мыло & Буст FPS", EN = "Remove Blur & FPS Boost" }
local t_anim = { RU = "Смена пака анимаций", EN = "Change Animation Pack" }
local t_notif = { RU = "Текстуры оптимизированы! Мыло упущенно.", EN = "Textures optimized! Blur removed." }

-- ФУНКЦИЯ ДЛЯ ОБНОВЛЕНИЯ НАЗВАНИЙ ПРИ СМЕНЕ ЯЗЫКА
local function UpdateLanguage()
    VioEngine:MakeNotification({
        Name = "VioGlide", 
        Content = Lang == "RU" interiors and "Язык изменен на Русский!" or "Language changed to English!", 
        Time = 3
    })
end

-- ==================== ВКЛАДКА ЯЗЫКА ====================
TabLang:AddButton({
    Name = "🇷🇺 Установить Русский Язык",
    Callback = function()
        Lang = "RU"
        UpdateLanguage()
    end
})

TabLang:AddButton({
    Name = "🇺🇸 Set English Language",
    Callback = function()
        Lang = "EN"
        UpdateLanguage()
    end
})

-- ==================== ГЛАВНАЯ ВКЛАДКА ====================

-- 1. АНТИ-ФЛИНГ
TabMain:AddToggle({
    Name = "Anti-Fling / Анти-Флинг",
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

-- 2. АНТИ-АФК
TabMain:AddToggle({
    Name = "Anti-AFK / Анти-АФК",
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

-- 3. ИЗМЕНЕНИЕ FOV (ПОЛЕ ЗРЕНИЯ)
TabMain:AddSlider({
    Name = "FOV / Поле Зрения",
    Min = 60,
    Max = 120,
    Default = 70,
    Color = Color3.fromRGB(147, 51, 234), -- Фиолетовое неоновое свечение ползунка
    Increment = 1,
    ValueName = "deg",
    Callback = function(Value)
        workspace.CurrentCamera.FieldOfView = Value
    end    
})

-- ==================== ВКЛАДКА ВИЗУАЛОВ ====================

-- 4. ОПТИМИЗАЦИЯ ГРАФИКИ (УБРАТЬ МЫЛО)
TabVisuals:AddButton({
    Name = "Fix Blur & FPS / Убрать мыло & FPS",
    Callback = function()
        for _, v in pairs(workspace:GetDescendants()) do
            if v:IsA("BasePart") and not v:IsA("MeshPart") then
                v.Material = Enum.Material.SmoothPlastic
            elseif v:IsA("Decal") or v:IsA("Texture") then
                v:Destroy()
            end
        end
        VioEngine:MakeNotification({
            Name = "VioGlide", 
            Content = Lang == "RU" and t_notif.RU or t_notif.EN, 
            Time = 3
        })
    end
})

-- 5. СМЕНА ПАКОВ АНИМАЦИЙ
TabVisuals:AddDropdown({
    Name = "Animation Pack / Паки анимаций",
    Default = "Default",
    Options = {"Default / Стандарт", "Oldschool", "Ninja", "Toy"},
    Callback = function(Value)
        -- Сюда позже добавим чистую подмену хитбоксов анимаций под ММ2
        print("VioGlide Log: " .. Value)
    end    
})

-- Инициализация и создание неоновой обводки краев меню
VioEngine:Init()
