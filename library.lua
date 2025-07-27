-- KhataHub V4 - UI bảy màu nhấp nháy + toggle thông minh + kéo chạm ✨ -- Tác giả: Khata

local Library = {} local CoreGui = game:GetService("CoreGui") local TweenService = game:GetService("TweenService") local Players = game:GetService("Players") local UIS = game:GetService("UserInputService") local RS = game:GetService("RunService")

function Library:MakeWindow(opts) local ScreenGui = Instance.new("ScreenGui") ScreenGui.Name = opts.Title or "KhataHub" ScreenGui.ResetOnSpawn = false ScreenGui.IgnoreGuiInset = true ScreenGui.Parent = CoreGui

local ToggleBtn = Instance.new("ImageButton", ScreenGui)
ToggleBtn.Size = UDim2.new(0, 36, 0, 36)
ToggleBtn.Position = UDim2.new(0, 12, 0, 12)
ToggleBtn.Image = opts.Icon or "rbxassetid://0"
ToggleBtn.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
ToggleBtn.BorderSizePixel = 0
Instance.new("UICorner", ToggleBtn).CornerRadius = UDim.new(0, 6)

local Main = Instance.new("Frame")
Main.Size = UDim2.new(0, 520, 0, 360)
Main.Position = UDim2.new(0.5, -260, 0.5, -180)
Main.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
Main.BorderSizePixel = 0
Main.Visible = true
Main.Parent = ScreenGui

Instance.new("UICorner", Main).CornerRadius = UDim.new(0, 10)

-- Rainbow background effect
local hue = 0
RS.RenderStepped:Connect(function()
    hue = (hue + 1) % 360
    Main.BackgroundColor3 = Color3.fromHSV(hue / 360, 0.5, 0.5)
end)

local TopBar = Instance.new("Frame", Main)
TopBar.Size = UDim2.new(1, 0, 0, 40)
TopBar.BackgroundColor3 = Color3.fromRGB(60, 0, 0)
TopBar.BorderSizePixel = 0

local Title = Instance.new("TextLabel", TopBar)
Title.Text = opts.Title or "Khata Hub"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.Font = Enum.Font.GothamBold
Title.TextSize = 18
Title.BackgroundTransparency = 1
Title.Position = UDim2.new(0, 10, 0, 0)
Title.Size = UDim2.new(1, -20, 1, 0)
Title.TextXAlignment = Enum.TextXAlignment.Left

local dragging, dragStart, startPos
local function beginDrag(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.Touch then
        dragging = true
        dragStart = input.Position
        startPos = Main.Position
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
UIS.InputChanged:Connect(updateDrag)
UIS.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.Touch then
        dragging = false
    end
end)

ToggleBtn.MouseButton1Click:Connect(function()
    Main.Visible = not Main.Visible
end)

local Window = {}

function Window:MakeTab(tabInfo)
    local Tab = Instance.new("Frame", Main)
    Tab.Size = UDim2.new(1, -20, 1, -50)
    Tab.Position = UDim2.new(0, 10, 0, 45)
    Tab.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    Tab.Name = tabInfo.Title or "Tab"

    local List = Instance.new("UIListLayout", Tab)
    List.Padding = UDim.new(0, 6)
    List.SortOrder = Enum.SortOrder.LayoutOrder

    local PublicTab = {}

    function PublicTab:AddButton(info)
        local Btn = Instance.new("TextButton", Tab)
        Btn.Size = UDim2.new(1, 0, 0, 32)
        Btn.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
        Btn.Text = info.Title or "Button"
        Btn.TextColor3 = Color3.new(1, 1, 1)
        Btn.Font = Enum.Font.Gotham
        Btn.TextSize = 14
        Instance.new("UICorner", Btn).CornerRadius = UDim.new(0, 6)
        Btn.MouseButton1Click:Connect(function()
            if info.Callback then pcall(info.Callback) end
        end)
    end

    function PublicTab:AddToggle(opts)
        local Holder = Instance.new("Frame", Tab)
        Holder.Size = UDim2.new(1, 0, 0, 30)
        Holder.BackgroundTransparency = 1

        local Title = Instance.new("TextLabel", Holder)
        Title.Text = opts.Title or "Toggle"
        Title.Font = Enum.Font.Gotham
        Title.TextSize = 14
        Title.TextColor3 = Color3.new(1, 1, 1)
        Title.BackgroundTransparency = 1
        Title.Size = UDim2.new(0.6, 0, 1, 0)
        Title.TextXAlignment = Enum.TextXAlignment.Left

        local Back = Instance.new("Frame", Holder)
        Back.Size = UDim2.new(0, 50, 0, 20)
        Back.Position = UDim2.new(1, -60, 0.5, -10)
        Back.BackgroundColor3 = Color3.fromRGB(80, 80, 80)
        Back.BorderSizePixel = 0
        Instance.new("UICorner", Back).CornerRadius = UDim.new(0, 10)

        local Circle = Instance.new("Frame", Back)
        Circle.Size = UDim2.new(0, 18, 0, 18)
        Circle.Position = UDim2.new(0, 1, 0, 1)
        Circle.BackgroundColor3 = Color3.fromRGB(170, 0, 0)
        Instance.new("UICorner", Circle).CornerRadius = UDim.new(1, 0)

        local toggled = false
        local toggleLoop = nil

        Back.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 then
                toggled = not toggled
                TweenService:Create(Circle, TweenInfo.new(0.2), {
                    Position = toggled and UDim2.new(1, -19, 0, 1) or UDim2.new(0, 1, 0, 1),
                    BackgroundColor3 = toggled and Color3.fromRGB(0, 170, 0) or Color3.fromRGB(170, 0, 0)
                }):Play()

                if toggleLoop then toggleLoop:Disconnect() end
                if toggled then
                    toggleLoop = RS.RenderStepped:Connect(function()
                        if opts.Callback then pcall(opts.Callback, true) end
                    end)
                else
                    if opts.Callback then pcall(opts.Callback, false) end
                end
            end
        end)
    end

    return PublicTab
end

return Window

end

return Library

