--[[
════════════════════════════════════════════════════════════════
    🎯 GUI CORE MODULE v1.0
    Modular GUI System - Core Functions
    Mobile Support: ✅ (0.45 x 0.75)
    Author: Modular GUI System
════════════════════════════════════════════════════════════════
]]

local GUICore = {}
GUICore.__index = GUICore

-- Services
local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local SoundService = game:GetService("SoundService")
local LocalPlayer = Players.LocalPlayer

-- Clean up old GUI
pcall(function()
    game.CoreGui.ModularGUI:Destroy()
    game.CoreGui.ModularToggleButton:Destroy()
end)

-- Device Detection
local isMobile = UserInputService.TouchEnabled and not UserInputService.MouseEnabled
local isTablet = UserInputService.TouchEnabled and UserInputService.MouseEnabled

--════════════════════════════════════════════════════════════════
-- NOTIFICATION SYSTEM
--════════════════════════════════════════════════════════════════
function GUICore.Notify(title, message, duration)
    pcall(function()
        local NotifGui = Instance.new("ScreenGui")
        NotifGui.Name = "NotificationGui"
        NotifGui.ResetOnSpawn = false
        NotifGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
        NotifGui.Parent = game.CoreGui
        
        local NotifFrame = Instance.new("Frame")
        NotifFrame.Size = UDim2.fromOffset(300, 80)
        NotifFrame.Position = UDim2.new(1, -320, 0, 20)
        NotifFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
        NotifFrame.BorderSizePixel = 0
        NotifFrame.Parent = NotifGui
        
        Instance.new("UICorner", NotifFrame).CornerRadius = UDim.new(0, 10)
        
        local NotifStroke = Instance.new("UIStroke", NotifFrame)
        NotifStroke.Color = Color3.fromRGB(0, 255, 170)
        NotifStroke.Thickness = 1.5
        
        local TitleLabel = Instance.new("TextLabel", NotifFrame)
        TitleLabel.Size = UDim2.new(1, -20, 0, 25)
        TitleLabel.Position = UDim2.fromOffset(10, 10)
        TitleLabel.BackgroundTransparency = 1
        TitleLabel.Text = title
        TitleLabel.Font = Enum.Font.GothamBold
        TitleLabel.TextSize = 14
        TitleLabel.TextColor3 = Color3.fromRGB(0, 255, 170)
        TitleLabel.TextXAlignment = Enum.TextXAlignment.Left
        
        local MessageLabel = Instance.new("TextLabel", NotifFrame)
        MessageLabel.Size = UDim2.new(1, -20, 0, 35)
        MessageLabel.Position = UDim2.fromOffset(10, 40)
        MessageLabel.BackgroundTransparency = 1
        MessageLabel.Text = message
        MessageLabel.Font = Enum.Font.Gotham
        MessageLabel.TextSize = 12
        MessageLabel.TextColor3 = Color3.new(1, 1, 1)
        MessageLabel.TextXAlignment = Enum.TextXAlignment.Left
        MessageLabel.TextWrapped = true
        
        TweenService:Create(NotifFrame, TweenInfo.new(0.5, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
            Position = UDim2.new(1, -320, 0, 20)
        }):Play()
        
        task.wait(duration or 3)
        
        TweenService:Create(NotifFrame, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {
            Position = UDim2.new(1, 50, 0, 20)
        }):Play()
        
        task.wait(0.3)
        NotifGui:Destroy()
    end)
end

--════════════════════════════════════════════════════════════════
-- SOUND SYSTEM
--════════════════════════════════════════════════════════════════
function GUICore.PlaySound(soundId, volume, pitch)
    pcall(function()
        local sound = Instance.new("Sound")
        sound.SoundId = "rbxassetid://" .. soundId
        sound.Volume = volume or 0.5
        sound.Pitch = pitch or 1
        sound.Parent = SoundService
        sound:Play()
        game:GetService("Debris"):AddItem(sound, 2)
    end)
end

function GUICore.PlayClickSound()
    GUICore.PlaySound("8394620892", 0.7, 1)
end

function GUICore.PlayToggleSound()
    GUICore.PlaySound("8394620892", 0.7, 1)
end

function GUICore.PlayCloseSound()
    GUICore.PlaySound("8394620892", 0.7, 1)
end

--════════════════════════════════════════════════════════════════
-- CREATE NEW GUI INSTANCE
--════════════════════════════════════════════════════════════════
function GUICore.new(config)
    local self = setmetatable({}, GUICore)
    
    -- Configuration
    self.Config = {
        Title = config.Title or "MODULAR GUI",
        Version = config.Version or "v1.0",
        Size = config.Size or (isMobile and UDim2.new(0.45, 0, 0.75, 0) or UDim2.fromOffset(650, 520)),
        Position = config.Position or (isMobile and UDim2.new(0.025, 0, 0.125, 0) or UDim2.new(0.5, -325, 0.5, -260)),
        Theme = config.Theme or Color3.fromRGB(0, 255, 170)
    }
    
    -- Storage
    self.Tabs = {}
    self.TabPages = {}
    self.CurrentTab = nil
    self.Enabled = true
    
    -- Create GUI
    self:CreateGUI()
    self:CreateToggleButton()
    
    return self
end

--════════════════════════════════════════════════════════════════
-- CREATE MAIN GUI
--════════════════════════════════════════════════════════════════
function GUICore:CreateGUI()
    -- Main ScreenGui
    self.GUI = Instance.new("ScreenGui")
    self.GUI.Name = "ModularGUI"
    self.GUI.ResetOnSpawn = false
    self.GUI.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    self.GUI.Enabled = true
    self.GUI.Parent = game.CoreGui
    
    -- Main Frame
    self.Main = Instance.new("Frame", self.GUI)
    self.Main.Size = self.Config.Size
    self.Main.Position = self.Config.Position
    self.Main.BackgroundColor3 = Color3.fromRGB(12, 12, 15)
    self.Main.BackgroundTransparency = 0.15
    self.Main.BorderSizePixel = 0
    self.Main.Active = true
    self.Main.ClipsDescendants = true
    
    -- Make draggable
    if not isMobile then
        self.Main.Draggable = true
    else
        self:MakeMobileDraggable(self.Main)
    end
    
    Instance.new("UICorner", self.Main).CornerRadius = UDim.new(0, 16)
    
    -- Animated Border
    local MainStroke = Instance.new("UIStroke", self.Main)
    MainStroke.Color = self.Config.Theme
    MainStroke.Thickness = 2
    MainStroke.Transparency = 0
    
    -- Border animation
    task.spawn(function()
        while task.wait() do
            TweenService:Create(MainStroke, TweenInfo.new(1.5, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut), {
                Transparency = 0.3
            }):Play()
            task.wait(1.5)
            TweenService:Create(MainStroke, TweenInfo.new(1.5, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut), {
                Transparency = 0
            }):Play()
            task.wait(1.5)
        end
    end)
    
    -- Blur Background
    local Blur = Instance.new("ImageLabel", self.Main)
    Blur.Size = UDim2.fromScale(1, 1)
    Blur.Position = UDim2.fromScale(0, 0)
    Blur.BackgroundTransparency = 1
    Blur.Image = "rbxassetid://8992230677"
    Blur.ImageColor3 = Color3.fromRGB(12, 12, 15)
    Blur.ImageTransparency = 0.3
    Blur.ScaleType = Enum.ScaleType.Slice
    Blur.SliceCenter = Rect.new(100, 100, 100, 100)
    Blur.ZIndex = 0
    
    -- Header
    self:CreateHeader()
    
    -- Tab Container
    self:CreateTabContainer()
    
    -- Content Container
    self:CreateContentContainer()
end

--════════════════════════════════════════════════════════════════
-- CREATE HEADER (FIXED VERSION)
--════════════════════════════════════════════════════════════════
function GUICore:CreateHeader()
    local Header = Instance.new("Frame", self.Main)
    Header.Size = UDim2.new(1, 0, 0, isMobile and 50 or 45)
    Header.BackgroundColor3 = Color3.fromRGB(18, 18, 22)
    Header.BackgroundTransparency = 0.3
    Header.BorderSizePixel = 0
    
    Instance.new("UICorner", Header).CornerRadius = UDim.new(0, 16)
    
    local HeaderLine = Instance.new("Frame", Header)
    HeaderLine.Size = UDim2.new(1, -20, 0, 1)
    HeaderLine.Position = UDim2.new(0, 10, 1, -1)
    HeaderLine.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    HeaderLine.BackgroundTransparency = 0.9
    HeaderLine.BorderSizePixel = 0
    
    -- ════════════════════════════════════════════════════════════
    -- FIX: TITLE AUTO-RESIZE BASED ON TEXT LENGTH
    -- ════════════════════════════════════════════════════════════
    local Title = Instance.new("TextLabel", Header)
    Title.Size = UDim2.new(1, -150, 1, 0)  -- Dikurangin lebih banyak buat space
    Title.Position = UDim2.fromOffset(20, 0)
    Title.BackgroundTransparency = 1
    Title.Text = self.Config.Title
    Title.Font = Enum.Font.GothamBold
    Title.TextSize = isMobile and 16 or 14
    Title.TextColor3 = Color3.fromRGB(255, 255, 255)
    Title.TextXAlignment = Enum.TextXAlignment.Left
    Title.TextTruncate = Enum.TextTruncate.AtEnd  -- Potong text kalau kepanjangan
    
    -- ════════════════════════════════════════════════════════════
    -- FIX: VERSION BADGE AUTO-POSITION BASED ON TITLE WIDTH
    -- ════════════════════════════════════════════════════════════
    -- Calculate title text width
    local TextService = game:GetService("TextService")
    local titleSize = TextService:GetTextSize(
        self.Config.Title,
        Title.TextSize,
        Title.Font,
        Vector2.new(1000, 1000)
    )
    
    local Version = Instance.new("TextLabel", Header)
    Version.Size = UDim2.fromOffset(60, 20)
    -- Position version badge AFTER title text (with 10px gap)
    local versionXPos = 20 + titleSize.X + 10
    Version.Position = UDim2.new(0, versionXPos, 0.5, -10)
    Version.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    Version.BackgroundTransparency = 0.95
    Version.Text = self.Config.Version
    Version.Font = Enum.Font.GothamBold
    Version.TextSize = 9
    Version.TextColor3 = Color3.fromRGB(200, 200, 200)
    
    Instance.new("UICorner", Version).CornerRadius = UDim.new(0, 6)
    
    -- Close Button
    local CloseBtn = Instance.new("TextButton", Header)
    CloseBtn.Size = UDim2.fromOffset(isMobile and 35 or 32, isMobile and 35 or 32)
    CloseBtn.Position = UDim2.new(1, isMobile and -42 or -38, 0.5, isMobile and -17.5 or -16)
    CloseBtn.Text = "×"
    CloseBtn.Font = Enum.Font.GothamBold
    CloseBtn.TextSize = isMobile and 22 or 20
    CloseBtn.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    CloseBtn.BackgroundTransparency = 0.95
    CloseBtn.TextColor3 = Color3.fromRGB(255, 80, 80)
    CloseBtn.BorderSizePixel = 0
    
    Instance.new("UICorner", CloseBtn).CornerRadius = UDim.new(1, 0)
    
    CloseBtn.MouseEnter:Connect(function()
        TweenService:Create(CloseBtn, TweenInfo.new(0.2), {
            BackgroundTransparency = 0.8,
            TextColor3 = Color3.fromRGB(255, 50, 50)
        }):Play()
    end)
    
    CloseBtn.MouseLeave:Connect(function()
        TweenService:Create(CloseBtn, TweenInfo.new(0.2), {
            BackgroundTransparency = 0.95,
            TextColor3 = Color3.fromRGB(255, 80, 80)
        }):Play()
    end)
    
    CloseBtn.MouseButton1Click:Connect(function()
        GUICore.PlayCloseSound()
        self:Destroy()
    end)
    
    -- Minimize Button
    local MinBtn = Instance.new("TextButton", Header)
    MinBtn.Size = UDim2.fromOffset(isMobile and 35 or 32, isMobile and 35 or 32)
    MinBtn.Position = UDim2.new(1, isMobile and -82 or -74, 0.5, isMobile and -17.5 or -16)
    MinBtn.Text = "−"
    MinBtn.Font = Enum.Font.GothamBold
    MinBtn.TextSize = isMobile and 22 or 20
    MinBtn.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    MinBtn.BackgroundTransparency = 0.95
    MinBtn.TextColor3 = Color3.fromRGB(255, 200, 100)
    MinBtn.BorderSizePixel = 0
    
    Instance.new("UICorner", MinBtn).CornerRadius = UDim.new(1, 0)
    
    MinBtn.MouseEnter:Connect(function()
        TweenService:Create(MinBtn, TweenInfo.new(0.2), {
            BackgroundTransparency = 0.8
        }):Play()
    end)
    
    MinBtn.MouseLeave:Connect(function()
        TweenService:Create(MinBtn, TweenInfo.new(0.2), {
            BackgroundTransparency = 0.95
        }):Play()
    end)
    
    MinBtn.MouseButton1Click:Connect(function()
        GUICore.PlayToggleSound()
        self.GUI.Enabled = false
    end)
end

--════════════════════════════════════════════════════════════════
-- CREATE TAB CONTAINER
--════════════════════════════════════════════════════════════════
function GUICore:CreateTabContainer()
    self.TabContainer = Instance.new("ScrollingFrame", self.Main)
    self.TabContainer.Size = UDim2.new(1, -20, 0, isMobile and 45 or 40)
    self.TabContainer.Position = UDim2.fromOffset(10, isMobile and 55 or 50)
    self.TabContainer.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    self.TabContainer.BackgroundTransparency = 0.97
    self.TabContainer.BorderSizePixel = 0
    self.TabContainer.ScrollBarThickness = 2
    self.TabContainer.ScrollBarImageColor3 = self.Config.Theme
    self.TabContainer.ScrollBarImageTransparency = 0.7
    self.TabContainer.CanvasSize = UDim2.fromOffset(0, 0)
    self.TabContainer.ScrollingDirection = Enum.ScrollingDirection.X
    
    Instance.new("UICorner", self.TabContainer).CornerRadius = UDim.new(0, 10)
    
    local TabPadding = Instance.new("UIPadding", self.TabContainer)
    TabPadding.PaddingTop = UDim.new(0, 5)
    TabPadding.PaddingBottom = UDim.new(0, 5)
    TabPadding.PaddingLeft = UDim.new(0, 8)
    TabPadding.PaddingRight = UDim.new(0, 8)
    
    self.TabList = Instance.new("UIListLayout", self.TabContainer)
    self.TabList.FillDirection = Enum.FillDirection.Horizontal
    self.TabList.Padding = UDim.new(0, 8)
    self.TabList.HorizontalAlignment = Enum.HorizontalAlignment.Left
    self.TabList.VerticalAlignment = Enum.VerticalAlignment.Center
    
    self.TabList:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        self.TabContainer.CanvasSize = UDim2.fromOffset(self.TabList.AbsoluteContentSize.X + 16, 0)
    end)
end

--════════════════════════════════════════════════════════════════
-- CREATE CONTENT CONTAINER
--════════════════════════════════════════════════════════════════
function GUICore:CreateContentContainer()
    self.ContentContainer = Instance.new("Frame", self.Main)
    self.ContentContainer.Size = UDim2.new(1, -20, 1, isMobile and -115 or -105)
    self.ContentContainer.Position = UDim2.fromOffset(10, isMobile and 105 or 95)
    self.ContentContainer.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    self.ContentContainer.BackgroundTransparency = 0.97
    self.ContentContainer.BorderSizePixel = 0
    
    Instance.new("UICorner", self.ContentContainer).CornerRadius = UDim.new(0, 10)
end

--════════════════════════════════════════════════════════════════
-- CREATE TOGGLE BUTTON (FLOATING)
--════════════════════════════════════════════════════════════════
function GUICore:CreateToggleButton()
    local ToggleButtonGui = Instance.new("ScreenGui")
    ToggleButtonGui.Name = "ModularToggleButton"
    ToggleButtonGui.ResetOnSpawn = false
    ToggleButtonGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    ToggleButtonGui.Parent = game.CoreGui
    
    local ToggleButton = Instance.new("TextButton", ToggleButtonGui)
    if isMobile then
        ToggleButton.Size = UDim2.fromOffset(50, 50)
    else
        ToggleButton.Size = UDim2.fromOffset(45, 45)
    end
    ToggleButton.Position = UDim2.new(0, 15, 0.5, -25)
    ToggleButton.BackgroundColor3 = Color3.fromRGB(12, 12, 15)
    ToggleButton.BackgroundTransparency = 0.15
    ToggleButton.BorderSizePixel = 0
    ToggleButton.Text = "◎"
    ToggleButton.Font = Enum.Font.GothamBold
    ToggleButton.TextSize = 24
    ToggleButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    ToggleButton.Active = true
    ToggleButton.Draggable = true
    
    Instance.new("UICorner", ToggleButton).CornerRadius = UDim.new(1, 0)
    
    local ToggleStroke = Instance.new("UIStroke", ToggleButton)
    ToggleStroke.Color = Color3.fromRGB(255, 255, 255)
    ToggleStroke.Thickness = 2
    ToggleStroke.Transparency = 0.7
    
    -- Pulse animation
    task.spawn(function()
        while task.wait(1) do
            TweenService:Create(ToggleStroke, TweenInfo.new(0.8, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut), {
                Transparency = 0.3
            }):Play()
            task.wait(0.8)
            TweenService:Create(ToggleStroke, TweenInfo.new(0.8, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut), {
                Transparency = 0.7
            }):Play()
        end
    end)
    
    ToggleButton.MouseButton1Click:Connect(function()
        if not self.GUI or not self.GUI.Parent then
            GUICore.Notify("Warning", "GUI has been closed! Re-execute the script.", 3)
            return
        end
        
        GUICore.PlayToggleSound()
        if not self.GUI.Enabled then
            self.GUI.Enabled = true
            self.Main.Size = UDim2.fromOffset(0, 0)
            local targetSize = self.Config.Size
            
            TweenService:Create(self.Main, TweenInfo.new(0.4, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
                Size = targetSize
            }):Play()
        else
            self.GUI.Enabled = false
        end
    end)
    
    self.ToggleButtonGui = ToggleButtonGui
end

--════════════════════════════════════════════════════════════════
-- MOBILE DRAGGABLE
--════════════════════════════════════════════════════════════════
function GUICore:MakeMobileDraggable(frame)
    local dragging = false
    local dragStart = nil
    local startPos = nil
    
    frame.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            dragStart = input.Position
            startPos = frame.Position
        end
    end)
    
    frame.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = false
        end
    end)
    
    UserInputService.InputChanged:Connect(function(input)
        if dragging and (input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseMovement) then
            local delta = input.Position - dragStart
            frame.Position = UDim2.new(
                startPos.X.Scale,
                startPos.X.Offset + delta.X,
                startPos.Y.Scale,
                startPos.Y.Offset + delta.Y
            )
        end
    end)
end

--════════════════════════════════════════════════════════════════
-- ADD TAB
--════════════════════════════════════════════════════════════════
function GUICore:AddTab(name, icon)
    local TabButton = Instance.new("TextButton")
    TabButton.Size = UDim2.fromOffset(isMobile and 90 or 85, isMobile and 32 or 28)
    TabButton.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    TabButton.BackgroundTransparency = 0.95
    TabButton.BorderSizePixel = 0
    TabButton.Text = (icon or "") .. " " .. name
    TabButton.Font = Enum.Font.GothamBold
    TabButton.TextSize = isMobile and 11 or 10
    TabButton.TextColor3 = Color3.fromRGB(200, 200, 200)
    TabButton.AutoButtonColor = false
    TabButton.Parent = self.TabContainer
    
    Instance.new("UICorner", TabButton).CornerRadius = UDim.new(0, 8)
    
    TabButton.MouseEnter:Connect(function()
        if TabButton.BackgroundTransparency ~= 0.3 then
            TweenService:Create(TabButton, TweenInfo.new(0.2), {
                BackgroundTransparency = 0.85
            }):Play()
        end
    end)
    
    TabButton.MouseLeave:Connect(function()
        if TabButton.BackgroundTransparency ~= 0.3 then
            TweenService:Create(TabButton, TweenInfo.new(0.2), {
                BackgroundTransparency = 0.95
            }):Play()
        end
    end)
    
    local TabPage = Instance.new("ScrollingFrame")
    TabPage.Size = UDim2.fromScale(1, 1)
    TabPage.BackgroundTransparency = 1
    TabPage.BorderSizePixel = 0
    TabPage.ScrollBarThickness = isMobile and 4 or 3
    TabPage.ScrollBarImageColor3 = Color3.fromRGB(255, 255, 255)
    TabPage.ScrollBarImageTransparency = 0.7
    TabPage.CanvasSize = UDim2.fromOffset(0, 0)
    TabPage.Visible = false
    TabPage.Parent = self.ContentContainer
    
    local PagePadding = Instance.new("UIPadding", TabPage)
    PagePadding.PaddingTop = UDim.new(0, 12)
    PagePadding.PaddingBottom = UDim.new(0, 12)
    PagePadding.PaddingLeft = UDim.new(0, 12)
    PagePadding.PaddingRight = UDim.new(0, 12)
    
    local PageList = Instance.new("UIListLayout", TabPage)
    PageList.Padding = UDim.new(0, 10)
    PageList.HorizontalAlignment = Enum.HorizontalAlignment.Left
    
    PageList:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        TabPage.CanvasSize = UDim2.fromOffset(0, PageList.AbsoluteContentSize.Y + 24)
    end)
    
    TabButton.MouseButton1Click:Connect(function()
        GUICore.PlayClickSound()
        
        for _, btn in pairs(self.Tabs) do
            TweenService:Create(btn, TweenInfo.new(0.2), {
                BackgroundTransparency = 0.95,
                TextColor3 = Color3.fromRGB(200, 200, 200)
            }):Play()
        end
        
        for _, page in pairs(self.TabPages) do
            page.Visible = false
        end
        
        TweenService:Create(TabButton, TweenInfo.new(0.2), {
            BackgroundTransparency = 0.3,
            TextColor3 = self.Config.Theme
        }):Play()
        
        TabPage.Visible = true
        self.CurrentTab = TabPage
    end)
    
    table.insert(self.Tabs, TabButton)
    table.insert(self.TabPages, TabPage)
    
    -- Auto-select first tab
    if #self.Tabs == 1 then
        TabButton.BackgroundTransparency = 0.3
        TabButton.TextColor3 = self.Config.Theme
        TabPage.Visible = true
        self.CurrentTab = TabPage
    end
    
    return TabPage
end

--════════════════════════════════════════════════════════════════
-- DESTROY GUI
--════════════════════════════════════════════════════════════════
function GUICore:Destroy()
    TweenService:Create(self.Main, TweenInfo.new(0.3, Enum.EasingStyle.Back, Enum.EasingDirection.In), {
        Size = UDim2.fromOffset(0, 0)
    }):Play()
    
    task.wait(0.3)
    
    pcall(function() self.GUI:Destroy() end)
    pcall(function() self.ToggleButtonGui:Destroy() end)
    
    print("━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━")
    print("🎯 MODULAR GUI CLOSED")
    print("✅ GUI destroyed")
    print("━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━")
end

return GUICore
