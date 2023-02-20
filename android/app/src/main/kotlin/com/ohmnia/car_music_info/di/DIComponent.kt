package com.ohmnia.car_music_info.di

import com.ohmnia.car_music_info.MainActivity
import dagger.Component
import javax.inject.Singleton

@Singleton
@Component
interface DIComponent {
    fun inject(activity: MainActivity)
}
