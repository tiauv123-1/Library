--// KHATA UI LIBRARY - HỖ TRỢ NHIỀU TAB, TWEEN, DRAG local KhataUI = {} local TweenService = game:GetService("TweenService") local Players = game:GetService("Players") local LocalPlayer = Players.LocalPlayer local UserInputService = game:GetService("UserInputService")

local function CreateTween(Object, Property, Value, Time) local tween = TweenService:Create(Object, TweenInfo.new(Time, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), { [Property] = Value }) tween:Play() end

function KhataUI:CreateWindow(titleText) local ScreenGui = Instance.new("ScreenGui", LocalPlayer:WaitForChild("PlayerGui")) ScreenGui.Name = "KhataUI" ScreenGui.ResetOnSpawn = false

local Main = Instance.new("Frame", ScreenGui)
Main.Size = UDim2.new(0, 500, 0, 320)
Main.Position = UDim2.new(0.3, 0, 0.3, 0)
Main.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
Main.BorderSizePixel = 0
Instance.new("UICorner", Main).CornerRadius = UDim.new(0, 6)

-- Drag UI
local dragging, dragInput, dragStart, startPos
Main.Active = true
Main.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = true
        dragStart = input.Position
        startPos = Main.Position
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                dragging = false
            end
        end)
    end
end)
Main.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement then
        dragInput = input
    end
end)
UserInputService.InputChanged:Connect(function(input)
    if input == dragInput and dragging then
        local delta = input.Position - dragStart
        Main.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
end)

-- Title
local Title = Instance.new("TextLabel", Main)
Title.Size = UDim2.new(1, 0, 0, 30)
Title.BackgroundTransparency = 1
Title.TextColor3 = Color3.new(1, 1, 1)
Title.Font = Enum.Font.GothamBold
Title.TextSize = 18
Title.Text = titleText or "KHATA HUB"
Title.Name = "Title"

-- Tab Buttons (left)
local TabButtons = Instance.new("Frame", Main)
TabButtons.Size = UDim2.new(0, 100, 1, 0)
TabButtons.BackgroundTransparency = 1

local TabList = Instance.new("UIListLayout", TabButtons)
TabList.Padding = UDim.new(0, 5)
TabList.SortOrder = Enum.SortOrder.LayoutOrder

-- Content Area (right)
local ContentHolder = Instance.new("Frame", Main)
ContentHolder.Size = UDim2.new(1, -110, 1, -10)
ContentHolder.Position = UDim2.new(0, 110, 0, 5)
ContentHolder.BackgroundTransparency = 1

local Tabs = {}
local CurrentTab = nil

local function SwitchTab(tabName)
    for name, frame in pairs(Tabs) do
        frame.Visible = (name == tabName)
    end
    CurrentTab = tabName
end

local function CreateTab(name)
    -- Tab Button
    local Button = Instance.new("TextButton", TabButtons)
    Button.Size = UDim2.new(1, -10, 0, 30)
    Button.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    Button.Text = name
    Button.TextColor3 = Color3.new(1,1,1)
    Button.Font = Enum.Font.Gotham
    Button.TextSize = 14
    Instance.new("UICorner", Button).CornerRadius = UDim.new(0, 6)

    -- Tab Content
    local TabFrame = Instance.new("Frame", ContentHolder)
    TabFrame.Size = UDim2.new(1, 0, 1, 0)
    TabFrame.BackgroundTransparency = 1
    TabFrame.Visible = false

    local Layout = Instance.new("UIListLayout", TabFrame)
    Layout.Padding = UDim.new(0, 6)
    Layout.SortOrder = Enum.SortOrder.LayoutOrder

    Tabs[name] = TabFrame

    Button.MouseButton1Click:Connect(function()
        SwitchTab(name)
    end)

    if not CurrentTab then
        SwitchTab(name)
    end

    local TabAPI = {}

    function TabAPI:AddButton(text, callback)
        local Button = Instance.new("TextButton", TabFrame)
        Button.Size = UDim2.new(0, 360, 0, 40)
        Button.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        Button.Text = text
        Button.Font = Enum.Font.Gotham
        Button.TextColor3 = Color3.new(0, 0, 0)
        Button.BorderSizePixel = 0
        Instance.new("UICorner", Button).CornerRadius = UDim.new(0.2, 0)
        Button.MouseButton1Click:Connect(callback)
    end

    function TabAPI:AddToggle(text, callback)
        local OnOff = false
        local Frame = Instance.new("Frame", TabFrame)
        Frame.Size = UDim2.new(0, 360, 0, 30)
        Frame.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        local Stroke = Instance.new("UIStroke", Frame)
        Stroke.Color = Color3.fromRGB(200, 200, 200)
        Instance.new("UICorner", Frame).CornerRadius = UDim.new(1, 0)

        local Dot = Instance.new("Frame", Frame)
        Dot.Size = UDim2.new(0, 20, 0, 20)
        Dot.Position = UDim2.new(0, 2, 0.5, -10)
        Dot.BackgroundColor3 = Color3.fromRGB(100, 100, 100)
        Instance.new("UICorner", Dot).CornerRadius = UDim.new(1, 0)

        local Label = Instance.new("TextLabel", Frame)
        Label.Position = UDim2.new(0, 30, 0, 0)
        Label.Size = UDim2.new(1, -30, 1, 0)
        Label.Text = text
        Label.Font = Enum.Font.Gotham
        Label.TextColor3 = Color3.fromRGB(50, 50, 50)
        Label.TextXAlignment = Enum.TextXAlignment.Left
        Label.BackgroundTransparency = 1
        Label.TextSize = 14

        Frame.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 then
                OnOff = not OnOff
                if OnOff then
                    CreateTween(Dot, "Position", UDim2.new(0, 10, 0.5, -10), 0.2)
                    CreateTween(Dot, "BackgroundColor3", Color3.fromRGB(28, 120, 212), 0.2)
                    CreateTween(Stroke, "Color", Color3.fromRGB(28, 120, 212), 0.2)
                    CreateTween(Label, "TextColor3", Color3.fromRGB(28, 120, 212), 0.2)
                    callback(true)
                else
                    CreateTween(Dot, "Position", UDim2.new(0, 2, 0.5, -10), 0.2)
                    CreateTween(Dot, "BackgroundColor3", Color3.fromRGB(100, 100, 100), 0.2)
                    CreateTween(Stroke, "Color", Color3.fromRGB(200, 200, 200), 0.2)
                    CreateTween(Label, "TextColor3", Color3.fromRGB(50, 50, 50), 0.2)
                    callback(false)
                end
            end
        end)
    end

    return TabAPI
end

return {
    CreateTab = CreateTab,
    SetTitle = function(text)
        Title.Text = text
    end
}

end

return KhataUI
