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
-- CREATE DROPDOWN ✨ (FIXED - NO CLIPPING!)
--════════════════════════════════════════════════════════════════
function Components:CreateDropdown(parent, text, options, default, callback)
    local Dropdown = Instance.new("Frame")
    Dropdown.Size = UDim2.new(1, 0, 0, isMobile and 40 or 32)
    Dropdown.BackgroundColor3 = Color3.fromRGB(40, 40, 45)
    Dropdown.BorderSizePixel = 0
    Dropdown.Parent = parent
    Dropdown.ClipsDescendants = false
    Dropdown.ZIndex = 10
    
    Instance.new("UICorner", Dropdown).CornerRadius = UDim.new(0, 6)
    
    local Label = Instance.new("TextLabel", Dropdown)
    Label.Size = UDim2.new(1, -110, 1, 0)
    Label.Position = UDim2.fromOffset(10, 0)
    Label.BackgroundTransparency = 1
    Label.Text = text
    Label.Font = Enum.Font.Gotham
    Label.TextSize = isMobile and 11 or 10
    Label.TextColor3 = Color3.new(1, 1, 1)
    Label.TextXAlignment = Enum.TextXAlignment.Left
    
    local DropdownButton = Instance.new("TextButton", Dropdown)
    DropdownButton.Size = UDim2.fromOffset(isMobile and 100 or 90, isMobile and 28 or 24)
    DropdownButton.Position = UDim2.new(1, isMobile and -105 or -95, 0.5, isMobile and -14 or -12)
    DropdownButton.BackgroundColor3 = Color3.fromRGB(50, 50, 55)
    DropdownButton.BorderSizePixel = 0
    DropdownButton.Text = default or options[1] or "Select"
    DropdownButton.Font = Enum.Font.Gotham
    DropdownButton.TextSize = isMobile and 10 or 9
    DropdownButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    DropdownButton.AutoButtonColor = false
    
    Instance.new("UICorner", DropdownButton).CornerRadius = UDim.new(0, 4)
    
    local Arrow = Instance.new("TextLabel", DropdownButton)
    Arrow.Size = UDim2.fromOffset(15, 15)
    Arrow.Position = UDim2.new(1, -18, 0.5, -7)
    Arrow.BackgroundTransparency = 1
    Arrow.Text = "▼"
    Arrow.Font = Enum.Font.GothamBold
    Arrow.TextSize = 8
    Arrow.TextColor3 = Color3.fromRGB(200, 200, 200)
    
    -- ════════════════════════════════════════════════════════════
    -- CREATE SEPARATE SCREENGUI FOR DROPDOWN (NO CLIPPING!)
    -- ════════════════════════════════════════════════════════════
    local DropdownGui = Instance.new("ScreenGui")
    DropdownGui.Name = "DropdownOverlay"
    DropdownGui.ResetOnSpawn = false
    DropdownGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    DropdownGui.DisplayOrder = 999  -- On top of everything
    DropdownGui.Parent = game.CoreGui
    
    local OptionsContainer = Instance.new("ScrollingFrame", DropdownGui)
    OptionsContainer.Size = UDim2.fromOffset(isMobile and 100 or 90, 0)
    OptionsContainer.Position = UDim2.fromOffset(0, 0)  -- Will be set dynamically
    OptionsContainer.BackgroundColor3 = Color3.fromRGB(35, 35, 40)
    OptionsContainer.BorderSizePixel = 0
    OptionsContainer.Visible = false
    OptionsContainer.ClipsDescendants = true
    OptionsContainer.ZIndex = 1000
    
    -- Scroll settings
    OptionsContainer.ScrollBarThickness = isMobile and 4 or 3
    OptionsContainer.ScrollBarImageColor3 = Color3.fromRGB(0, 255, 170)
    OptionsContainer.ScrollBarImageTransparency = 0.5
    OptionsContainer.CanvasSize = UDim2.fromOffset(0, 0)
    OptionsContainer.ScrollingDirection = Enum.ScrollingDirection.Y
    
    Instance.new("UICorner", OptionsContainer).CornerRadius = UDim.new(0, 4)
    
    local OptionsStroke = Instance.new("UIStroke", OptionsContainer)
    OptionsStroke.Color = Color3.fromRGB(0, 255, 170)
    OptionsStroke.Thickness = 1
    
    local OptionsList = Instance.new("UIListLayout", OptionsContainer)
    OptionsList.Padding = UDim.new(0, 2)
    
    local currentValue = default or options[1]
    local isOpen = false
    
    -- Update canvas size
    OptionsList:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        OptionsContainer.CanvasSize = UDim2.fromOffset(0, OptionsList.AbsoluteContentSize.Y)
    end)
    
    -- Create option buttons
    for _, option in ipairs(options) do
        local OptionButton = Instance.new("TextButton", OptionsContainer)
        OptionButton.Size = UDim2.new(1, -6, 0, isMobile and 28 or 24)  -- -6 for scrollbar
        OptionButton.BackgroundColor3 = Color3.fromRGB(40, 40, 45)
        OptionButton.BackgroundTransparency = 0.5
        OptionButton.BorderSizePixel = 0
        OptionButton.Text = option
        OptionButton.Font = Enum.Font.Gotham
        OptionButton.TextSize = isMobile and 10 or 9
        OptionButton.TextColor3 = Color3.fromRGB(255, 255, 255)
        OptionButton.AutoButtonColor = false
        OptionButton.ZIndex = 1001
        
        OptionButton.MouseEnter:Connect(function()
            TweenService:Create(OptionButton, TweenInfo.new(0.1), {
                BackgroundTransparency = 0.2
            }):Play()
        end)
        
        OptionButton.MouseLeave:Connect(function()
            TweenService:Create(OptionButton, TweenInfo.new(0.1), {
                BackgroundTransparency = 0.5
            }):Play()
        end)
        
        OptionButton.MouseButton1Click:Connect(function()
            currentValue = option
            DropdownButton.Text = option
            
            -- Close dropdown
            isOpen = false
            TweenService:Create(Arrow, TweenInfo.new(0.15), {Rotation = 0}):Play()
            TweenService:Create(OptionsContainer, TweenInfo.new(0.15), {
                Size = UDim2.fromOffset(isMobile and 100 or 90, 0)
            }):Play()
            
            task.wait(0.15)
            OptionsContainer.Visible = false
            Arrow.Text = "▼"
            
            if GUICore then GUICore.PlayClickSound() end
            if callback then callback(option) end
        end)
    end
    
    -- ════════════════════════════════════════════════════════════
    -- SMART DROPDOWN WITH ABSOLUTE POSITIONING
    -- ════════════════════════════════════════════════════════════
    local function UpdateDropdownPosition()
        -- Get button absolute position
        local buttonPos = DropdownButton.AbsolutePosition
        local buttonSize = DropdownButton.AbsoluteSize
        
        -- Calculate heights
        local itemHeight = isMobile and 28 or 24
        local padding = 2
        local maxVisibleItems = 5
        local totalItems = #options
        
        local targetHeight
        if totalItems <= maxVisibleItems then
            targetHeight = (itemHeight * totalItems) + (padding * (totalItems - 1))
        else
            targetHeight = (itemHeight * maxVisibleItems) + (padding * (maxVisibleItems - 1))
        end
        
        -- Get screen height
        local screenHeight = workspace.CurrentCamera.ViewportSize.Y
        
        -- Calculate space below and above button
        local spaceBelow = screenHeight - (buttonPos.Y + buttonSize.Y)
        local spaceAbove = buttonPos.Y
        
        local openUpward = false
        
        -- Check if should open upward
        if spaceBelow < targetHeight + 10 then
            if spaceAbove > spaceBelow and spaceAbove > targetHeight + 10 then
                openUpward = true
            end
        end
        
        -- Set position
        if openUpward then
            -- Open UPWARD
            OptionsContainer.Position = UDim2.fromOffset(
                buttonPos.X,
                buttonPos.Y - targetHeight - 5
            )
            Arrow.Text = "▲"
        else
            -- Open DOWNWARD
            OptionsContainer.Position = UDim2.fromOffset(
                buttonPos.X,
                buttonPos.Y + buttonSize.Y + 5
            )
            Arrow.Text = "▼"
        end
        
        return targetHeight
    end
    
    -- Toggle dropdown
    DropdownButton.MouseButton1Click:Connect(function()
        isOpen = not isOpen
        if GUICore then GUICore.PlayClickSound() end
        
        if isOpen then
            -- Update position before showing
            local targetHeight = UpdateDropdownPosition()
            
            OptionsContainer.Visible = true
            
            -- Animate open
            TweenService:Create(OptionsContainer, TweenInfo.new(0.2), {
                Size = UDim2.fromOffset(isMobile and 100 or 90, targetHeight)
            }):Play()
            TweenService:Create(Arrow, TweenInfo.new(0.2), {Rotation = 180}):Play()
        else
            -- Animate close
            TweenService:Create(Arrow, TweenInfo.new(0.2), {Rotation = 0}):Play()
            TweenService:Create(OptionsContainer, TweenInfo.new(0.2), {
                Size = UDim2.fromOffset(isMobile and 100 or 90, 0)
            }):Play()
            task.wait(0.2)
            OptionsContainer.Visible = false
            Arrow.Text = "▼"
        end
    end)
    
    -- ════════════════════════════════════════════════════════════
    -- CLOSE DROPDOWN WHEN CLICKING OUTSIDE
    -- ════════════════════════════════════════════════════════════
    local UserInputService = game:GetService("UserInputService")
    
    UserInputService.InputBegan:Connect(function(input, gameProcessed)
        if not isOpen then return end
        
        if input.UserInputType == Enum.UserInputType.MouseButton1 or 
           input.UserInputType == Enum.UserInputType.Touch then
            
            local mousePos = UserInputService:GetMouseLocation()
            local buttonPos = DropdownButton.AbsolutePosition
            local buttonSize = DropdownButton.AbsoluteSize
            local optionsPos = OptionsContainer.AbsolutePosition
            local optionsSize = OptionsContainer.AbsoluteSize
            
            -- Check if clicked outside button and options
            local clickedButton = mousePos.X >= buttonPos.X and mousePos.X <= buttonPos.X + buttonSize.X and
                                  mousePos.Y >= buttonPos.Y and mousePos.Y <= buttonPos.Y + buttonSize.Y
            
            local clickedOptions = mousePos.X >= optionsPos.X and mousePos.X <= optionsPos.X + optionsSize.X and
                                   mousePos.Y >= optionsPos.Y and mousePos.Y <= optionsPos.Y + optionsSize.Y
            
            if not clickedButton and not clickedOptions then
                -- Clicked outside - close dropdown
                isOpen = false
                TweenService:Create(Arrow, TweenInfo.new(0.15), {Rotation = 0}):Play()
                TweenService:Create(OptionsContainer, TweenInfo.new(0.15), {
                    Size = UDim2.fromOffset(isMobile and 100 or 90, 0)
                }):Play()
                task.wait(0.15)
                OptionsContainer.Visible = false
                Arrow.Text = "▼"
            end
        end
    end)
    
    -- Cleanup when dropdown is destroyed
    Dropdown.AncestryChanged:Connect(function(_, parent)
        if not parent then
            DropdownGui:Destroy()
        end
    end)
    
    return Dropdown, function() return currentValue end, function(newValue)
        if table.find(options, newValue) then
            currentValue = newValue
            DropdownButton.Text = newValue
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
