--[[
════════════════════════════════════════════════════════════════
    📦 LOADER EXAMPLE
    Contoh cara pakai Modular GUI System
    
    CARA PAKAI:
    1. Upload GUI_Core.lua dan GUI_Components.lua ke GitHub/Pastebin
    2. Ganti URL di bawah dengan URL raw kamu
    3. Execute loader ini!
════════════════════════════════════════════════════════════════
]]

print("━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━")
print("🔄 LOADING MODULAR GUI SYSTEM...")
print("━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━")

--════════════════════════════════════════════════════════════════
-- LOAD MODULES (GANTI URL INI!)
--════════════════════════════════════════════════════════════════
local GUICore = loadstring(game:HttpGet("YOUR_GUI_CORE_URL_HERE"))()
local Components = loadstring(game:HttpGet("YOUR_GUI_COMPONENTS_URL_HERE"))()

-- Initialize Components with GUICore (untuk sound effects)
Components.Init(GUICore)

print("✅ Modules loaded!")
print("━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━")

--════════════════════════════════════════════════════════════════
-- CREATE GUI
--════════════════════════════════════════════════════════════════
local MyGui = GUICore.new({
    Title = "MY AWESOME SCRIPT",
    Version = "v1.0",
    -- Size = UDim2.fromOffset(650, 520),  -- Optional: custom size
    -- Theme = Color3.fromRGB(255, 100, 100)  -- Optional: custom theme color
})

print("✅ GUI Created!")

--════════════════════════════════════════════════════════════════
-- CREATE TABS
--════════════════════════════════════════════════════════════════
local MainTab = MyGui:AddTab("Main", "🎯")
local CombatTab = MyGui:AddTab("Combat", "⚔️")
local VisualsTab = MyGui:AddTab("Visuals", "👁️")
local SettingsTab = MyGui:AddTab("Settings", "⚙️")

print("✅ Tabs created!")

--════════════════════════════════════════════════════════════════
-- MAIN TAB - EXAMPLE COMPONENTS
--════════════════════════════════════════════════════════════════

-- SECTION 1: Toggles
local Section1, AddToSection1 = Components:CreateSection(MainTab, "⚡ Features")

local Toggle1 = Components:CreateToggle(MainTab, "Super Speed", false, function(enabled)
    print("Super Speed:", enabled)
    -- Your code here
end)
AddToSection1(Toggle1)

local Toggle2 = Components:CreateToggle(MainTab, "Infinite Jump", false, function(enabled)
    print("Infinite Jump:", enabled)
    -- Your code here
end)
AddToSection1(Toggle2)

local Toggle3 = Components:CreateToggle(MainTab, "Fly Mode", false, function(enabled)
    print("Fly Mode:", enabled)
    -- Your code here
end)
AddToSection1(Toggle3)

-- SECTION 2: Sliders
local Section2, AddToSection2 = Components:CreateSection(MainTab, "⚙️ Settings")

local Slider1, GetSpeed = Components:CreateSlider(MainTab, "Walk Speed", 16, 200, 50, function(value)
    print("Walk Speed:", value)
    -- Your code here
end)
AddToSection2(Slider1)

local Slider2, GetJump = Components:CreateSlider(MainTab, "Jump Power", 50, 300, 100, function(value)
    print("Jump Power:", value)
    -- Your code here
end)
AddToSection2(Slider2)

-- SECTION 3: Textbox ✨ (NEW)
local Section3, AddToSection3 = Components:CreateSection(MainTab, "📝 Input")

local Textbox1, GetPlayerName = Components:CreateTextbox(MainTab, "Player Name", "Enter player name...", function(text)
    print("Player Name:", text)
    GUICore.Notify("Player Name", "Set to: " .. text, 2)
end)
AddToSection3(Textbox1)

local Textbox2, GetGameId = Components:CreateTextbox(MainTab, "Game ID", "Enter game ID...", function(text)
    print("Game ID:", text)
    -- Your code here
end)
AddToSection3(Textbox2)

--════════════════════════════════════════════════════════════════
-- COMBAT TAB - EXAMPLE
--════════════════════════════════════════════════════════════════

local CombatSection1, AddToCombat1 = Components:CreateSection(CombatTab, "⚔️ Combat Features")

local AimbotToggle = Components:CreateToggle(CombatTab, "Aimbot", false, function(enabled)
    print("Aimbot:", enabled)
    -- Your aimbot code here
end)
AddToCombat1(AimbotToggle)

local ESPToggle = Components:CreateToggle(CombatTab, "ESP", false, function(enabled)
    print("ESP:", enabled)
    -- Your ESP code here
end)
AddToCombat1(ESPToggle)

-- Dropdown ✨ (NEW)
local TargetPartDropdown, GetTargetPart = Components:CreateDropdown(
    CombatTab, 
    "Target Part", 
    {"Head", "Torso", "HumanoidRootPart", "Random"}, 
    "Head", 
    function(selected)
        print("Target Part changed to:", selected)
        GUICore.Notify("Target Part", "Changed to: " .. selected, 2)
    end
)
AddToCombat1(TargetPartDropdown)

-- Slider for FOV
local FOVSlider = Components:CreateSlider(CombatTab, "FOV Radius", 50, 500, 150, function(value)
    print("FOV Radius:", value)
    -- Your FOV code here
end)
AddToCombat1(FOVSlider)

--════════════════════════════════════════════════════════════════
-- VISUALS TAB - EXAMPLE
--════════════════════════════════════════════════════════════════

local VisualSection1, AddToVisual1 = Components:CreateSection(VisualsTab, "🎨 Visual Settings")

-- Color Picker
local ESPColorPicker = Components:CreateColorPicker(VisualsTab, "ESP Color", Color3.fromRGB(255, 0, 0), function(color)
    print("ESP Color:", color)
    -- Your color change code here
end)
AddToVisual1(ESPColorPicker)

local TracerColorPicker = Components:CreateColorPicker(VisualsTab, "Tracer Color", Color3.fromRGB(0, 255, 0), function(color)
    print("Tracer Color:", color)
    -- Your color change code here
end)
AddToVisual1(TracerColorPicker)

-- More toggles
local SkeletonESP = Components:CreateToggle(VisualsTab, "Skeleton ESP", false, function(enabled)
    print("Skeleton ESP:", enabled)
end)
AddToVisual1(SkeletonESP)

local Chams = Components:CreateToggle(VisualsTab, "Chams", false, function(enabled)
    print("Chams:", enabled)
end)
AddToVisual1(Chams)

--════════════════════════════════════════════════════════════════
-- SETTINGS TAB - EXAMPLE
--════════════════════════════════════════════════════════════════

local SettingsSection1, AddToSettings1 = Components:CreateSection(SettingsTab, "⌨️ Keybinds")

-- Keybinds (PC only)
local isMobile = game:GetService("UserInputService").TouchEnabled and not game:GetService("UserInputService").MouseEnabled

if not isMobile then
    local Keybind1 = Components:CreateKeybind(SettingsTab, "Toggle Aimbot", Enum.KeyCode.E, function(key)
        print("Aimbot keybind changed to:", key)
        -- Your keybind code here
    end)
    AddToSettings1(Keybind1)
    
    local Keybind2 = Components:CreateKeybind(SettingsTab, "Toggle ESP", Enum.KeyCode.T, function(key)
        print("ESP keybind changed to:", key)
        -- Your keybind code here
    end)
    AddToSettings1(Keybind2)
    
    local Keybind3 = Components:CreateKeybind(SettingsTab, "Toggle Fly", Enum.KeyCode.F, function(key)
        print("Fly keybind changed to:", key)
        -- Your keybind code here
    end)
    AddToSettings1(Keybind3)
else
    -- Mobile info
    local MobileInfo = Instance.new("TextLabel")
    MobileInfo.Size = UDim2.new(1, 0, 0, 80)
    MobileInfo.BackgroundColor3 = Color3.fromRGB(35, 35, 40)
    MobileInfo.BorderSizePixel = 0
    MobileInfo.Text = "📱 MOBILE MODE\n\nKeybinds are not available on mobile.\nUse GUI toggles instead."
    MobileInfo.Font = Enum.Font.Gotham
    MobileInfo.TextSize = 11
    MobileInfo.TextColor3 = Color3.fromRGB(200, 200, 200)
    MobileInfo.TextWrapped = true
    
    Instance.new("UICorner", MobileInfo).CornerRadius = UDim.new(0, 6)
    
    local Padding = Instance.new("UIPadding", MobileInfo)
    Padding.PaddingTop = UDim.new(0, 10)
    Padding.PaddingLeft = UDim.new(0, 10)
    Padding.PaddingRight = UDim.new(0, 10)
    
    AddToSettings1(MobileInfo)
end

-- Buttons
local SettingsSection2, AddToSettings2 = Components:CreateSection(SettingsTab, "🔧 Actions")

local ResetButton = Components:CreateButton(SettingsTab, "Reset All Settings", function()
    GUICore.Notify("Reset", "All settings have been reset!", 3)
    print("Settings reset!")
end)
AddToSettings2(ResetButton)

local SaveButton = Components:CreateButton(SettingsTab, "Save Configuration", function()
    GUICore.Notify("Save", "Configuration saved!", 2)
    print("Config saved!")
end)
AddToSettings2(SaveButton)

--════════════════════════════════════════════════════════════════
-- DROPDOWN EXAMPLE (IN SETTINGS)
--════════════════════════════════════════════════════════════════
local SettingsSection3, AddToSettings3 = Components:CreateSection(SettingsTab, "🎨 Theme")

local ThemeDropdown = Components:CreateDropdown(
    SettingsTab,
    "Theme Color",
    {"Cyan", "Red", "Green", "Blue", "Purple", "Orange"},
    "Cyan",
    function(selected)
        local colors = {
            Cyan = Color3.fromRGB(0, 255, 170),
            Red = Color3.fromRGB(255, 0, 0),
            Green = Color3.fromRGB(0, 255, 0),
            Blue = Color3.fromRGB(0, 100, 255),
            Purple = Color3.fromRGB(200, 0, 255),
            Orange = Color3.fromRGB(255, 150, 0)
        }
        
        -- Change theme color (would need to update GUI)
        print("Theme changed to:", selected)
        GUICore.Notify("Theme", "Changed to " .. selected, 2)
    end
)
AddToSettings3(ThemeDropdown)

--════════════════════════════════════════════════════════════════
-- DONE!
--════════════════════════════════════════════════════════════════
print("━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━")
print("🎯 MODULAR GUI LOADED!")
print("✅ All components created")
print("✅ Ready to use!")
print("━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━")

GUICore.Notify("Welcome!", "Modular GUI System loaded!", 5)

--════════════════════════════════════════════════════════════════
-- HOW TO GET VALUES FROM COMPONENTS
--════════════════════════════════════════════════════════════════
--[[
    GETTING VALUES:
    
    -- From Slider:
    local currentSpeed = GetSpeed()
    print("Current speed:", currentSpeed)
    
    -- From Textbox:
    local playerName = GetPlayerName()
    print("Player name:", playerName)
    
    -- From Dropdown:
    local targetPart = GetTargetPart()
    print("Target part:", targetPart)
]]

--════════════════════════════════════════════════════════════════
-- EXAMPLE: Using component values
--════════════════════════════════════════════════════════════════
task.spawn(function()
    while task.wait(5) do
        -- Example: print current speed every 5 seconds
        local speed = GetSpeed()
        local jump = GetJump()
        print("Current Speed:", speed, "| Jump:", jump)
    end
end)
