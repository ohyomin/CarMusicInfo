package com.ohmnia.car_music_info.core

import android.annotation.SuppressLint
import android.content.ComponentName
import android.content.Context
import android.content.Intent
import android.media.AudioManager
import android.media.browse.MediaBrowser
import android.media.session.MediaController
import android.os.Bundle
import android.os.SystemClock
import android.view.KeyEvent
import android.widget.Toast
import com.ohmnia.car_music_info.util.MusicInfoStorage
import timber.log.Timber
import javax.inject.Inject
import javax.inject.Singleton
import kotlin.concurrent.thread

@Singleton
class MusicStarter @Inject constructor(val context: Context) {
    private var mediaBrowser: MediaBrowser? = null

    private fun getComponent() = MusicInfoStorage.getPrevComponent()

    fun play(componentName: ComponentName? = getComponent()) {
        Timber.d("music starter")
        if (componentName == null) return

        mediaBrowser?.disconnect()
        mediaBrowser = MediaBrowser(
            context,
            componentName,
            object : MediaBrowser.ConnectionCallback() {
                override fun onConnected() {
                    super.onConnected()
                    Timber.i("onConnected ${componentName.packageName}")
                    val controller = MediaController(context, mediaBrowser!!.sessionToken)
                    controller.transportControls.play()

                    simulateMediaButton(componentName.packageName)

                    Toast.makeText(context, "음악 시작", Toast.LENGTH_SHORT).show()
                }

                override fun onConnectionFailed() {
                    super.onConnectionFailed()
                    Timber.i("onConnectionFailed ${componentName.packageName}")
                    simulateMediaButton(componentName.packageName)

                    thread {
                        Thread.sleep(1000)
                        sendMediaKeyEvent()
                    }
                    Toast.makeText(context, "음악 시작", Toast.LENGTH_SHORT).show()
                }
            },
            Bundle()
        ).also { it.connect() }
    }

    fun dispose() {
        mediaBrowser?.disconnect()
    }

    fun simulateMediaButton(packageName: String) {
        val eventTime = SystemClock.uptimeMillis() - 1

        val keyEventDown =
            KeyEvent(eventTime, eventTime, KeyEvent.ACTION_DOWN, KeyEvent.KEYCODE_MEDIA_PLAY, 0)
        val keyEventUp =
            KeyEvent(eventTime, eventTime, KeyEvent.ACTION_UP, KeyEvent.KEYCODE_MEDIA_PLAY, 0)

        val intent = Intent(Intent.ACTION_MEDIA_BUTTON).apply {
            addFlags(Intent.FLAG_RECEIVER_FOREGROUND)
            setPackage(packageName)
        }

        context.sendBroadcast(intent.apply { putExtra(Intent.EXTRA_KEY_EVENT, keyEventDown) })
        context.sendBroadcast(intent.apply { putExtra(Intent.EXTRA_KEY_EVENT, keyEventUp) })
    }

    fun sendMediaKeyEvent() {
        val eventTime = SystemClock.uptimeMillis() - 1

        val keyEventDown =
            KeyEvent(eventTime, eventTime, KeyEvent.ACTION_DOWN, KeyEvent.KEYCODE_MEDIA_PLAY, 0)
        val keyEventUp =
            KeyEvent(eventTime, eventTime, KeyEvent.ACTION_UP, KeyEvent.KEYCODE_MEDIA_PLAY, 0)

        val audioManager = context.getSystemService(Context.AUDIO_SERVICE) as AudioManager
        audioManager.dispatchMediaKeyEvent(keyEventDown)
        audioManager.dispatchMediaKeyEvent(keyEventUp)
    }
}