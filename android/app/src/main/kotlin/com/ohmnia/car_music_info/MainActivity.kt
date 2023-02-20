package com.ohmnia.car_music_info

import android.content.Intent
import android.os.Bundle
import android.os.PersistableBundle
import android.provider.Settings
import androidx.core.app.NotificationManagerCompat
import com.ohmnia.car_music_info.core.Constants
import com.ohmnia.car_music_info.core.MusicInfoManager
import com.ohmnia.car_music_info.di.DaggerDIComponent
import com.ohmnia.car_music_info.methodchannel.MusicInfoStreamChannel
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import timber.log.Timber
import javax.inject.Inject

class MainActivity: FlutterActivity() {

    @Inject
    lateinit var musicInfoStreamChannel: MusicInfoStreamChannel

    @Inject
    lateinit var musicInfoManager: MusicInfoManager

    private var isInit: Boolean = false

    private fun init() {
        synchronized(this) {
            if (isInit) return

            DaggerDIComponent.create().inject(this)
            isInit = true
        }
    }

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        init()

        musicInfoStreamChannel.init(flutterEngine)

        //musicInfoManager.registerMediaSessionListener(this)

        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, Constants.COMMAND_CHANNEL)
            .setMethodCallHandler { call, result ->
                Timber.d("Command ${call.method}")
                when (call.method) {
                    "play" -> musicInfoManager.play()
                    "pause" -> musicInfoManager.pause()
                    "rewind" -> musicInfoManager.rewind()
                    "fastForward" -> musicInfoManager.fastForward()
                    "registerListener" -> musicInfoManager.registerMediaSessionListener(this)
                    "getPermission" -> getPermission()
                    "isPermissionGranted" -> {
                        result.success(isPermissionGranted())
                        return@setMethodCallHandler
                    }
                }
                result.success(null)
            }
    }


    private fun getPermission() {
        if (isPermissionGranted()) return

        Intent(Settings.ACTION_NOTIFICATION_LISTENER_SETTINGS).run {
            startActivity(this)
        }
    }

    private fun isPermissionGranted() =
        NotificationManagerCompat.getEnabledListenerPackages(this).contains(packageName)
}

