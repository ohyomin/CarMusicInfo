package com.ohmnia.car_music_info.model

import android.media.MediaMetadata

sealed class InfoChangedEvent {
    data class MetaChangedEvent(val meta: MediaMetadata): InfoChangedEvent()
    data class PlayStateEvent(val isPlay: Boolean): InfoChangedEvent()
}