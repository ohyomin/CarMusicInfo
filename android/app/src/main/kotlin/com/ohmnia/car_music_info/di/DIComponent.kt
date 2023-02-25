package com.ohmnia.car_music_info.di

import android.content.Context
import com.ohmnia.car_music_info.MainActivity
import com.ohmnia.car_music_info.core.MusicStarter
import dagger.BindsInstance
import dagger.Component
import dagger.Module
import dagger.Provides
import javax.inject.Singleton

@Singleton
@Component(modules = [AppModule::class])
interface DIComponent {
    fun inject(activity: MainActivity)

    @Component.Builder
    interface Builder {
        @BindsInstance
        fun context(context: Context): Builder
        fun build(): DIComponent
    }
}

@Module
class AppModule {
    @Provides
    fun provideMusicStarter(context: Context) = MusicStarter(context)
}
