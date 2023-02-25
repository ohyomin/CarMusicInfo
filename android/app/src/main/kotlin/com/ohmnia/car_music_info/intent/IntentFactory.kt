package com.ohmnia.car_music_info.intent

import android.media.MediaMetadata
import com.ohmnia.car_music_info.core.MusicInfoStore
import com.ohmnia.car_music_info.model.InfoChangedEvent
import com.ohmnia.car_music_info.model.InfoChangedEvent.*
import com.ohmnia.car_music_info.model.MusicInfo
import timber.log.Timber
import javax.inject.Inject
import javax.inject.Singleton

@Singleton
class IntentFactory @Inject constructor(
    private val musicInfoStore: MusicInfoStore
) {
    fun process(event: InfoChangedEvent) {
        val intent = when(event) {
            is MetaChangedEvent -> buildMusicChangeIntent(event)
            is PlayStateEvent -> buildPlayStateIntent(event)
        }
        musicInfoStore.process(intent)
    }

    private fun buildMusicChangeIntent(event: MetaChangedEvent): Intent<MusicInfo> {
        return intent {
            val newMeta = event.meta
            copy(
                title = newMeta.getString(MediaMetadata.METADATA_KEY_TITLE) ?: "",
                artist = newMeta.getString(MediaMetadata.METADATA_KEY_ARTIST) ?: "",
                albumArt = newMeta.getBitmap(MediaMetadata.METADATA_KEY_ALBUM_ART)
                    ?: newMeta.getBitmap(MediaMetadata.METADATA_KEY_ART)
            )
        }
    }

    private fun buildPlayStateIntent(event: PlayStateEvent): Intent<MusicInfo> {
        return intent { copy(isPlay = event.isPlay) }
    }
}