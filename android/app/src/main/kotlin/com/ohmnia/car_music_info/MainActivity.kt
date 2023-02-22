package com.ohmnia.car_music_info

import android.app.Activity
import android.content.Intent
import android.graphics.Color
import android.os.Bundle
import android.os.PersistableBundle
import android.provider.Settings
import android.view.View
import android.view.WindowManager
import androidx.core.app.NotificationManagerCompat
import com.ohmnia.car_music_info.core.Constants
import com.ohmnia.car_music_info.core.MusicInfoManager
import com.ohmnia.car_music_info.di.DaggerDIComponent
import com.ohmnia.car_music_info.methodchannel.MusicInfoStreamChannel
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.Result
import timber.log.Timber
import javax.inject.Inject

class MainActivity: FlutterActivity() {

    private val pendingResult = mutableMapOf<Int, Result>()
    private var requestCodeBase = 1000;

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

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)

        setTransparentStatusBar()
    }

    private fun setTransparentStatusBar() {
        window.decorView.systemUiVisibility =
            View.SYSTEM_UI_FLAG_LAYOUT_STABLE or
                    View.SYSTEM_UI_FLAG_LAYOUT_FULLSCREEN

        val winAttr = window.attributes
        winAttr.flags = winAttr.flags and
                WindowManager.LayoutParams.FLAG_TRANSLUCENT_STATUS.inv()
        window.attributes = winAttr
        window.statusBarColor = Color.TRANSPARENT
    }

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        init()

        musicInfoStreamChannel.init(flutterEngine)

        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, Constants.COMMAND_CHANNEL)
            .setMethodCallHandler { call, result ->
                Timber.d("Command ${call.method}")
                when (call.method) {
                    "play" -> musicInfoManager.play()
                    "pause" -> musicInfoManager.pause()
                    "rewind" -> musicInfoManager.rewind()
                    "fastForward" -> musicInfoManager.fastForward()
                    "registerListener" -> musicInfoManager.registerMediaSessionListener(this)
                    "isPermissionGranted" -> {
                        result.success(isPermissionGranted())
                        return@setMethodCallHandler
                    }
                    "requestPermission" -> {
                        getPermission(result)
                        return@setMethodCallHandler
                    }
                }
                result.success(null)
            }
    }


    private fun getPermission(result: Result) {
        if (isPermissionGranted()) {
            result.success(true)
            return
        }

        val requestCode = requestCodeBase++;
        pendingResult[requestCode] = result
        startActivityForResult(
            Intent(Settings.ACTION_NOTIFICATION_LISTENER_SETTINGS), requestCode)
    }

    override fun onActivityResult(requestCode: Int, resultCode: Int, data: Intent?) {
        super.onActivityResult(requestCode, resultCode, data)

        Timber.d("Permission result: $requestCode, $resultCode, $pendingResult")
        pendingResult.remove(requestCode)?.success(isPermissionGranted())
    }

    private fun isPermissionGranted() =
        NotificationManagerCompat.getEnabledListenerPackages(this).contains(packageName)
}

