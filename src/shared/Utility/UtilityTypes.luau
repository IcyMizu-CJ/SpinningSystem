export type UseAnimatedValue<T> = {
    when: () -> boolean,
    on: T,
    off: T,
    speed: number?,
    damping: number?,
}

export type UseAnimated3Value<T> = {
    when: () -> boolean,
    on: T,
    mid: T,
    off: T,
    speed: number?,
    damping: number?,
}

return {}