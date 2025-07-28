-- KhataHub V7.5 - Full Mobile Support + UI Tối Ưu -- Giao diện: Rainbow, Tab, Logo kéo được, Nút X/- tắt UI -- Full code dưới đây (tổng hợp từ bản V7 + nâng cấp)

local Library = {} local CoreGui = game:GetService("CoreGui") local TweenService = game:GetService("TweenService") local Players = game:GetService("Players") local UIS = game:GetService("UserInputService") local RS = game:GetService("RunService")

function Library:MakeWindow(opts) local ScreenGui = Instance.new("ScreenGui") ScreenGui.Name = opts.Title or "KhataHub" ScreenGui.ResetOnSpawn = false ScreenGui.IgnoreGuiInset = true ScreenGui.Parent = CoreGui

local ToggleBtn = Instance.new("ImageButton", ScreenGui)
ToggleBtn.Size = UDim2.new(0, 48, 0, 48)
ToggleBtn.Position = UDim2.new(0, 12, 1, -60)
ToggleBtn.Image = opts.Icon or "rbxassetid://114803447252543"
ToggleBtn.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
ToggleBtn.BorderSizePixel = 0
ToggleBtn.ZIndex = 999
Instance.new("UICorner", ToggleBtn).CornerRadius = UDim.new(0, 6)

local Main = Instance.new("Frame")
Main.Size = UDim2.new(0, 520, 0, 360)
Main.Position = UDim2.new(0.5, -260, 0.5, -180)
Main.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
Main.BorderSizePixel = 0
Main.Visible = true
Main.Parent = ScreenGui
Instance.new("UICorner", Main).CornerRadius = UDim.new(0, 12)

-- Rainbow effect
local hue = 0
RS.RenderStepped:Connect(function()
    hue = (hue + 1) % 360
    local color = Color3.fromHSV(hue / 360, 1, 1)
    Main.BackgroundColor3 = color
    if Main:FindFirstChild("TopBar") and Main.TopBar:FindFirstChild("Title") then
        Main.TopBar.Title.TextColor3 = color
    end
end)

local TopBar = Instance.new("Frame")
TopBar.Name = "TopBar"
TopBar.Size = UDim2.new(1, 0, 0, 40)
TopBar.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
TopBar.BorderSizePixel = 0
TopBar.Parent = Main

local Title = Instance.new("TextLabel", TopBar)
Title.Name = "Title"
Title.Text = opts.Title or "Khata Hub"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.Font = Enum.Font.GothamBold
Title.TextSize = 18
Title.BackgroundTransparency = 1
Title.Position = UDim2.new(0, 10, 0, 0)
Title.Size = UDim2.new(0.6, 0, 1, 0)
Title.TextXAlignment = Enum.TextXAlignment.Left

local MinBtn = Instance.new("TextButton", TopBar)
MinBtn.Text = "-"
MinBtn.Size = UDim2.new(0, 30, 0, 30)
MinBtn.Position = UDim2.new(1, -70, 0.5, -15)
MinBtn.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
MinBtn.TextColor3 = Color3.new(1, 1, 1)
MinBtn.Font = Enum.Font.GothamBold
MinBtn.TextSize = 18
Instance.new("UICorner", MinBtn)

local CloseBtn = Instance.new("TextButton", TopBar)
CloseBtn.Text = "X"
CloseBtn.Size = UDim2.new(0, 30, 0, 30)
CloseBtn.Position = UDim2.new(1, -35, 0.5, -15)
CloseBtn.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
CloseBtn.TextColor3 = Color3.new(1, 1, 1)
CloseBtn.Font = Enum.Font.GothamBold
CloseBtn.TextSize = 18
Instance.new("UICorner", CloseBtn)

MinBtn.MouseButton1Click:Connect(function()
    Main.Visible = false
end)
CloseBtn.MouseButton1Click:Connect(function()
    ScreenGui:Destroy()
end)
ToggleBtn.MouseButton1Click:Connect(function()
    Main.Visible = not Main.Visible
end)

-- Drag UI bằng TopBar hoặc Logo
local dragging, dragStart, startPos
local function beginDrag(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true
        dragStart = input.Position
        startPos = Main.Position
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then dragging = false end
        end)
    end
end
local function updateDrag(input)
    if dragging then
        local delta = input.Position - dragStart
        Main.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X,
                                   startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
end
TopBar.InputBegan:Connect(beginDrag)
ToggleBtn.InputBegan:Connect(beginDrag)
UIS.InputChanged:Connect(updateDrag)

-- Tab System
local TabButtons = Instance.new("Frame", Main)
TabButtons.Size = UDim2.new(1, 0, 0, 30)
TabButtons.Position = UDim2.new(0, 0, 0, 40)
TabButtons.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
local TabBtnLayout = Instance.new("UIListLayout", TabButtons)
TabBtnLayout.FillDirection = Enum.FillDirection.Horizontal
TabBtnLayout.Padding = UDim.new(0, 4)
TabBtnLayout.SortOrder = Enum.SortOrder.LayoutOrder

local TabHolder = Instance.new("Frame", Main)
TabHolder.Size = UDim2.new(1, -20, 1, -80)
TabHolder.Position = UDim2.new(0, 10, 0, 75)
TabHolder.BackgroundTransparency = 1

local Tabs = {}
local CurrentTab = nil
local Window = {}

function Window:MakeTab(info)
    local Tab = Instance.new("Frame", TabHolder)
    Tab.Size = UDim2.new(1, 0, 1, 0)
    Tab.BackgroundTransparency = 1
    Tab.Visible = false
    local List = Instance.new("UIListLayout", Tab)
    List.Padding = UDim.new(0, 6)

    local Btn = Instance.new("TextButton", TabButtons)
    Btn.Text = info.Title or "Tab"
    Btn.Size = UDim2.new(0, 100, 1, 0)
    Btn.TextColor3 = Color3.new(1, 1, 1)
    Btn.Font = Enum.Font.Gotham
    Btn.TextSize = 14
    Btn.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
    Instance.new("UICorner", Btn)

    Btn.MouseButton1Click:Connect(function()
        for _, t in pairs(Tabs) do t.Visible = false end
        Tab.Visible = true
        CurrentTab = Tab
    end)

    if not CurrentTab then
        Tab.Visible = true
        CurrentTab = Tab
    end

    local Public = {}

    function Public:AddButton(opt)
        local Btn = Instance.new("TextButton", Tab)
        Btn.Size = UDim2.new(1, 0, 0, 32)
        Btn.Text = opt.Title or "Button"
        Btn.TextColor3 = Color3.new(1, 1, 1)
        Btn.Font = Enum.Font.Gotham
        Btn.TextSize = 14
        Btn.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
        Instance.new("UICorner", Btn)
        Btn.MouseButton1Click:Connect(function()
            if opt.Callback then pcall(opt.Callback) end
        end)
    end

    function Public:AddToggle(opt)
        local Holder = Instance.new("Frame", Tab)
        Holder.Size = UDim2.new(1, 0, 0, 30)
        Holder.BackgroundTransparency = 1

        local Label = Instance.new("TextLabel", Holder)
        Label.Text = opt.Title or "Toggle"
        Label.Font = Enum.Font.Gotham
        Label.TextSize = 14
        Label.TextColor3 = Color3.new(1, 1, 1)
        Label.BackgroundTransparency = 1
        Label.Size = UDim2.new(0.6, 0, 1, 0)
        Label.TextXAlignment = Enum.TextXAlignment.Left

        local Back = Instance.new("Frame", Holder)
        Back.Size = UDim2.new(0, 50, 0, 20)
        Back.Position = UDim2.new(1, -60, 0.5, -10)
        Back.BackgroundColor3 = Color3.fromRGB(80, 80, 80)
        Instance.new("UICorner", Back).CornerRadius = UDim.new(0, 10)

        local Circle = Instance.new("Frame", Back)
        Circle.Size = UDim2.new(0, 18, 0, 18)
        Circle.Position = UDim2.new(0, 1, 0, 1)
        Circle.BackgroundColor3 = Color3.fromRGB(170, 0, 0)
        Instance.new("UICorner", Circle).CornerRadius = UDim.new(1, 0)

        local toggled = false
        Back.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 then
                toggled = not toggled
                TweenService:Create(Circle, TweenInfo.new(0.25), {
                    Position = toggled and UDim2.new(1, -19, 0, 1) or UDim2.new(0, 1, 0, 1),
                    BackgroundColor3 = toggled and Color3.fromRGB(0, 255, 0) or Color3.fromRGB(255, 0, 0)
                }):Play()
                if opt.Callback then pcall(opt.Callback, toggled) end
            end
        end)
    end

    table.insert(Tabs, Tab)
    return Public
end

return Window

end

return Library

