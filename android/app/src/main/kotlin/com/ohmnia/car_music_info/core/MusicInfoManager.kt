package com.ohmnia.car_music_info.core

import android.content.ComponentName
import android.content.Context
import android.media.MediaMetadata
import android.media.session.MediaController
import android.media.session.MediaSession.Token
import android.media.session.MediaSessionManager
import android.media.session.PlaybackState
import android.os.Handler
import android.os.Looper
import com.ohmnia.car_music_info.model.MusicInfo
import com.ohmnia.car_music_info.service.MediaNotificationService
import io.reactivex.disposables.Disposable
import io.reactivex.functions.Consumer
import timber.log.Timber


object MusicInfoManager:
    MediaSessionManager.OnActiveSessionsChangedListener {

    private val callbacks = mutableListOf<SessionCallback>()

    private var isInit = false

    private var mainCallback: SessionCallback? = null

    private lateinit var handler: Handler

    val musicInfoStore = MusicInfoStore()

    fun subscribe(onNext: Consumer<MusicInfo>): Disposable =
        musicInfoStore.store.subscribe(onNext)

    private fun List<SessionCallback>.isNewController(controller: MediaController) =
        none{ it.sameToken(controller.sessionToken) }

    fun registerMediaSessionListener(context: Context) {
        if (isInit) return
        isInit = true

        handler = Handler(Looper.getMainLooper())

        val mediaSessionManager = context.getSystemService(Context.MEDIA_SESSION_SERVICE)
                as MediaSessionManager

        val componentName = ComponentName(context, MediaNotificationService::class.java)

        val controllers = mediaSessionManager.getActiveSessions(componentName)
        registerMediaControllerCallback(controllers)

        mediaSessionManager.addOnActiveSessionsChangedListener(this, componentName, handler)
    }


    fun play() = mainCallback?.play()
    fun pause() = mainCallback?.pause()
    fun fastForward() = mainCallback?.fastForward()
    fun rewind() = mainCallback?.rewind()

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

    class SessionCallback(private val controller: MediaController):
        MediaController.Callback() {

        private var isMainController = false

        override fun onPlaybackStateChanged(state: PlaybackState?) {
            super.onPlaybackStateChanged(state)

            if (state?.state == PlaybackState.STATE_PLAYING) {
                setMainCallback()
            }

            if (!isMainController) return

            if (state == null || state.state == PlaybackState.STATE_NONE) return

            musicInfoStore.addInfo(MusicInfo.parse(controller.isActiveState()))
        }

        fun setMainCallback() {
            if (mainCallback === this) return

            mainCallback?.clearMainCallback()
            mainCallback = this
            isMainController = true

            controller.metadata?.let {
                Timber.d("register $it")
                musicInfoStore.addInfo(MusicInfo.parse(it, controller.isActiveState()))
            }
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

            val info = MusicInfo.parse(metadata)

            musicInfoStore.addInfo(info)
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
        fun fastForward() {
            controller.transportControls.skipToNext()
        }
        fun rewind() = controller.transportControls.skipToPrevious()
    }
}

