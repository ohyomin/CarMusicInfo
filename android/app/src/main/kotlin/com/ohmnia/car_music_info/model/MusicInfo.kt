package com.ohmnia.car_music_info.model

import android.graphics.Bitmap
import android.media.MediaMetadata
import java.io.ByteArrayOutputStream

data class MusicInfo(
    val title: String,
    val artist: String,
    val albumArt: Bitmap?,
    val isPlay: Boolean,
) {
    companion object {
        val empty = MusicInfo("", "", null, false)

    }

    fun toMap(): Map<String, Any?> {
        return mutableMapOf<String, Any?>().apply {
            put("title", title)
            put("artist", artist)
            put("albumArt", byteFromBitmap())
            put("isPlay", if (isPlay) 1 else 0)
        }
    }

    private fun byteFromBitmap(): ByteArray? {
        return albumArt?.let { art ->
            val stream = ByteArrayOutputStream()
            art.compress(Bitmap.CompressFormat.PNG, 100, stream)
            stream.toByteArray()
        }
    }

    override fun equals(other: Any?): Boolean {
        return other is MusicInfo
                && other.title == title
                && other.artist == artist
                && other.isPlay == isPlay
                && other.getBitmapSize() == getBitmapSize()
    }

    private fun getBitmapSize() = albumArt?.byteCount ?: 0
}
