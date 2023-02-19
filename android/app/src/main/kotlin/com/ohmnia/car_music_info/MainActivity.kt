package com.ohmnia.car_music_info

import android.content.Intent
import android.provider.Settings
import androidx.core.app.NotificationManagerCompat
import com.ohmnia.car_music_info.core.MusicInfoManager
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.reactivex.disposables.Disposable
import timber.log.Timber
import java.nio.ByteBuffer

class MainActivity: FlutterActivity() {

    private var disposable: Disposable? = null

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        getPermission()

        MusicInfoManager.registerMediaSessionListener(this)

        disposable = MusicInfoManager.subscribe{
            Timber.d("New meta : $it")
//            it.albumArt?.let { art ->
//                val buffer = ByteBuffer.allocate(art.byteCount)
//                art.copyPixelsFromBuffer(buffer)
//                Timber.d("New meta : $it")
//            }
        }
    }

    override fun onDestroy() {
        super.onDestroy()
        disposable?.dispose()
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
