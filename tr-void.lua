local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")

local Library = {}

function Library:CreateWindow(config)
    local Name = config.Name or "Hasan Library"
    
    -- Ana Ekran (ScreenGui)
    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "DeltaGui_" .. math.random(1, 1000)
    ScreenGui.Parent = game:GetService("CoreGui") -- Delta'da görünmesi için

    -- Ana Çerçeve (Main Frame)
    local MainFrame = Instance.new("Frame")
    MainFrame.Name = "MainFrame"
    MainFrame.Size = UDim2.new(0, 0, 0, 0) -- Başlangıçta 0 (Animasyon için)
    MainFrame.Position = UDim2.new(0.5, -200, 0.5, -125)
    MainFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
    MainFrame.BorderSizePixel = 0
    MainFrame.ClipsDescendants = true
    MainFrame.Parent = ScreenGui

    -- Köşeleri Yuvarlatma
    local UICorner = Instance.new("UICorner")
    UICorner.CornerRadius = UDim.new(0, 10)
    UICorner.Parent = MainFrame

    -- Başlık Paneli
    local TitleBar = Instance.new("Frame")
    TitleBar.Size = UDim2.new(1, 0, 0, 40)
    TitleBar.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
    TitleBar.BorderSizePixel = 0
    TitleBar.Parent = MainFrame

    local TitleLabel = Instance.new("TextLabel")
    TitleLabel.Text = Name
    TitleLabel.Size = UDim2.new(1, -20, 1, 0)
    TitleLabel.Position = UDim2.new(0, 15, 0, 0)
    TitleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    TitleLabel.BackgroundTransparency = 1
    TitleLabel.TextXAlignment = Enum.TextXAlignment.Left
    TitleLabel.Font = Enum.Font.GothamBold
    TitleLabel.TextSize = 18
    TitleLabel.Parent = TitleBar

    -- Açılış Animasyonu
    MainFrame:TweenSize(UDim2.new(0, 400, 0, 250), "Out", "Back", 0.5, true)

    -- Sürükleme Özelliği (Drag)
    local dragging, dragInput, dragStart, startPos
    TitleBar.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPos = MainFrame.Position
        end
    end)

    UserInputService.InputChanged:Connect(function(input)
        if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            local delta = input.Position - dragStart
            MainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)

    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = false
        end
    end)

    -- Buton Oluşturma Fonksiyonu
    local Elements = {}
    function Elements:CreateButton(btnConfig)
        local btnName = btnConfig.Name or "Buton"
        local callback = btnConfig.Callback or function() end

        local Button = Instance.new("TextButton")
        Button.Size = UDim2.new(0.9, 0, 0, 35)
        Button.Position = UDim2.new(0.05, 0, 0, 50) -- Şimdilik statik, liste yapısı eklenecek
        Button.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
        Button.Text = btnName
        Button.TextColor3 = Color3.fromRGB(255, 255, 255)
        Button.Font = Enum.Font.Gotham
        Button.TextSize = 14
        Button.AutoButtonColor = false
        Button.Parent = MainFrame

        local BtnCorner = Instance.new("UICorner")
        BtnCorner.CornerRadius = UDim.new(0, 6)
        BtnCorner.Parent = Button

        -- Buton Efekti (Hover/Click)
        Button.MouseButton1Click:Connect(function()
            Button.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
            wait(0.1)
            Button.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
            callback()
        end)
    end

    return Elements
end

return Library
