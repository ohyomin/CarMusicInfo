package com.ohmnia.car_music_info.intent

interface Intent<T> {
    fun reduce(oldState: T): T
}

fun <T> intent(block: T.() -> T) = object: Intent<T> {
    override fun reduce(oldState: T) = block(oldState)
}
