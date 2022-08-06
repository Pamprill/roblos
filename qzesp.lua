local PlayerList = getrenv()._G.PlayerList

local RunService = game:GetService('RunService')

local Camera = workspace.CurrentCamera
local Players = game:GetService('Players')
local LocalPlayer = Players.LocalPlayer
  
local function ESP(Player)
    local DRAWING_PLAYER_INFO = Drawing.new('Text')
    DRAWING_PLAYER_INFO.Font = 2
    DRAWING_PLAYER_INFO.Size = 13
    DRAWING_PLAYER_INFO.Color = Color3.fromRGB(255,255,255)
    DRAWING_PLAYER_INFO.Outline = true
    DRAWING_PLAYER_INFO.Center = true 
    
    local function onRender()
        local Connection
        Connection = RunService.RenderStepped:Connect(function()
            if Player:FindFirstChild('HumanoidStates') ~= nil and Player:FindFirstChild('HumanoidRootPart') ~= nil and Player:FindFirstChild('Humanoid') ~= nil and Player:FindFirstChild('Head') and Player.Humanoid.Health > 0  then
                local VectorPos, isOnScreen = Camera:WorldToViewportPoint(Player.HumanoidRootPart.Position)
                DRAWING_PLAYER_INFO.Visible = isOnScreen
                
                if isOnScreen then
                    if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild('HumanoidRootPart') then
                        local Magnitude = (LocalPlayer.Character.HumanoidRootPart.Position - Player.HumanoidRootPart.Position).Magnitude
                        DRAWING_PLAYER_INFO.Text = string.format('%s %s %sm', Player.Name, tostring(math.round(Player.Humanoid.Health))..'%', math.round(Magnitude))
                    else
                        DRAWING_PLAYER_INFO.Text = Player.Name
                    end
                    DRAWING_PLAYER_INFO.Position = Vector2.new(VectorPos.X, VectorPos.Y - 35)
                end

                if game.Players:FindFirstChild(Player.Name) == nil then
                    DRAWING_PLAYER_INFO:Remove()
                    Connection:Disconnect()
                end
            else
                DRAWING_PLAYER_INFO.Visible = false
            end
        end)
    end
    coroutine.wrap(onRender)()
end

for Index, Players in next, getrenv()._G.PlayerList do
    task.spawn(function()
        for Index, Player in next, Players do 
            if Player.Name ~= LocalPlayer.Name and Player:FindFirstChild('HumanoidStates') then 
                coroutine.wrap(ESP)(Player)
            end 
        end 
    end)
end

game.Players.PlayerAdded:Connect(function(AddingPlayer)
    task.spawn(function()
        for Index, Players in next, getrenv()._G.PlayerList do
            for Index, Player in next, Players do 
                if Player.Name == AddingPlayer.Name then
                    coroutine.wrap(ESP)(Player)
                end 
            end 
        end
    end)
end)
