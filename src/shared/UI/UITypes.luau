
export type base_props = {
    Size: UDim2?,
    Position: UDim2?,
}

export type round_button_props = base_props & {
    Icon: string?,
    StrokeColor: Color3?,
    StrokeColor2: Color3?,
    CircleColor1: Color3?,
    GlowColor: Color3?,
    GradientColor1: ColorSequence?,
    BackgroundTransparency: number?,
    LayoutOrder: number?,
    Text: string?,
    TextColor: Color3?,
    TextStrokeColor: Color3?,
    OnClick: () -> (),
    Children: {Instance},
    TextSizeConstraint: {
        MaxTextSize: number,
        MinTextSize: number
    }?,
    TextGradient: ColorSequence?,
    ImageColor: Color3?
}

export type round_button_without_text_props = base_props & {
    Icon: string?,
    GradientStroke: ColorSequence?,
    CircleColor: Color3?,
    LayoutOrder: number?,
    BackgroundTransparency: number?,
    OnClick: () -> ()?,
    Children: {Instance}?,
}

export type screen_name = 'None' | 'CoreGui'

return {}