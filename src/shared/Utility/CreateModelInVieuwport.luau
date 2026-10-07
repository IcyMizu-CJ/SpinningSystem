local ReplicatedStorage = game:GetService("ReplicatedStorage")
return function(Inst: ViewportFrame,ModelName: string)
    Inst:ClearAllChildren()
    local Camera = Instance.new('Camera'):: Camera
    Camera.CFrame = CFrame.new(Vector3.new(0,3,-6),Vector3.new(0,3,0))
    Camera.Parent = Inst

    Inst.CurrentCamera = Camera

    local Model:Model = ReplicatedStorage.Assets:FindFirstChild(ModelName,true):Clone()
    Model:PivotTo(CFrame.new(0,0,0))
    Model.Parent = Inst
end