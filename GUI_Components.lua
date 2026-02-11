--[[
════════════════════════════════════════════════════════════════
    🎨 GUI COMPONENTS MODULE v1.0
    All UI Elements - Toggle, Slider, Button, Textbox, Dropdown, etc
    Mobile Support: ✅
    Author: Modular GUI System
════════════════════════════════════════════════════════════════
]]

local Components = {}

-- Services
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")

-- Device Detection
local isMobile = UserInputService.TouchEnabled and not UserInputService.MouseEnabled

-- Import GUICore for sounds
local GUICore = nil

function Components.Init(core)
    GUICore = core
end

--════════════════════════════════════════════════════════════════
-- CREATE SECTION (COLLAPSIBLE)
--════════════════════════════════════════════════════════════════
function Components:CreateSection(parent, text)
    local SectionContainer = Instance.new("Frame")
    SectionContainer.Size = UDim2.new(1, 0, 0, isMobile and 32 or 28)
    SectionContainer.BackgroundTransparency = 1
    SectionContainer.Parent = parent
    SectionContainer.ClipsDescendants = false
    
    -- Section Header (Clickable)
    local SectionHeader = Instance.new("TextButton")
    SectionHeader.Size = UDim2.new(1, 0, 0, isMobile and 32 or 28)
    SectionHeader.BackgroundTransparency = 1
    SectionHeader.Text = ""
    SectionHeader.Parent = SectionContainer
    
    local SectionLabel = Instance.new("TextLabel", SectionHeader)
    SectionLabel.Size = UDim2.new(1, -30, 1, 0)
    SectionLabel.Position = UDim2.fromOffset(0, 0)
    SectionLabel.BackgroundTransparency = 1
    SectionLabel.Text = text
    SectionLabel.Font = Enum.Font.GothamBold
    SectionLabel.TextSize = isMobile and 11 or 10
    SectionLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    SectionLabel.TextTransparency = 0.3
    SectionLabel.TextXAlignment = Enum.TextXAlignment.Left
    
    -- Arrow Indicator
    local Arrow = Instance.new("TextLabel", SectionHeader)
    Arrow.Size = UDim2.fromOffset(20, 20)
    Arrow.Position = UDim2.new(1, -25, 0.5, -10)
    Arrow.BackgroundTransparency = 1
    Arrow.Text = "▼"
    Arrow.Font = Enum.Font.GothamBold
    Arrow.TextSize = isMobile and 10 or 9
    Arrow.TextColor3 = Color3.fromRGB(255, 255, 255)
    Arrow.TextTransparency = 0.5
    
    local Line = Instance.new("Frame", SectionHeader)
    Line.Size = UDim2.new(1, 0, 0, 1)
    Line.Position = UDim2.fromScale(0, 1)
    Line.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    Line.BackgroundTransparency = 0.9
    Line.BorderSizePixel = 0
    
    -- Content Container
    local ContentContainer = Instance.new("Frame")
    ContentContainer.Size = UDim2.new(1, 0, 0, 0)
    ContentContainer.Position = UDim2.fromOffset(0, isMobile and 32 or 28)
    ContentContainer.BackgroundTransparency = 1
    ContentContainer.ClipsDescendants = false
    ContentContainer.Parent = SectionContainer
    
    local ContentLayout = Instance.new("UIListLayout", ContentContainer)
    ContentLayout.Padding = UDim.new(0, 10)
    ContentLayout.HorizontalAlignment = Enum.HorizontalAlignment.Left
    
    local sectionItems = {}
    local isCollapsed = false
    
    ContentLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        if not isCollapsed then
            ContentContainer.Size = UDim2.new(1, 0, 0, ContentLayout.AbsoluteContentSize.Y)
            SectionContainer.Size = UDim2.new(1, 0, 0, (isMobile and 32 or 28) + ContentLayout.AbsoluteContentSize.Y)
        end
    end)
    
    local function ToggleSection()
        isCollapsed = not isCollapsed
        if GUICore then GUICore.PlayClickSound() end
        
        if isCollapsed then
            TweenService:Create(Arrow, TweenInfo.new(0.2), {
                Rotation = -90,
                TextTransparency = 0.7
            }):Play()
            
            TweenService:Create(SectionLabel, TweenInfo.new(0.2), {
                TextTransparency = 0.5
            }):Play()
            
            TweenService:Create(ContentContainer, TweenInfo.new(0.3, Enum.EasingStyle.Quad), {
                Size = UDim2.new(1, 0, 0, 0)
            }):Play()
            
            TweenService:Create(SectionContainer, TweenInfo.new(0.3, Enum.EasingStyle.Quad), {
                Size = UDim2.new(1, 0, 0, isMobile and 32 or 28)
            }):Play()
            
            for _, item in ipairs(sectionItems) do
                item.Visible = false
            end
        else
            TweenService:Create(Arrow, TweenInfo.new(0.2), {
                Rotation = 0,
                TextTransparency = 0.5
            }):Play()
            
            TweenService:Create(SectionLabel, TweenInfo.new(0.2), {
                TextTransparency = 0.3
            }):Play()
            
            for _, item in ipairs(sectionItems) do
                item.Visible = true
            end
            
            task.wait(0.05)
            
            local targetHeight = ContentLayout.AbsoluteContentSize.Y
            
            TweenService:Create(ContentContainer, TweenInfo.new(0.3, Enum.EasingStyle.Quad), {
                Size = UDim2.new(1, 0, 0, targetHeight)
            }):Play()
            
            TweenService:Create(SectionContainer, TweenInfo.new(0.3, Enum.EasingStyle.Quad), {
                Size = UDim2.new(1, 0, 0, (isMobile and 32 or 28) + targetHeight)
            }):Play()
        end
    end
    
    SectionHeader.MouseButton1Click:Connect(ToggleSection)
    
    SectionHeader.MouseEnter:Connect(function()
        TweenService:Create(SectionLabel, TweenInfo.new(0.2), {
            TextTransparency = 0.1
        }):Play()
        TweenService:Create(Arrow, TweenInfo.new(0.2), {
            TextTransparency = 0.2
        }):Play()
    end)
    
    SectionHeader.MouseLeave:Connect(function()
        TweenService:Create(SectionLabel, TweenInfo.new(0.2), {
            TextTransparency = isCollapsed and 0.5 or 0.3
        }):Play()
        TweenService:Create(Arrow, TweenInfo.new(0.2), {
            TextTransparency = isCollapsed and 0.7 or 0.5
        }):Play()
    end)
    
    return SectionContainer, function(item)
        item.Parent = ContentContainer
        table.insert(sectionItems, item)
    end
end

--════════════════════════════════════════════════════════════════
-- CREATE BUTTON
--════════════════════════════════════════════════════════════════
function Components:CreateButton(parent, text, callback)
    local Button = Instance.new("TextButton")
    Button.Size = UDim2.new(1, 0, 0, isMobile and 40 or 32)
    Button.BackgroundColor3 = Color3.fromRGB(40, 40, 45)
    Button.BorderSizePixel = 0
    Button.Text = text
    Button.Font = Enum.Font.Gotham
    Button.TextSize = isMobile and 12 or 10
    Button.TextColor3 = Color3.new(1, 1, 1)
    Button.AutoButtonColor = false
    Button.Parent = parent
    
    Instance.new("UICorner", Button).CornerRadius = UDim.new(0, 6)
    
    local Stroke = Instance.new("UIStroke", Button)
    Stroke.Color = Color3.fromRGB(60, 60, 65)
    Stroke.Thickness = 1
    
    Button.MouseButton1Click:Connect(function()
        if GUICore then GUICore.PlayClickSound() end
        if callback then callback() end
    end)
    
    Button.MouseEnter:Connect(function()
        TweenService:Create(Button, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(50, 50, 55)}):Play()
    end)
    
    Button.MouseLeave:Connect(function()
        TweenService:Create(Button, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(40, 40, 45)}):Play()
    end)
    
    return Button
end

--════════════════════════════════════════════════════════════════
-- CREATE TOGGLE
--════════════════════════════════════════════════════════════════
function Components:CreateToggle(parent, text, default, callback)
    local Toggle = Instance.new("Frame")
    Toggle.Size = UDim2.new(1, 0, 0, isMobile and 40 or 32)
    Toggle.BackgroundColor3 = Color3.fromRGB(40, 40, 45)
    Toggle.BorderSizePixel = 0
    Toggle.Parent = parent
    
    Instance.new("UICorner", Toggle).CornerRadius = UDim.new(0, 6)
    
    local Label = Instance.new("TextLabel", Toggle)
    Label.Size = UDim2.new(1, -60, 1, 0)
    Label.Position = UDim2.fromOffset(10, 0)
    Label.BackgroundTransparency = 1
    Label.Text = text
    Label.Font = Enum.Font.Gotham
    Label.TextSize = isMobile and 11 or 10
    Label.TextColor3 = Color3.new(1, 1, 1)
    Label.TextXAlignment = Enum.TextXAlignment.Left
    
    local ToggleButton = Instance.new("TextButton", Toggle)
    ToggleButton.Size = UDim2.fromOffset(isMobile and 50 or 40, isMobile and 25 or 20)
    ToggleButton.Position = UDim2.new(1, isMobile and -55 or -45, 0.5, isMobile and -12.5 or -10)
    ToggleButton.BackgroundColor3 = default and Color3.fromRGB(0, 180, 90) or Color3.fromRGB(60, 60, 65)
    ToggleButton.BackgroundTransparency = 0
    ToggleButton.BorderSizePixel = 0
    ToggleButton.Text = ""
    
    Instance.new("UICorner", ToggleButton).CornerRadius = UDim.new(1, 0)
    
    local Indicator = Instance.new("Frame", ToggleButton)
    Indicator.Size = UDim2.fromOffset(isMobile and 20 or 16, isMobile and 20 or 16)
    Indicator.Position = default and UDim2.new(1, isMobile and -22 or -18, 0.5, isMobile and -10 or -8) or UDim2.fromOffset(2.5, 2.5)
    Indicator.BackgroundColor3 = Color3.new(1, 1, 1)
    Indicator.BorderSizePixel = 0
    
    Instance.new("UICorner", Indicator).CornerRadius = UDim.new(1, 0)
    
    local toggled = default
    
    ToggleButton.MouseButton1Click:Connect(function()
        toggled = not toggled
        if GUICore then GUICore.PlayToggleSound() end
        
        TweenService:Create(ToggleButton, TweenInfo.new(0.2), {
            BackgroundColor3 = toggled and Color3.fromRGB(0, 180, 90) or Color3.fromRGB(60, 60, 65)
        }):Play()
        
        TweenService:Create(Indicator, TweenInfo.new(0.2), {
            Position = toggled and UDim2.new(1, isMobile and -22 or -18, 0.5, isMobile and -10 or -8) or UDim2.fromOffset(2.5, 2.5)
        }):Play()
        
        if callback then callback(toggled) end
    end)
    
    return Toggle, function() return toggled end, function(val)
        toggled = val
        TweenService:Create(ToggleButton, TweenInfo.new(0.2), {
            BackgroundColor3 = toggled and Color3.fromRGB(0, 180, 90) or Color3.fromRGB(60, 60, 65)
        }):Play()
        TweenService:Create(Indicator, TweenInfo.new(0.2), {
            Position = toggled and UDim2.new(1, isMobile and -22 or -18, 0.5, isMobile and -10 or -8) or UDim2.fromOffset(2.5, 2.5)
        }):Play()
    end
end

--════════════════════════════════════════════════════════════════
-- CREATE SLIDER (WITH TEXTBOX)
--════════════════════════════════════════════════════════════════
function Components:CreateSlider(parent, text, min, max, default, callback)
    local Slider = Instance.new("Frame")
    Slider.Size = UDim2.new(1, 0, 0, isMobile and 70 or 60)
    Slider.BackgroundColor3 = Color3.fromRGB(40, 40, 45)
    Slider.BorderSizePixel = 0
    Slider.Parent = parent
    
    Instance.new("UICorner", Slider).CornerRadius = UDim.new(0, 6)
    
    local Label = Instance.new("TextLabel", Slider)
    Label.Size = UDim2.new(1, -20, 0, 20)
    Label.Position = UDim2.fromOffset(10, 5)
    Label.BackgroundTransparency = 1
    Label.Text = text
    Label.Font = Enum.Font.Gotham
    Label.TextSize = isMobile and 11 or 10
    Label.TextColor3 = Color3.new(1, 1, 1)
    Label.TextXAlignment = Enum.TextXAlignment.Left
    
    -- TEXTBOX (EDITABLE VALUE)
    local ValueBox = Instance.new("TextBox", Slider)
    ValueBox.Size = UDim2.fromOffset(isMobile and 55 or 50, isMobile and 24 or 20)
    ValueBox.Position = UDim2.new(1, isMobile and -60 or -55, 0, 3)
    ValueBox.BackgroundColor3 = Color3.fromRGB(30, 30, 35)
    ValueBox.BorderSizePixel = 0
    ValueBox.Text = tostring(default)
    ValueBox.Font = Enum.Font.GothamBold
    ValueBox.TextSize = isMobile and 11 or 10
    ValueBox.TextColor3 = Color3.fromRGB(0, 255, 170)
    ValueBox.TextXAlignment = Enum.TextXAlignment.Center
    ValueBox.ClearTextOnFocus = false
    ValueBox.PlaceholderText = tostring(default)
    
    Instance.new("UICorner", ValueBox).CornerRadius = UDim.new(0, 4)
    
    local ValueBoxStroke = Instance.new("UIStroke", ValueBox)
    ValueBoxStroke.Color = Color3.fromRGB(0, 255, 170)
    ValueBoxStroke.Thickness = 1
    ValueBoxStroke.Transparency = 0.7
    
    local SliderBar = Instance.new("Frame", Slider)
    SliderBar.Size = UDim2.new(1, -20, 0, isMobile and 6 or 4)
    SliderBar.Position = UDim2.fromOffset(10, isMobile and 45 or 40)
    SliderBar.BackgroundColor3 = Color3.fromRGB(60, 60, 65)
    SliderBar.BorderSizePixel = 0
    
    Instance.new("UICorner", SliderBar).CornerRadius = UDim.new(1, 0)
    
    local SliderFill = Instance.new("Frame", SliderBar)
    SliderFill.Size = UDim2.fromScale((default - min) / (max - min), 1)
    SliderFill.BackgroundColor3 = Color3.fromRGB(0, 255, 170)
    SliderFill.BorderSizePixel = 0
    
    Instance.new("UICorner", SliderFill).CornerRadius = UDim.new(1, 0)
    
    local SliderButton = Instance.new("TextButton", SliderBar)
    SliderButton.Size = UDim2.fromOffset(isMobile and 20 or 16, isMobile and 20 or 16)
    SliderButton.Position = UDim2.fromScale((default - min) / (max - min), 0.5)
    SliderButton.AnchorPoint = Vector2.new(0.5, 0.5)
    SliderButton.BackgroundColor3 = Color3.new(1, 1, 1)
    SliderButton.BorderSizePixel = 0
    SliderButton.Text = ""
    
    Instance.new("UICorner", SliderButton).CornerRadius = UDim.new(1, 0)
    
    local dragging = false
    local value = default
    
    local function UpdateSliderVisual(newValue)
        local pos = (newValue - min) / (max - min)
        SliderFill.Size = UDim2.fromScale(pos, 1)
        SliderButton.Position = UDim2.fromScale(pos, 0.5)
        ValueBox.Text = tostring(newValue)
    end
    
    local function UpdateSlider(input)
        local pos = math.clamp((input.Position.X - SliderBar.AbsolutePosition.X) / SliderBar.AbsoluteSize.X, 0, 1)
        value = math.floor(min + (max - min) * pos)
        
        UpdateSliderVisual(value)
        
        if callback then callback(value) end
    end
    
    ValueBox.FocusLost:Connect(function(enterPressed)
        local inputValue = tonumber(ValueBox.Text)
        
        if inputValue then
            value = math.clamp(math.floor(inputValue), min, max)
        else
            value = default
        end
        
        UpdateSliderVisual(value)
        
        if callback then callback(value) end
        if GUICore then GUICore.PlayClickSound() end
    end)
    
    ValueBox.Focused:Connect(function()
        TweenService:Create(ValueBoxStroke, TweenInfo.new(0.2), {
            Transparency = 0.2
        }):Play()
        ValueBox.TextColor3 = Color3.fromRGB(255, 255, 255)
    end)
    
    ValueBox.FocusLost:Connect(function()
        TweenService:Create(ValueBoxStroke, TweenInfo.new(0.2), {
            Transparency = 0.7
        }):Play()
        ValueBox.TextColor3 = Color3.fromRGB(0, 255, 170)
    end)
    
    SliderButton.MouseButton1Down:Connect(function()
        dragging = true
        if GUICore then GUICore.PlayClickSound() end
    end)
    
    SliderButton.TouchTap:Connect(function()
        dragging = true
        if GUICore then GUICore.PlayClickSound() end
    end)
    
    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = false
        end
    end)
    
    UserInputService.InputChanged:Connect(function(input)
        if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            UpdateSlider(input)
        end
    end)
    
    SliderBar.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            UpdateSlider(input)
        end
    end)
    
    return Slider, function() return value end, function(newVal)
        value = math.clamp(newVal, min, max)
        UpdateSliderVisual(value)
    end
end

--════════════════════════════════════════════════════════════════
-- CREATE TEXTBOX ✨ (NEW)
--════════════════════════════════════════════════════════════════
function Components:CreateTextbox(parent, text, placeholder, callback)
    local Textbox = Instance.new("Frame")
    Textbox.Size = UDim2.new(1, 0, 0, isMobile and 70 or 60)
    Textbox.BackgroundColor3 = Color3.fromRGB(40, 40, 45)
    Textbox.BorderSizePixel = 0
    Textbox.Parent = parent
    
    Instance.new("UICorner", Textbox).CornerRadius = UDim.new(0, 6)
    
    local Label = Instance.new("TextLabel", Textbox)
    Label.Size = UDim2.new(1, -20, 0, 20)
    Label.Position = UDim2.fromOffset(10, 5)
    Label.BackgroundTransparency = 1
    Label.Text = text
    Label.Font = Enum.Font.Gotham
    Label.TextSize = isMobile and 11 or 10
    Label.TextColor3 = Color3.new(1, 1, 1)
    Label.TextXAlignment = Enum.TextXAlignment.Left
    
    local InputBox = Instance.new("TextBox", Textbox)
    InputBox.Size = UDim2.new(1, -20, 0, isMobile and 32 or 28)
    InputBox.Position = UDim2.fromOffset(10, isMobile and 32 or 30)
    InputBox.BackgroundColor3 = Color3.fromRGB(30, 30, 35)
    InputBox.BorderSizePixel = 0
    InputBox.Text = ""
    InputBox.PlaceholderText = placeholder or "Enter text..."
    InputBox.Font = Enum.Font.Gotham
    InputBox.TextSize = isMobile and 11 or 10
    InputBox.TextColor3 = Color3.fromRGB(255, 255, 255)
    InputBox.PlaceholderColor3 = Color3.fromRGB(150, 150, 150)
    InputBox.TextXAlignment = Enum.TextXAlignment.Left
    InputBox.ClearTextOnFocus = false
    
    Instance.new("UICorner", InputBox).CornerRadius = UDim.new(0, 4)
    
    local InputPadding = Instance.new("UIPadding", InputBox)
    InputPadding.PaddingLeft = UDim.new(0, 8)
    InputPadding.PaddingRight = UDim.new(0, 8)
    
    local InputStroke = Instance.new("UIStroke", InputBox)
    InputStroke.Color = Color3.fromRGB(0, 255, 170)
    InputStroke.Thickness = 1
    InputStroke.Transparency = 0.8
    
    InputBox.Focused:Connect(function()
        TweenService:Create(InputStroke, TweenInfo.new(0.2), {
            Transparency = 0.3
        }):Play()
    end)
    
    InputBox.FocusLost:Connect(function(enterPressed)
        TweenService:Create(InputStroke, TweenInfo.new(0.2), {
            Transparency = 0.8
        }):Play()
        
        if enterPressed then
            if GUICore then GUICore.PlayClickSound() end
            if callback then callback(InputBox.Text) end
        end
    end)
    
    return Textbox, function() return InputBox.Text end, function(newText)
        InputBox.Text = newText
    end
end

--════════════════════════════════════════════════════════════════
-- CREATE DROPDOWN ✨ (COMPLETELY NEW - CLEAN CODE!)
--════════════════════════════════════════════════════════════════
function Components:CreateDropdown(parent, text, options, default, callback)
    -- Container
    local Container = Instance.new("Frame")
    Container.Size = UDim2.new(1, 0, 0, isMobile and 40 or 32)
    Container.BackgroundColor3 = Color3.fromRGB(40, 40, 45)
    Container.BorderSizePixel = 0
    Container.Parent = parent
    
    Instance.new("UICorner", Container).CornerRadius = UDim.new(0, 6)
    
    -- Label
    local Label = Instance.new("TextLabel", Container)
    Label.Size = UDim2.new(1, -110, 1, 0)
    Label.Position = UDim2.fromOffset(10, 0)
    Label.BackgroundTransparency = 1
    Label.Text = text
    Label.Font = Enum.Font.Gotham
    Label.TextSize = isMobile and 11 or 10
    Label.TextColor3 = Color3.new(1, 1, 1)
    Label.TextXAlignment = Enum.TextXAlignment.Left
    
    -- Button Frame
    local Button = Instance.new("TextButton", Container)
    Button.Size = UDim2.fromOffset(isMobile and 100 or 90, isMobile and 28 or 24)
    Button.Position = UDim2.new(1, isMobile and -105 or -95, 0.5, isMobile and -14 or -12)
    Button.BackgroundColor3 = Color3.fromRGB(50, 50, 55)
    Button.Text = ""
    Button.AutoButtonColor = false
    
    Instance.new("UICorner", Button).CornerRadius = UDim.new(0, 4)
    
    -- Selected Value
    local Value = Instance.new("TextLabel", Button)
    Value.Size = UDim2.new(1, -22, 1, 0)
    Value.Position = UDim2.fromOffset(6, 0)
    Value.BackgroundTransparency = 1
    Value.Text = default or options[1] or "..."
    Value.Font = Enum.Font.Gotham
    Value.TextSize = isMobile and 10 or 9
    Value.TextColor3 = Color3.new(1, 1, 1)
    Value.TextXAlignment = Enum.TextXAlignment.Left
    Value.TextTruncate = Enum.TextTruncate.AtEnd
    
    -- Arrow
    local Arrow = Instance.new("TextLabel", Button)
    Arrow.Size = UDim2.fromOffset(14, 14)
    Arrow.Position = UDim2.new(1, -16, 0.5, -7)
    Arrow.BackgroundTransparency = 1
    Arrow.Text = "▼"
    Arrow.Font = Enum.Font.GothamBold
    Arrow.TextSize = 7
    Arrow.TextColor3 = Color3.fromRGB(180, 180, 180)
    
    -- Dropdown List
    local List = Instance.new("Frame", Container)
    List.Size = UDim2.fromOffset(isMobile and 100 or 90, 0)
    List.BackgroundColor3 = Color3.fromRGB(35, 35, 40)
    List.BorderSizePixel = 0
    List.Visible = false
    List.ClipsDescendants = true
    
    Instance.new("UICorner", List).CornerRadius = UDim.new(0, 6)
    
    local Stroke = Instance.new("UIStroke", List)
    Stroke.Color = Color3.fromRGB(0, 255, 170)
    Stroke.Thickness = 1.5
    
    local Padding = Instance.new("UIPadding", List)
    Padding.PaddingTop = UDim.new(0, 4)
    Padding.PaddingBottom = UDim.new(0, 4)
    Padding.PaddingLeft = UDim.new(0, 4)
    Padding.PaddingRight = UDim.new(0, 4)
    
    local ListLayout = Instance.new("UIListLayout", List)
    ListLayout.Padding = UDim.new(0, 2)
    
    -- State
    local open = false
    local current = default or options[1]
    
    -- Create Options
    for _, opt in ipairs(options) do
        local Opt = Instance.new("TextButton", List)
        Opt.Size = UDim2.new(1, -8, 0, isMobile and 24 or 20)
        Opt.BackgroundColor3 = Color3.fromRGB(45, 45, 50)
        Opt.Text = ""
        Opt.AutoButtonColor = false
        
        Instance.new("UICorner", Opt).CornerRadius = UDim.new(0, 4)
        
        local OptText = Instance.new("TextLabel", Opt)
        OptText.Size = UDim2.new(1, -6, 1, 0)
        OptText.Position = UDim2.fromOffset(3, 0)
        OptText.BackgroundTransparency = 1
        OptText.Text = opt
        OptText.Font = Enum.Font.Gotham
        OptText.TextSize = isMobile and 9 or 8
        OptText.TextColor3 = Color3.fromRGB(200, 200, 200)
        OptText.TextXAlignment = Enum.TextXAlignment.Left
        OptText.TextTruncate = Enum.TextTruncate.AtEnd
        
        Opt.MouseEnter:Connect(function()
            Opt.BackgroundColor3 = Color3.fromRGB(0, 200, 140)
            OptText.TextColor3 = Color3.new(1, 1, 1)
        end)
        
        Opt.MouseLeave:Connect(function()
            Opt.BackgroundColor3 = Color3.fromRGB(45, 45, 50)
            OptText.TextColor3 = Color3.fromRGB(200, 200, 200)
        end)
        
        Opt.MouseButton1Click:Connect(function()
            current = opt
            Value.Text = opt
            open = false
            List.Visible = false
            List.Size = UDim2.fromOffset(isMobile and 100 or 90, 0)
            Arrow.Text = "▼"
            if GUICore then GUICore.PlayClickSound() end
            if callback then callback(opt) end
        end)
    end
    
    -- Toggle
    Button.MouseButton1Click:Connect(function()
        open = not open
        if GUICore then GUICore.PlayClickSound() end
        
        if open then
            local h = math.min(#options, 5) * (isMobile and 24 or 20) + (#options - 1) * 2 + 8
            
            -- Check space
            local cY = Container.AbsolutePosition.Y
            local cH = Container.AbsoluteSize.Y
            local pY = parent.AbsolutePosition.Y
            local pH = parent.AbsoluteSize.Y
            local below = (pY + pH) - (cY + cH)
            local above = cY - pY
            
            if below >= h + 10 then
                List.Position = UDim2.new(1, isMobile and -105 or -95, 1, 5)
                Arrow.Text = "▼"
            elseif above >= h + 10 then
                List.Position = UDim2.new(1, isMobile and -105 or -95, 0, -(h + 5))
                Arrow.Text = "▲"
            else
                List.Position = UDim2.new(1, isMobile and -105 or -95, 1, 5)
                Arrow.Text = "▼"
            end
            
            List.Visible = true
            List.Size = UDim2.fromOffset(isMobile and 100 or 90, h)
            
            -- Scroll if needed
            if #options > 5 and List.ClassName ~= "ScrollingFrame" then
                local S = Instance.new("ScrollingFrame")
                S.Size = List.Size
                S.Position = List.Position
                S.BackgroundColor3 = List.BackgroundColor3
                S.Visible = true
                S.ClipsDescendants = true
                S.ScrollBarThickness = 3
                S.ScrollBarImageColor3 = Color3.fromRGB(0, 255, 170)
                S.CanvasSize = UDim2.fromOffset(0, #options * (isMobile and 24 or 20) + (#options - 1) * 2 + 8)
                S.Parent = Container
                
                Instance.new("UICorner", S).CornerRadius = UDim.new(0, 6)
                Instance.new("UIStroke", S).Color = Color3.fromRGB(0, 255, 170)
                Instance.new("UIStroke", S).Thickness = 1.5
                
                local P = Instance.new("UIPadding", S)
                P.PaddingTop = UDim.new(0, 4)
                P.PaddingBottom = UDim.new(0, 4)
                P.PaddingLeft = UDim.new(0, 4)
                P.PaddingRight = UDim.new(0, 7)
                
                for _, c in ipairs(List:GetChildren()) do
                    c.Parent = S
                end
                
                List:Destroy()
                List = S
            end
        else
            List.Visible = false
            List.Size = UDim2.fromOffset(isMobile and 100 or 90, 0)
            Arrow.Text = "▼"
        end
    end)
    
    -- Close outside
    game:GetService("UserInputService").InputBegan:Connect(function(i)
        if not open or i.UserInputType ~= Enum.UserInputType.MouseButton1 then return end
        task.wait()
        local m = game:GetService("UserInputService"):GetMouseLocation()
        local bP = Button.AbsolutePosition
        local bS = Button.AbsoluteSize
        local lP = List.AbsolutePosition
        local lS = List.AbsoluteSize
        if not (m.X >= bP.X and m.X <= bP.X + bS.X and m.Y >= bP.Y and m.Y <= bP.Y + bS.Y) and
           not (m.X >= lP.X and m.X <= lP.X + lS.X and m.Y >= lP.Y and m.Y <= lP.Y + lS.Y) then
            open = false
            List.Visible = false
            List.Size = UDim2.fromOffset(isMobile and 100 or 90, 0)
            Arrow.Text = "▼"
        end
    end)
    
    return Container, function() return current end, function(v)
        if table.find(options, v) then
            current = v
            Value.Text = v
        end
    end
end

--════════════════════════════════════════════════════════════════
-- CREATE COLOR PICKER
--════════════════════════════════════════════════════════════════
function Components:CreateColorPicker(parent, text, default, callback)
    local Picker = Instance.new("Frame")
    Picker.Size = UDim2.new(1, 0, 0, isMobile and 40 or 32)
    Picker.BackgroundColor3 = Color3.fromRGB(40, 40, 45)
    Picker.BorderSizePixel = 0
    Picker.Parent = parent
    
    Instance.new("UICorner", Picker).CornerRadius = UDim.new(0, 6)
    
    local Label = Instance.new("TextLabel", Picker)
    Label.Size = UDim2.new(1, -80, 1, 0)
    Label.Position = UDim2.fromOffset(10, 0)
    Label.BackgroundTransparency = 1
    Label.Text = text
    Label.Font = Enum.Font.Gotham
    Label.TextSize = isMobile and 11 or 10
    Label.TextColor3 = Color3.new(1, 1, 1)
    Label.TextXAlignment = Enum.TextXAlignment.Left
    
    local ColorDisplay = Instance.new("TextButton", Picker)
    ColorDisplay.Size = UDim2.fromOffset(isMobile and 70 or 60, isMobile and 28 or 22)
    ColorDisplay.Position = UDim2.new(1, isMobile and -75 or -70, 0.5, isMobile and -14 or -11)
    ColorDisplay.BackgroundColor3 = default
    ColorDisplay.BorderSizePixel = 0
    ColorDisplay.Text = ""
    
    Instance.new("UICorner", ColorDisplay).CornerRadius = UDim.new(0, 4)
    
    local ColorStroke = Instance.new("UIStroke", ColorDisplay)
    ColorStroke.Color = Color3.fromRGB(255, 255, 255)
    ColorStroke.Thickness = 1
    
    ColorDisplay.MouseButton1Click:Connect(function()
        if GUICore then GUICore.PlayClickSound() end
        local colors = {
            Color3.fromRGB(255, 0, 0),
            Color3.fromRGB(255, 127, 0),
            Color3.fromRGB(255, 255, 0),
            Color3.fromRGB(0, 255, 0),
            Color3.fromRGB(0, 255, 255),
            Color3.fromRGB(0, 0, 255),
            Color3.fromRGB(255, 0, 255),
            Color3.fromRGB(255, 255, 255)
        }
        
        local currentColor = ColorDisplay.BackgroundColor3
        local nextIndex = 1
        
        for i, color in ipairs(colors) do
            if color == currentColor then
                nextIndex = (i % #colors) + 1
                break
            end
        end
        
        ColorDisplay.BackgroundColor3 = colors[nextIndex]
        if callback then callback(colors[nextIndex]) end
    end)
    
    return Picker, function() return ColorDisplay.BackgroundColor3 end
end

--════════════════════════════════════════════════════════════════
-- CREATE KEYBIND
--════════════════════════════════════════════════════════════════
function Components:CreateKeybind(parent, text, defaultKey, callback)
    local KeyNames = {
        [Enum.KeyCode.E] = "E", [Enum.KeyCode.R] = "R", [Enum.KeyCode.J] = "J",
        [Enum.KeyCode.T] = "T", [Enum.KeyCode.F] = "F", [Enum.KeyCode.H] = "H",
        [Enum.KeyCode.Q] = "Q", [Enum.KeyCode.X] = "X", [Enum.KeyCode.C] = "C",
        [Enum.KeyCode.V] = "V", [Enum.KeyCode.Z] = "Z", [Enum.KeyCode.B] = "B",
        [Enum.KeyCode.G] = "G", [Enum.KeyCode.K] = "K", [Enum.KeyCode.L] = "L",
        [Enum.KeyCode.M] = "M", [Enum.KeyCode.N] = "N", [Enum.KeyCode.P] = "P",
        [Enum.KeyCode.Y] = "Y", [Enum.KeyCode.U] = "U", [Enum.KeyCode.O] = "O",
        [Enum.KeyCode.LeftShift] = "LSHIFT", [Enum.KeyCode.RightShift] = "RSHIFT",
        [Enum.KeyCode.LeftControl] = "LCTRL", [Enum.KeyCode.RightControl] = "RCTRL",
        [Enum.KeyCode.LeftAlt] = "LALT", [Enum.KeyCode.RightAlt] = "RALT",
        [Enum.KeyCode.Insert] = "INSERT", [Enum.KeyCode.Home] = "HOME",
        [Enum.KeyCode.Delete] = "DELETE", [Enum.KeyCode.End] = "END",
        [Enum.KeyCode.PageUp] = "PGUP", [Enum.KeyCode.PageDown] = "PGDN"
    }
    
    local Keybind = Instance.new("Frame")
    Keybind.Size = UDim2.new(1, 0, 0, isMobile and 40 or 32)
    Keybind.BackgroundColor3 = Color3.fromRGB(40, 40, 45)
    Keybind.BorderSizePixel = 0
    Keybind.Parent = parent
    
    Instance.new("UICorner", Keybind).CornerRadius = UDim.new(0, 6)
    
    local Label = Instance.new("TextLabel", Keybind)
    Label.Size = UDim2.new(1, -95, 1, 0)
    Label.Position = UDim2.fromOffset(10, 0)
    Label.BackgroundTransparency = 1
    Label.Text = text
    Label.Font = Enum.Font.Gotham
    Label.TextSize = isMobile and 11 or 10
    Label.TextColor3 = Color3.new(1, 1, 1)
    Label.TextXAlignment = Enum.TextXAlignment.Left
    
    local KeyButton = Instance.new("TextButton", Keybind)
    KeyButton.Size = UDim2.fromOffset(isMobile and 85 or 70, isMobile and 30 or 24)
    KeyButton.Position = UDim2.new(1, isMobile and -90 or -75, 0.5, isMobile and -15 or -12)
    KeyButton.BackgroundColor3 = Color3.fromRGB(50, 50, 55)
    KeyButton.BorderSizePixel = 0
    KeyButton.Text = KeyNames[defaultKey] or tostring(defaultKey.Name)
    KeyButton.Font = Enum.Font.GothamBold
    KeyButton.TextSize = isMobile and 11 or 10
    KeyButton.TextColor3 = Color3.fromRGB(0, 255, 170)
    
    Instance.new("UICorner", KeyButton).CornerRadius = UDim.new(0, 4)
    
    local currentKey = defaultKey
    local waiting = false
    
    KeyButton.MouseButton1Click:Connect(function()
        if GUICore then GUICore.PlayClickSound() end
        waiting = true
        KeyButton.Text = "..."
        KeyButton.BackgroundColor3 = Color3.fromRGB(255, 180, 60)
    end)
    
    UserInputService.InputBegan:Connect(function(input, gameProcessed)
        if not waiting then return end
        
        local keyCode = input.KeyCode
        if keyCode ~= Enum.KeyCode.Unknown and keyCode ~= Enum.KeyCode.Escape then
            currentKey = keyCode
            KeyButton.Text = KeyNames[keyCode] or tostring(keyCode.Name)
            KeyButton.BackgroundColor3 = Color3.fromRGB(50, 50, 55)
            waiting = false
            if callback then callback(keyCode) end
            if GUICore then GUICore.PlayToggleSound() end
        elseif keyCode == Enum.KeyCode.Escape then
            KeyButton.Text = KeyNames[currentKey] or tostring(currentKey.Name)
            KeyButton.BackgroundColor3 = Color3.fromRGB(50, 50, 55)
            waiting = false
        end
    end)
    
    return Keybind, function() return currentKey end
end

return Components
