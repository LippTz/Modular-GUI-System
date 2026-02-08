# 🎯 MODULAR GUI SYSTEM v1.0

Sistem GUI modular untuk Roblox Executor dengan support mobile lengkap!

---

## 📦 FILE STRUCTURE

```
📁 Modular GUI System
├── 📄 GUI_Core.lua          → Core GUI system (main framework)
├── 📄 GUI_Components.lua    → UI Elements (Toggle, Slider, Button, etc)
├── 📄 Loader_Example.lua    → Contoh cara pakai
└── 📄 README.md             → Dokumentasi ini
```

---

## ✨ FEATURES

### 🎨 **GUI Core:**
- ✅ Modern UI Design (dari Aimlock script)
- ✅ Mobile Support (0.45 x 0.75 responsive)
- ✅ Draggable (PC & Mobile)
- ✅ Tab System
- ✅ Notification System
- ✅ Sound Effects
- ✅ Floating Toggle Button
- ✅ Animated Border
- ✅ Blur Background

### 🧩 **Components:**
- ✅ **Section** (Collapsible)
- ✅ **Toggle** (On/Off switch)
- ✅ **Slider** (dengan editable textbox)
- ✅ **Button** (Click action)
- ✅ **Textbox** ✨ (NEW - Input field)
- ✅ **Dropdown** ✨ (NEW - Select options)
- ✅ **ColorPicker** (Cycle colors)
- ✅ **Keybind** (PC only - Key binding)

---

## 🚀 QUICK START

### 1️⃣ **Upload Files ke Pastebin/GitHub**

Upload kedua file ini:
- `GUI_Core.lua`
- `GUI_Components.lua`

Dapatkan **raw URL** nya.

### 2️⃣ **Buat Loader Script**

```lua
-- Load modules
local GUICore = loadstring(game:HttpGet("YOUR_GUI_CORE_URL"))()
local Components = loadstring(game:HttpGet("YOUR_COMPONENTS_URL"))()

-- Initialize
Components.Init(GUICore)

-- Create GUI
local MyGui = GUICore.new({
    Title = "MY SCRIPT",
    Version = "v1.0"
})

-- Add Tab
local MainTab = MyGui:AddTab("Main", "🎯")

-- Add Components
local Toggle1 = Components:CreateToggle(MainTab, "Feature 1", false, function(enabled)
    print("Feature 1:", enabled)
end)
```

### 3️⃣ **Execute!**

Execute loader script kamu di Roblox executor!

---

## 📖 DOCUMENTATION

### 🎯 **1. CREATE GUI**

```lua
local MyGui = GUICore.new({
    Title = "MY AWESOME SCRIPT",      -- Judul GUI
    Version = "v1.0",                  -- Versi
    Size = UDim2.fromOffset(650, 520), -- (Optional) Custom size
    Theme = Color3.fromRGB(0, 255, 170) -- (Optional) Custom theme color
})
```

**Default values:**
- **Mobile:** Size = `UDim2.new(0.45, 0, 0.75, 0)`
- **PC:** Size = `UDim2.fromOffset(650, 520)`
- **Theme:** `Color3.fromRGB(0, 255, 170)` (Cyan)

---

### 📑 **2. ADD TAB**

```lua
local MainTab = MyGui:AddTab("Main", "🎯")
local CombatTab = MyGui:AddTab("Combat", "⚔️")
```

**Parameters:**
- `name` - Nama tab
- `icon` - Emoji icon (opsional)

**Returns:** TabPage (Frame untuk add components)

---

### 📦 **3. CREATE SECTION (Collapsible)**

```lua
local Section1, AddToSection1 = Components:CreateSection(MainTab, "⚡ Features")

-- Add components to section
local Toggle1 = Components:CreateToggle(MainTab, "Feature 1", false, function() end)
AddToSection1(Toggle1)
```

**Parameters:**
- `parent` - Parent frame (TabPage)
- `text` - Section title

**Returns:**
- `SectionContainer` - Section frame
- `AddToSection` - Function untuk add items ke section

---

### 🎚️ **4. CREATE TOGGLE**

```lua
local Toggle, GetState, SetState = Components:CreateToggle(
    parent,        -- Parent frame
    "ESP",         -- Label text
    false,         -- Default value (true/false)
    function(enabled)
        print("ESP:", enabled)
        -- Your code here
    end
)
```

**Returns:**
- `Toggle` - Toggle frame
- `GetState()` - Function untuk get current state
- `SetState(bool)` - Function untuk set state

**Example:**
```lua
-- Get current state
local isEnabled = GetState()
print(isEnabled)  -- true/false

-- Set state
SetState(true)  -- Force enable
```

---

### 🎚️ **5. CREATE SLIDER**

```lua
local Slider, GetValue, SetValue = Components:CreateSlider(
    parent,     -- Parent frame
    "Speed",    -- Label text
    1,          -- Min value
    100,        -- Max value
    50,         -- Default value
    function(value)
        print("Speed:", value)
        -- Your code here
    end
)
```

**Features:**
- ✅ Draggable slider
- ✅ Editable textbox
- ✅ Click on bar to jump

**Returns:**
- `Slider` - Slider frame
- `GetValue()` - Function untuk get current value
- `SetValue(num)` - Function untuk set value

**Example:**
```lua
-- Get current value
local speed = GetValue()
print(speed)  -- 50

-- Set value
SetValue(75)
```

---

### 📝 **6. CREATE TEXTBOX** ✨ (NEW)

```lua
local Textbox, GetText, SetText = Components:CreateTextbox(
    parent,                 -- Parent frame
    "Player Name",          -- Label text
    "Enter name...",        -- Placeholder text
    function(text)
        print("Input:", text)
        -- Your code here
    end
)
```

**Features:**
- ✅ Enter key to submit
- ✅ Focus animation
- ✅ Placeholder text

**Returns:**
- `Textbox` - Textbox frame
- `GetText()` - Function untuk get current text
- `SetText(str)` - Function untuk set text

**Example:**
```lua
-- Get current text
local playerName = GetText()
print(playerName)

-- Set text
SetText("NewPlayer123")
```

---

### 📋 **7. CREATE DROPDOWN** ✨ (NEW)

```lua
local Dropdown, GetValue, SetValue = Components:CreateDropdown(
    parent,                    -- Parent frame
    "Target Part",             -- Label text
    {"Head", "Torso", "Legs"}, -- Options array
    "Head",                    -- Default selected
    function(selected)
        print("Selected:", selected)
        -- Your code here
    end
)
```

**Features:**
- ✅ Animated dropdown
- ✅ Click to open/close
- ✅ Hover effects

**Returns:**
- `Dropdown` - Dropdown frame
- `GetValue()` - Function untuk get selected option
- `SetValue(str)` - Function untuk set option

**Example:**
```lua
-- Get selected option
local targetPart = GetValue()
print(targetPart)  -- "Head"

-- Set option
SetValue("Torso")
```

---

### 🔘 **8. CREATE BUTTON**

```lua
local Button = Components:CreateButton(
    parent,              -- Parent frame
    "Reset Settings",    -- Button text
    function()
        print("Button clicked!")
        -- Your code here
    end
)
```

**Features:**
- ✅ Click animation
- ✅ Hover effects

---

### 🎨 **9. CREATE COLOR PICKER**

```lua
local ColorPicker, GetColor = Components:CreateColorPicker(
    parent,                      -- Parent frame
    "ESP Color",                 -- Label text
    Color3.fromRGB(255, 0, 0),   -- Default color
    function(color)
        print("Color:", color)
        -- Your code here
    end
)
```

**Features:**
- ✅ Click to cycle through preset colors
- ✅ 8 preset colors

**Returns:**
- `ColorPicker` - ColorPicker frame
- `GetColor()` - Function untuk get current color

**Example:**
```lua
local currentColor = GetColor()
print(currentColor)  -- Color3
```

---

### ⌨️ **10. CREATE KEYBIND** (PC Only)

```lua
local Keybind, GetKey = Components:CreateKeybind(
    parent,               -- Parent frame
    "Toggle Aimbot",      -- Label text
    Enum.KeyCode.E,       -- Default key
    function(key)
        print("Key changed to:", key)
        -- Your code here
    end
)
```

**Features:**
- ✅ Click to rebind
- ✅ ESC to cancel
- ✅ Auto-detect key names

**Returns:**
- `Keybind` - Keybind frame
- `GetKey()` - Function untuk get current key

---

## 🔔 **NOTIFICATION SYSTEM**

```lua
GUICore.Notify(
    "Title",              -- Notification title
    "Message here",       -- Notification message
    3                     -- Duration (seconds)
)
```

**Example:**
```lua
GUICore.Notify("Success", "Feature enabled!", 2)
GUICore.Notify("Warning", "Invalid input!", 3)
```

---

## 🔊 **SOUND EFFECTS**

```lua
-- Play click sound
GUICore.PlayClickSound()

-- Play toggle sound
GUICore.PlayToggleSound()

-- Play close sound
GUICore.PlayCloseSound()

-- Custom sound
GUICore.PlaySound(
    "8394620892",  -- Sound ID
    0.7,           -- Volume (0-1)
    1              -- Pitch
)
```

---

## 🗑️ **DESTROY GUI**

```lua
MyGui:Destroy()
```

Akan:
- ✅ Animate close
- ✅ Destroy GUI
- ✅ Destroy toggle button
- ✅ Print status

---

## 💡 FULL EXAMPLE

```lua
-- Load modules
local GUICore = loadstring(game:HttpGet("YOUR_CORE_URL"))()
local Components = loadstring(game:HttpGet("YOUR_COMPONENTS_URL"))()
Components.Init(GUICore)

-- Create GUI
local MyGui = GUICore.new({
    Title = "SUPER SCRIPT",
    Version = "v2.0"
})

-- Create tabs
local MainTab = MyGui:AddTab("Main", "🎯")
local SettingsTab = MyGui:AddTab("Settings", "⚙️")

-- Add section with components
local Section1, AddToSection1 = Components:CreateSection(MainTab, "⚡ Features")

-- Toggle
local ESPToggle = Components:CreateToggle(MainTab, "ESP", false, function(enabled)
    print("ESP:", enabled)
end)
AddToSection1(ESPToggle)

-- Slider
local SpeedSlider, GetSpeed = Components:CreateSlider(MainTab, "Speed", 16, 200, 50, function(value)
    game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = value
end)
AddToSection1(SpeedSlider)

-- Textbox
local NameBox, GetName = Components:CreateTextbox(MainTab, "Player Name", "Enter name...", function(text)
    print("Teleport to:", text)
    -- Teleport code here
end)
AddToSection1(NameBox)

-- Dropdown
local WeaponDropdown, GetWeapon = Components:CreateDropdown(
    MainTab,
    "Weapon",
    {"Sword", "Gun", "Bow", "Staff"},
    "Sword",
    function(selected)
        print("Equipped:", selected)
    end
)
AddToSection1(WeaponDropdown)

-- Button
local ResetBtn = Components:CreateButton(MainTab, "Reset Character", function()
    game.Players.LocalPlayer.Character.Humanoid.Health = 0
end)
AddToSection1(ResetBtn)

print("🎯 GUI Loaded!")
```

---

## 📱 MOBILE SUPPORT

GUI otomatis detect mobile dan adjust:

- ✅ Size: `0.45 x 0.75` (45% width, 75% height)
- ✅ Larger buttons (50x50 toggle button)
- ✅ Touch-friendly controls
- ✅ Custom drag system
- ✅ Larger text sizes

**Note:** Keybinds tidak tersedia di mobile (akan auto-hide)

---

## 🎨 CUSTOMIZATION

### **Change Theme Color:**
```lua
local MyGui = GUICore.new({
    Title = "MY SCRIPT",
    Theme = Color3.fromRGB(255, 0, 0)  -- Red theme
})
```

### **Change GUI Size:**
```lua
local MyGui = GUICore.new({
    Title = "MY SCRIPT",
    Size = UDim2.fromOffset(800, 600)  -- Bigger GUI
})
```

---

## 🐛 TROUBLESHOOTING

### **Problem: GUI tidak muncul**
**Solution:**
- Check URL sudah benar
- Check executor support `HttpGet`
- Check console untuk errors

### **Problem: Components tidak berfungsi**
**Solution:**
- Pastikan `Components.Init(GUICore)` sudah dipanggil
- Check parent frame (TabPage) benar

### **Problem: Mobile size tidak sesuai**
**Solution:**
- Jangan set custom size untuk mobile
- Biarkan default: `UDim2.new(0.45, 0, 0.75, 0)`

---

## 📝 NOTES

1. **Sections bisa diklik** untuk collapse/expand
2. **Slider bisa diinput manual** via textbox
3. **Dropdown auto-close** setelah select
4. **Keybind** hanya di PC (auto-hide di mobile)
5. **Sound effects** bisa disabled dengan tidak init GUICore

---

## 🔄 UPDATES

### **v1.0 (Current)**
- ✅ Initial release
- ✅ Full modular system
- ✅ Mobile support
- ✅ All components working
- ✅ Textbox component
- ✅ Dropdown component

---

## 📧 SUPPORT

Jika ada bug atau request fitur, buat issue di GitHub atau contact creator.

---

## ⭐ CREDITS

- **GUI Design:** From Aimlock Pro v3.0
- **Modular System:** Custom built
- **Mobile Support:** Fully optimized

---

**Happy Scripting! 🎯**
