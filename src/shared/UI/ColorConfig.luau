local Colors = {}

Colors.MainColor = Color3.fromHex("#1f202b")
Colors.MainAccentColor = Color3.fromRGB(176, 123, 255)
Colors.BlueAccentColor = Color3.fromRGB(122, 199, 243)
Colors.BluePurplish = Color3.fromRGB(98, 49, 233)
Colors.DarkBlue = Color3.fromRGB(24, 106, 153)
Colors.White = Color3.new(1, 1, 1)
Colors.OrangeLight = Color3.new(1, 0.678431, 0.309804)
Colors.OrangeDarker = Color3.new(0.968627, 0.52549, 0.019608)

Colors.LightToDarkPurpleGradient = ColorSequence.new(
    Colors.MainAccentColor,
    Colors.BluePurplish
)

Colors.LightToDarkOrangeGradient = ColorSequence.new(

    {ColorSequenceKeypoint.new(0.00, Colors.OrangeLight), 
    ColorSequenceKeypoint.new(0.4, Colors.OrangeLight), 
    ColorSequenceKeypoint.new(0.65, Colors.OrangeDarker), 
    ColorSequenceKeypoint.new(1.00, Colors.OrangeDarker)}

)

Colors.LightToDarkBlueGradient = ColorSequence.new(

    {ColorSequenceKeypoint.new(0.00, Colors.BlueAccentColor), 
    ColorSequenceKeypoint.new(0.4, Colors.BlueAccentColor), 
    ColorSequenceKeypoint.new(0.65, Colors.DarkBlue), 
    ColorSequenceKeypoint.new(1.00, Colors.DarkBlue)}

)

Colors.RollTextGradient = ColorSequence.new(
               {ColorSequenceKeypoint.new(0.00, Color3.new(1, 1, 1)), 
                ColorSequenceKeypoint.new(0.5, Color3.new(1, 1, 1)), 
                ColorSequenceKeypoint.new(0.65, Colors.MainAccentColor), 
                ColorSequenceKeypoint.new(1.00, Colors.MainAccentColor)}
            )

return Colors