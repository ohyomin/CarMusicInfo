package com.ohmnia.car_music_info

import android.content.Intent
import android.provider.Settings
import androidx.core.app.NotificationManagerCompat
import com.ohmnia.car_music_info.core.Constants
import com.ohmnia.car_music_info.core.MusicInfoManager
import com.ohmnia.car_music_info.methodchannel.MusicInfoStreamChannel
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import timber.log.Timber

class MainActivity: FlutterActivity() {

    private val musicInfoStreamChannel = MusicInfoStreamChannel()

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        getPermission()

        MusicInfoManager.registerMediaSessionListener(this)
        musicInfoStreamChannel.init(flutterEngine)

        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, Constants.COMMAND_CHANNEL)
            .setMethodCallHandler { call, result ->
                Timber.d("Command ${call.method}")
                when (call.method) {
                    "play" -> MusicInfoManager.play()
                    "pause" -> MusicInfoManager.pause()
                    "rewind" -> MusicInfoManager.rewind()
                    "fastForward" -> MusicInfoManager.fastForward()
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
