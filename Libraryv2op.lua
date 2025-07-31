--// REDz Hub UI Library (Full GUI Framework)

local TweenService = game:GetService("TweenService") local ScreenGui = Instance.new("ScreenGui", game:GetService("CoreGui"))

-- Helper: Create Instances function Create(class, parent, props) local inst = Instance.new(class) for i, v in pairs(props) do inst[i] = v end inst.Parent = parent return inst end

function Corner(inst) local c = Instance.new("UICorner") c.CornerRadius = UDim.new(0, 4) c.Parent = inst end

function Stroke(inst, props) local s = Instance.new("UIStroke") for i, v in pairs(props or {}) do s[i] = v end s.Parent = inst end

function CreateTween(instance, prop, value, time, tweenWait) local tween = TweenService:Create(instance, TweenInfo.new(time, Enum.EasingStyle.Linear), {[prop] = value}) tween:Play() if tweenWait then tween.Completed:Wait() end end

function TextSetColor(textLabel) if not textLabel then return end spawn(function() while task.wait(0.1) do if textLabel.Parent == nil then break end textLabel.TextColor3 = Color3.fromHSV(tick() % 5 / 5, 1, 1) end end) end

function AddButton(parent, Configs) local Callback = Configs.Callback or function() end local ButtonText = Configs.Text or "Button" local ButtonName = Configs.Name or "Button"

local Button = Create("TextButton", parent, { Name = ButtonName, Size = UDim2.new(1, 0, 0, 30), BackgroundColor3 = Color3.fromRGB(40, 40, 40), Font = Enum.Font.Gotham, Text = ButtonText, TextColor3 = Color3.fromRGB(255, 255, 255), TextSize = 14 })

Corner(Button) Stroke(Button)

Button.MouseButton1Click:Connect(function() Callback() end)

return Button end

function AddButtonWithIcon(parent, Configs) local Callback = Configs.Callback or function() end local Configs_HUB = Configs.Configs_HUB or { Cor_Stroke = Color3.fromRGB(255, 255, 255) }

local TextButton = Create("TextButton", parent, { Size = UDim2.new(1, 0, 0, 30), BackgroundColor3 = Color3.fromRGB(40, 40, 40), Font = Enum.Font.GothamBold, Text = Configs.Text or "Button", TextColor3 = Color3.fromRGB(255, 255, 255), TextSize = 14 }) Corner(TextButton) Stroke(TextButton)

local TextLabel = Create("TextLabel", TextButton, { Text = Configs.Text or "Button", Size = UDim2.new(1, -30, 1, 0), Position = UDim2.new(0, 30, 0, 0), BackgroundTransparency = 1, TextColor3 = Color3.fromRGB(255, 255, 255), Font = Enum.Font.Gotham, TextSize = 14, TextXAlignment = Enum.TextXAlignment.Left })

local ImageLabel = Create("ImageLabel", TextButton, { Image = "rbxassetid://15155219405", Size = UDim2.new(0, 20, 0, 20), Position = UDim2.new(0, 5, 0, 2.5), BackgroundTransparency = 1, ImageColor3 = Configs_HUB.Cor_Stroke })

TextButton.MouseButton1Click:Connect(function() Callback("Click!!") CreateTween(ImageLabel, "ImageColor3", Color3.fromRGB(28, 120, 212), 0.2, true) CreateTween(ImageLabel, "ImageColor3", Configs_HUB.Cor_Stroke, 0.2, false) end)

TextSetColor(TextLabel) end

function AddToggle(parent, Configs) local toggled = false local Title = Configs.Name or "Toggle" local Callback = Configs.Callback or function() end

local Button = Create("TextButton", parent, { Size = UDim2.new(1, 0, 0, 30), BackgroundColor3 = Color3.fromRGB(25, 25, 25), Text = Title, TextColor3 = Color3.fromRGB(255, 255, 255), Font = Enum.Font.Gotham, TextSize = 14 }) Corner(Button) Stroke(Button)

Button.MouseButton1Click:Connect(function() toggled = not toggled Callback(toggled) Button.BackgroundColor3 = toggled and Color3.fromRGB(181, 1, 31) or Color3.fromRGB(25, 25, 25) end) end

function AddSlider(parent, Configs) local SliderName = Configs.Name or "Slider!!" local Increase = Configs.Increase or 1 local MinValue = (Configs.MinValue or 10) / Increase local MaxValue = (Configs.MaxValue or 100) / Increase local Default = Configs.Default or 25 local Callback = Configs.Callback or function() end

local Frame = Create("TextButton", parent, { Size = UDim2.new(1, 0, 0, 25), BackgroundColor3 = Color3.fromRGB(30, 30, 30), Name = "Frame", Text = SliderName }) Corner(Frame) Stroke(Frame) end

function AddDropdown(parent, Configs) local DropdownName = Configs.Name or "Dropdown!!" local Default = Configs.Default or "Option" local Options = Configs.Options or {"1", "2", "3"} local Callback = Configs.Callback or function() end

local Frame = Create("TextButton", parent, { Size = UDim2.new(1, 0, 0, 30), BackgroundColor3 = Color3.fromRGB(35, 35, 35), Text = Default, Font = Enum.Font.Gotham, TextColor3 = Color3.fromRGB(255,255,255), TextSize = 14 }) Corner(Frame) Stroke(Frame)

Frame.MouseButton1Click:Connect(function() Callback(Default) end) end

function MakeWindow(Configs) local title = Configs.Hub.Title or "REDz HUB" local KeySystem = Configs.Key.KeySystem or false local KeyKey = Configs.Key.Keys or {"123"} local KeyVerify = false

if KeySystem then local KeyMenu = Create("Frame", ScreenGui, { Size = UDim2.new(0, 400, 0, 200), Position = UDim2.new(0.5, 0, 0.5, 0), AnchorPoint = Vector2.new(0.5, 0.5), BackgroundColor3 = Color3.fromRGB(20, 20, 20), Active = true, Draggable = true }) Corner(KeyMenu)

local TextBox = Create("TextBox", KeyMenu, {
  Size = UDim2.new(1, -40, 0, 40),
  Position = UDim2.new(0, 20, 0, 60),
  PlaceholderText = "Enter Key",
  Font = Enum.Font.Gotham,
  TextSize = 20,
  BackgroundColor3 = Color3.fromRGB(35, 35, 35),
  TextColor3 = Color3.fromRGB(255, 255, 255)
}) Corner(TextBox)

local Confirm = Create("TextButton", KeyMenu, {
  Size = UDim2.new(0.5, -25, 0, 40),
  Position = UDim2.new(0, 20, 0, 120),
  Text = "Confirm",
  Font = Enum.Font.GothamBold,
  TextColor3 = Color3.fromRGB(255, 255, 255),
  BackgroundColor3 = Color3.fromRGB(40, 40, 40)
}) Corner(Confirm)

Confirm.MouseButton1Click:Connect(function()
  for _, v in ipairs(KeyKey) do
    if TextBox.Text == v then
      KeyVerify = true
    end
  end
end)

repeat task.wait() until KeyVerify
KeyMenu:Destroy()

end

local Menu = Create("Frame", ScreenGui, { Size = UDim2.new(0, 500, 0, 270), Position = UDim2.new(0.5, -250, 0.5, -135), BackgroundColor3 = Color3.fromRGB(20, 20, 20), Active = true, Draggable = true }) Corner(Menu)

return Menu end


