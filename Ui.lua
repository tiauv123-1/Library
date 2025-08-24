--// =========================
--//  NGHĨA DZ — FULL UI
--// =========================

--== CẤU HÌNH MÀU
local Configs_HUB = {
    Cor_Hub      = Color3.fromRGB(28, 28, 28),
    Cor_Options  = Color3.fromRGB(36, 36, 36),
    Cor_Stroke   = Color3.fromRGB(85, 85, 85),
    Cor_Text     = Color3.fromRGB(235, 235, 235),
    Cor_DarkText = Color3.fromRGB(190, 190, 190),
    Text_Font    = Enum.Font.GothamSemibold
}

--== TIỆN ÍCH TẠO UI
local TweenService = game:GetService("TweenService")
local UIS          = game:GetService("UserInputService")

local function Create(class, parent, props)
    local o = Instance.new(class)
    for k,v in pairs(props or {}) do
        o[k] = v
    end
    o.Parent = parent
    return o
end

local function Corner(obj, props)
    local c = Instance.new("UICorner")
    if props and props.CornerRadius then
        c.CornerRadius = props.CornerRadius
    else
        c.CornerRadius = UDim.new(0, 8)
    end
    c.Parent = obj
    return c
end

local function Stroke(obj, props)
    local s = Instance.new("UIStroke")
    s.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    s.Thickness = props and props.Thickness or 1
    s.Color = props and props.Color or Configs_HUB.Cor_Stroke
    s.Transparency = props and props.Transparency or 0.35
    s.Parent = obj
    return s
end

local function CreateTween(obj, prop, value, time, reverse)
    local t = TweenService:Create(obj, TweenInfo.new(time or 0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {[prop]=value})
    t:Play()
    if reverse == true then
        t.Completed:Wait()
    end
end

--== SCREEN + MENU CHÍNH
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "NghiaDzUI"
ScreenGui.ResetOnSpawn = false
ScreenGui.IgnoreGuiInset = true
ScreenGui.Parent = game:GetService("PlayerGui")

local Menu = Create("Frame", ScreenGui, {
    Name = "Menu",
    Size = UDim2.new(0, 500, 0, 270),
    Position = UDim2.new(0.5, -250, 0.5, -135),
    BackgroundColor3 = Configs_HUB.Cor_Hub,
    Active = true
})
Corner(Menu) Stroke(Menu)

--== TOPBAR (Logo + Title) + DRAG
local TopBar = Create("Frame", Menu, {
    Size = UDim2.new(1, 0, 0, 32),
    BackgroundColor3 = Configs_HUB.Cor_Options
})
Corner(TopBar) Stroke(TopBar)

local Logo = Create("ImageLabel", TopBar, {
    Size = UDim2.new(0, 22, 0, 22),
    Position = UDim2.new(0, 6, 0.5, 0),
    AnchorPoint = Vector2.new(0, 0.5),
    BackgroundTransparency = 1,
    Image = "http://www.roblox.com/asset/?id=114803447252543"
})

local Title = Create("TextLabel", TopBar, {
    Size = UDim2.new(1, -70, 1, 0),
    Position = UDim2.new(0, 34, 0, 0),
    BackgroundTransparency = 1,
    Text = "Nghĩa Dz",
    Font = Configs_HUB.Text_Font,
    TextSize = 14,
    TextXAlignment = Enum.TextXAlignment.Left,
    TextColor3 = Configs_HUB.Cor_Text
})

--== DRAG MENU
do
    local dragging = false
    local dragStart, startPos
    TopBar.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPos = Menu.Position
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                end
            end)
        end
    end)
    TopBar.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
            if dragging then
                local delta = input.Position - dragStart
                Menu.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
            end
        end
    end)
end

--== NÚT THU NHỎ
local function MinimizeButton(Configs)
    local image = Configs.Image or "http://www.roblox.com/asset/?id=114803447252543"
    local size  = Configs.Size  or {55, 55}

    local Button = Create("ImageButton", ScreenGui, {
        Size = UDim2.new(0, size[1], 0, size[2]),
        Position = UDim2.new(0.08, 0, 0.12, 0),
        BackgroundColor3 = Configs_HUB.Cor_Options,
        Image = image,
        Active = true
    })
    Corner(Button) Stroke(Button)

    local minimize = false
    Button.MouseButton1Click:Connect(function()
        if minimize then
            minimize = false
            Menu.Visible = true
            CreateTween(Menu, "Size", UDim2.new(0, 500, 0, 270), 0.28, false)
        else
            minimize = true
            CreateTween(Menu, "Size", UDim2.new(0, 500, 0, 0), 0.26, true)
            Menu.Visible = false
        end
    end)
end
MinimizeButton({})

--== THANH TABS
local ScrollBar = Create("ScrollingFrame", Menu, {
    Size = UDim2.new(0, 140, 1, -(TopBar.Size.Y.Offset + 2)),
    Position = UDim2.new(0, 0, 1, 0),
    AnchorPoint = Vector2.new(0,1),
    AutomaticCanvasSize = Enum.AutomaticSize.Y,
    ScrollingDirection = Enum.ScrollingDirection.Y,
    BackgroundTransparency = 1,
    ScrollBarThickness = 2
})
Create("UIListLayout", ScrollBar, {Padding = UDim.new(0, 5), SortOrder = Enum.SortOrder.LayoutOrder})

local Containers = Create("Frame", Menu, {
    Size = UDim2.new(1, -(ScrollBar.Size.X.Offset + 2), 1, -(TopBar.Size.Y.Offset + 2)),
    AnchorPoint = Vector2.new(1,1),
    Position = UDim2.new(1, 0, 1, 0),
    BackgroundTransparency = 1
})
Corner(Containers)

--== QUẢN LÝ TAB
local Tabs, FirstTab = {}, true
local function AddTab(Name)
    local Btn = Create("TextButton", ScrollBar, {
        Size = UDim2.new(1, -2, 0, 28),
        Text = Name or "Tab",
        AutoButtonColor = false,
        BackgroundColor3 = Configs_HUB.Cor_Options,
        Font = Configs_HUB.Text_Font,
        TextSize = 14,
        TextColor3 = Configs_HUB.Cor_Text
    })
    Corner(Btn) Stroke(Btn)

    local Page = Create("ScrollingFrame", Containers, {
        Size = UDim2.new(1, -12, 1, -12),
        Position = UDim2.new(0, 8, 0, 8),
        BackgroundColor3 = Configs_HUB.Cor_Hub,
        BackgroundTransparency = 0.1,
        ScrollBarThickness = 3,
        AutomaticCanvasSize = Enum.AutomaticSize.Y,
        Visible = false
    })
    Corner(Page) Stroke(Page)
    Create("UIListLayout", Page, {Padding = UDim.new(0,6), SortOrder = Enum.SortOrder.LayoutOrder})

    Btn.MouseButton1Click:Connect(function()
        for _,t in ipairs(Tabs) do t.Page.Visible = false end
        Page.Visible = true
    end)

    if FirstTab then
        FirstTab = false
        Page.Visible = true
    end
    table.insert(Tabs, {Button = Btn, Page = Page})
    return Page
end

--== BUTTON
local function AddButton(parent, Configs)
    local Btn = Create("TextButton", parent, {
        Size = UDim2.new(1, -12, 0, 28),
        Text = Configs.Name or "Button",
        BackgroundColor3 = Configs_HUB.Cor_Options,
        AutoButtonColor = true,
        Font = Configs_HUB.Text_Font,
        TextSize = 14,
        TextColor3 = Configs_HUB.Cor_Text
    })
    Corner(Btn) Stroke(Btn)
    Btn.MouseButton1Click:Connect(function() Configs.Callback() end)
end

--== TOGGLE
local function AddToggle(parent, Configs)
    local state = Configs.Default or false
    local Row = Create("TextButton", parent, {
        Size = UDim2.new(1, -12, 0, 28),
        BackgroundColor3 = Configs_HUB.Cor_Options,
        Text = "",
        AutoButtonColor = false
    }) Corner(Row) Stroke(Row)

    local Label = Create("TextLabel", Row, {
        Size = UDim2.new(1, -42, 1, 0),
        Position = UDim2.new(0, 10, 0, 0),
        BackgroundTransparency = 1,
        Text = Configs.Name or "Toggle!!",
        Font = Configs_HUB.Text_Font,
        TextSize = 14,
        TextXAlignment = Enum.TextXAlignment.Left,
        TextColor3 = Configs_HUB.Cor_Text
    })

    local Box = Create("Frame", Row, {
        Size = UDim2.new(0, 20, 0, 20),
        Position = UDim2.new(1, -24, 0.5, 0),
        AnchorPoint = Vector2.new(0.5, 0.5),
        BackgroundColor3 = Configs_HUB.Cor_Hub
    }) Corner(Box) Stroke(Box)

    local Inner = Create("Frame", Box, {
        Size = UDim2.new(1, -6, 1, -6),
        Position = UDim2.new(0.5, 0, 0.5, 0),
        AnchorPoint = Vector2.new(0.5, 0.5),
        BackgroundColor3 = Color3.fromRGB(255,255,255),
        BackgroundTransparency = state and 0 or 1
    }) Corner(Inner)

    Row.MouseButton1Click:Connect(function()
        state = not state
        CreateTween(Inner, "BackgroundTransparency", state and 0 or 1, 0.18, false)
        Configs.Callback(state)
    end)
    Configs.Callback(state)
end

--== SLIDER (PC + Mobile)
local function AddSlider(parent, Configs)
    local SliderName, MinValue, MaxValue = Configs.Name or "Slider!!", Configs.Min or 0, Configs.Max or 100
    local Default = math.clamp(Configs.Default or MinValue, MinValue, MaxValue)
    local Callback = Configs.Callback or function() end

    local Frame = Create("Frame", parent, {Size = UDim2.new(1, -12, 0, 46), BackgroundColor3 = Configs_HUB.Cor_Options}) Corner(Frame) Stroke(Frame)

    Create("TextLabel", Frame, {
        Text = SliderName, Size = UDim2.new(1, -60, 0, 16), Position = UDim2.new(0, 10, 0, 6),
        BackgroundTransparency = 1, Font = Configs_HUB.Text_Font, TextSize = 13, TextXAlignment = Enum.TextXAlignment.Left, TextColor3 = Configs_HUB.Cor_Text
    })

    local ValueLabel = Create("TextLabel", Frame, {
        Text = tostring(Default), Size = UDim2.new(0, 52, 0, 16), Position = UDim2.new(1, -58, 0, 6),
        BackgroundTransparency = 1, Font = Configs_HUB.Text_Font, TextSize = 13, TextXAlignment = Enum.TextXAlignment.Right, TextColor3 = Configs_HUB.Cor_DarkText
    })

    local Bar = Create("Frame", Frame, {Size = UDim2.new(1, -20, 0, 7), Position = UDim2.new(0, 10, 0, 30), BackgroundColor3 = Configs_HUB.Cor_Stroke}) Corner(Bar)

    local fillPos = (Default - MinValue) / math.max(1, (MaxValue - MinValue))
    local Fill = Create("Frame", Bar, {Size = UDim2.new(fillPos, 0, 1, 0), BackgroundColor3 = Color3.fromRGB(28, 120, 212)}) Corner(Fill)

    local dragging = false
    local function update(posX)
        local pos = math.clamp((posX - Bar.AbsolutePosition.X) / Bar.AbsoluteSize.X, 0, 1)
        Fill.Size = UDim2.new(pos, 0, 1, 0)
        local val = math.floor(MinValue + (MaxValue - MinValue) * pos)
        ValueLabel.Text = tostring(val)
        Callback(val)
    end

    Bar.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            update(input.Position.X)
        end
    end)

    UIS.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = false
        end
    end)

    UIS.InputChanged:Connect(function(input)
        if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            update(input.Position.X)
        end
    end)

    Callback(Default)
end

--== DROPDOWN
local function AddDropdown(parent, Configs)
    local Options, Default, Callback = Configs.Options or {"1","2","3"}, Configs.Default or (Configs.Options and Configs.Options[1]) or "...", Configs.Callback or function() end
    local Holder = Create("Frame", parent, {Size = UDim2.new(1, -12, 0, 30), BackgroundColor3 = Configs_HUB.Cor_Options}) Corner(Holder) Stroke(Holder)

    Create("TextLabel", Holder, {Text = Configs.Name or "Dropdown!!", Size = UDim2.new(1, 0, 1, 0), Position = UDim2.new(0, 35, 0, 0), BackgroundTransparency = 1, Font = Configs_HUB.Text_Font, TextSize = 12, TextXAlignment = Enum.TextXAlignment.Left, TextColor3 = Configs_HUB.Cor_Text})
    local Current = Create("TextLabel", Holder, {BackgroundColor3 = Configs_HUB.Cor_Hub, BackgroundTransparency = 0.1, Position = UDim2.new(1, -10, 0.5, 0), AnchorPoint = Vector2.new(1, 0.5), Size = UDim2.new(0, 120, 0, 20), TextColor3 = Configs_HUB.Cor_DarkText, TextScaled = true, Font = Configs_HUB.Text_Font, Text = tostring(Default)}) Corner(Current) Stroke(Current)
    local OpenBtn = Create("TextButton", Holder, {Size = UDim2.new(1, 0, 1, 0), BackgroundTransparency = 1, Text = ""})

    local DropFrame = Create("ScrollingFrame", Holder, {Size = UDim2.new(1, 0, 0, 0), Position = UDim2.new(0, 0, 1, 0), AutomaticCanvasSize = Enum.AutomaticSize.Y, BackgroundTransparency = 1, ScrollBarThickness = 2, Visible = false, ClipsDescendants = true})
    Create("UIListLayout", DropFrame, {Padding = UDim.new(0, 5), SortOrder = Enum.SortOrder.LayoutOrder})

    local open = false
    local function ToggleList()
        open = not open
        DropFrame.Visible = true
        CreateTween(DropFrame, "Size", UDim2.new(1, 0, 0, open and math.min(#Options, 6) * 26 + 12 or 0), 0.18, false)
        if not open then task.delay(0.18, function() DropFrame.Visible = false end) end
    end
    OpenBtn.MouseButton1Click:Connect(ToggleList)

    for _,opt in ipairs(Options) do
        local OptBtn = Create("TextButton", DropFrame, {Size = UDim2.new(1, 0, 0, 24), BackgroundColor3 = Configs_HUB.Cor_Options, Text = tostring(opt), Font = Configs_HUB.Text_Font, TextSize = 12, TextColor3 = Configs_HUB.Cor_Text}) Corner(OptBtn) Stroke(OptBtn)
        OptBtn.MouseButton1Click:Connect(function() Current.Text = tostring(opt) Callback(opt) ToggleList() end)
    end
    Callback(Default)
end
