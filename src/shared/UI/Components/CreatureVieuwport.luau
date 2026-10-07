local ReplicatedStorage = game:GetService("ReplicatedStorage")
local vide = require(ReplicatedStorage.Packages.vide)
local create = vide.create 


return function(props)
    local Camera = Instance.new('Camera'):: Camera
    Camera.CFrame = CFrame.new(Vector3.new(0,3,-6),Vector3.new(0,3,0))

    local Model:Model = props.model and props.model:Clone() or ReplicatedStorage.Assets:FindFirstChild('First_Creature'):Clone()
    Model:PivotTo(CFrame.new(0,0,0))
    return create 'ViewportFrame' {
        Size = UDim2.fromScale(1, 1),
        AnchorPoint = Vector2.new(0.5,0.5),
        Position = UDim2.fromScale(.5, .5),
        BackgroundTransparency = 1,
        CurrentCamera = Camera,
        Camera,
        Model,
        Parent = props.parent,
        Visible = props.visible,
    }

end