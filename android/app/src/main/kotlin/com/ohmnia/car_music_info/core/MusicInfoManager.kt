package com.ohmnia.car_music_info.core

import android.content.ComponentName
import android.content.Context
import android.content.Intent
import android.media.AudioManager
import android.media.MediaMetadata
import android.media.session.MediaController
import android.media.session.MediaSession.Token
import android.media.session.MediaSessionManager
import android.media.session.PlaybackState
import android.os.Handler
import android.os.Looper
import android.os.SystemClock
import android.util.Log
import android.view.KeyEvent
import androidx.core.app.ActivityOptionsCompat
import com.ohmnia.car_music_info.intent.IntentFactory
import com.ohmnia.car_music_info.model.InfoChangedEvent.MetaChangedEvent
import com.ohmnia.car_music_info.model.InfoChangedEvent.PlayStateEvent
import com.ohmnia.car_music_info.service.MediaNotificationService
import timber.log.Timber
import javax.inject.Inject
import javax.inject.Singleton


@Singleton
class MusicInfoManager @Inject constructor(
    private val intentFactory: IntentFactory
) :
    MediaSessionManager.OnActiveSessionsChangedListener {

    private val callbacks = mutableListOf<SessionCallback>()

    private var isInit = false

    private var mainCallback: SessionCallback? = null

    private lateinit var handler: Handler

    lateinit var musicStarter: MusicStarter

    private fun List<SessionCallback>.isNewController(controller: MediaController) =
        none{ it.sameToken(controller.sessionToken) }

    fun registerMediaSessionListener(context: Context) {
        synchronized(this) {
            if (isInit) return

            handler = Handler(Looper.getMainLooper())

            val mediaSessionManager = context.getSystemService(Context.MEDIA_SESSION_SERVICE)
                    as MediaSessionManager

            val componentName = ComponentName(context, MediaNotificationService::class.java)

            val controllers = mediaSessionManager.getActiveSessions(componentName)
            registerMediaControllerCallback(controllers)

            mediaSessionManager.addOnActiveSessionsChangedListener(this, componentName, handler)

            musicStarter = MusicStarter(context).apply {
                play {  }
            }
            isInit = true
        }
    }

    fun dispose() = musicStarter.dispose()

    fun play() = mainCallback?.play()
    fun pause() = mainCallback?.pause()
    fun fastForward() = mainCallback?.fastForward()
    fun rewind() = mainCallback?.rewind()

    fun startApp(context: Context) {
        val current = mainCallback ?: return
        val packageName = current.controller.packageName
        val intent = context.packageManager.getLaunchIntentForPackage(packageName) ?: return
        context.startActivity(intent)
    }

    private fun registerMediaControllerCallback(controllers: MutableList<MediaController>?) {
        controllers?.forEach { controller ->
            if (callbacks.isNewController(controller)) {
                SessionCallback(controller).apply{
                    controller.registerCallback(this)
                    callbacks.add(this)
                    Timber.d("Added callback ${callbacks.size}")

                    if (controller.playbackState?.state == PlaybackState.STATE_PLAYING) {
                        setMainCallback()
                    }
                }
            }
        }
    }

    override fun onActiveSessionsChanged(controllers: MutableList<MediaController>?) {
        registerMediaControllerCallback(controllers)
    }

    fun MediaController.isActiveState(): Boolean {
        return when (playbackState?.state) {
            PlaybackState.STATE_PLAYING,
            PlaybackState.STATE_BUFFERING -> true
            else -> false
        }
    }

    inner class SessionCallback(val controller: MediaController):
        MediaController.Callback() {

        private var isMainController = false

        override fun onPlaybackStateChanged(state: PlaybackState?) {
            super.onPlaybackStateChanged(state)

            if (state?.state == PlaybackState.STATE_PLAYING) {
                setMainCallback()
            }

            if (!isMainController) return
            if (state == null || state.state == PlaybackState.STATE_NONE) return

            val event = PlayStateEvent(controller.isActiveState())
            intentFactory.process(event)
        }

        fun setMainCallback() {
            if (mainCallback === this) return

            mainCallback?.clearMainCallback()
            mainCallback = this
            isMainController = true

            controller.metadata?.let {
                val event = MetaChangedEvent(it)
                intentFactory.process(event)
            }
            intentFactory.process(PlayStateEvent(controller.isActiveState()))
        }

        private fun clearMainCallback() {
            isMainController = false
            if (mainCallback === this) {
                mainCallback = null
            }
        }

        override fun onMetadataChanged(metadata: MediaMetadata?) {
            super.onMetadataChanged(metadata)

            if (!isMainController || metadata == null) return

            intentFactory.process(MetaChangedEvent(metadata))
        }

        override fun onSessionDestroyed() {
            super.onSessionDestroyed()
            clearMainCallback()
            callbacks.remove(this)
            Timber.d("Destroy callback ${callbacks.size}")
        }

        fun sameToken(token: Token) = controller.sessionToken == token

        fun play() = controller.transportControls.play()
        fun pause() = controller.transportControls.pause()
        fun fastForward() = controller.transportControls.skipToNext()
        fun rewind() = controller.transportControls.skipToPrevious()
    }
}

