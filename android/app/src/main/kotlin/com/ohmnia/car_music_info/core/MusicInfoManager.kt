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
import com.ohmnia.car_music_info.intent.IntentFactory
import com.ohmnia.car_music_info.model.InfoChangedEvent.MetaChangedEvent
import com.ohmnia.car_music_info.model.InfoChangedEvent.PlayStateEvent
import com.ohmnia.car_music_info.service.MediaNotificationService
import com.ohmnia.car_music_info.util.MusicInfoStorage
import kotlinx.coroutines.CoroutineScope
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.Runnable
import kotlinx.coroutines.launch
import timber.log.Timber
import javax.inject.Inject
import javax.inject.Singleton


@Singleton
class MusicInfoManager @Inject constructor(
    private val intentFactory: IntentFactory,
    private val musicStarter: MusicStarter
) :
    MediaSessionManager.OnActiveSessionsChangedListener {

    private val callbacks = mutableListOf<SessionCallback>()

    private var isInit = false

    private var mainCallback: SessionCallback? = null

    private lateinit var handler: Handler

    //private lateinit var musicStarter = MusicStarter()

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

            musicStarter.play()
            isInit = true
        }
    }

    fun dispose() {
        Timber.d("dispose")
        musicStarter.dispose()
        callbacks.forEach(SessionCallback::dispose)
    }

    fun play() = mainCallback?.play() ?: musicStarter.play()
    fun pause() = mainCallback?.pause()
    fun fastForward() = mainCallback?.fastForward() ?: musicStarter.play()
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

        fun dispose() = controller.unregisterCallback(this)

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

            CoroutineScope(Dispatchers.IO).launch {
                MusicInfoStorage.savePackageInfo(controller.packageName)
            }
        }

        private fun clearMainCallback() {
            isMainController = false
            if (mainCallback === this) {
                mainCallback = null
            }
        }


        private var bufferedRunnable: Runnable? = null
        private var prevMediaMetadata: MediaMetadata? = null

        private fun MediaMetadata.isSameSong(prev: MediaMetadata?): Boolean {
            if (prev == null) return false

            return description.title == prev.description.title
        }

        override fun onMetadataChanged(metadata: MediaMetadata?) {
            super.onMetadataChanged(metadata)

            if (!isMainController || metadata == null) return

            if (metadata.isSameSong(prevMediaMetadata) && bufferedRunnable != null) {
                Timber.d("Skip prev meta data. ${prevMediaMetadata?.description}")
                handler.removeCallbacks(bufferedRunnable!!)
            }

            prevMediaMetadata = metadata

            bufferedRunnable = Runnable {
                intentFactory.process(MetaChangedEvent(metadata))
                CoroutineScope(Dispatchers.IO).launch {
                    MusicInfoStorage.saveMeta(metadata)
                }
            }

            handler.postDelayed(bufferedRunnable!!, 200)
        }

        override fun onSessionDestroyed() {
            super.onSessionDestroyed()
            if (isMainController) {
                intentFactory.process(PlayStateEvent(isPlay = false))
                clearMainCallback()
            }
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

