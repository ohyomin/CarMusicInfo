package com.ohmnia.car_music_info

import android.util.Log
import io.flutter.app.FlutterApplication
import timber.log.Timber

class CarMusicInfoApplication : FlutterApplication() {

    override fun onCreate() {
        super.onCreate()

        if (BuildConfig.DEBUG) {
            Timber.plant(Timber.DebugTree())
        } else {
            Timber.plant(MyLogTree())
        }
    }
}

class MyLogTree: Timber.DebugTree() {
    override fun log(priority: Int, tag: String?, message: String, t: Throwable?) {
        if (priority >= Log.ERROR) {
            super.log(priority, tag, message, t)
        }
    }
}
