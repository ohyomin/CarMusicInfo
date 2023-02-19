package com.ohmnia.car_music_info

import android.content.Intent
import android.provider.Settings
import androidx.core.app.NotificationManagerCompat
import com.ohmnia.car_music_info.core.MusicInfoManager
import com.ohmnia.car_music_info.methodchannel.MusicInfoStreamChannel
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine

class MainActivity: FlutterActivity() {

    private val musicInfoStreamChannel = MusicInfoStreamChannel()

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        getPermission()

        MusicInfoManager.registerMediaSessionListener(this)
        musicInfoStreamChannel.init(flutterEngine)
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
