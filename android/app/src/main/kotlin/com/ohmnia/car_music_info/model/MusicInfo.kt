package com.ohmnia.car_music_info.model

import android.graphics.Bitmap
import java.io.ByteArrayOutputStream

data class MusicInfo(
    val title: String,
    val artist: String,
    val albumArt: Bitmap?,
    val isPlay: Boolean,
) {
    companion object {
        val empty = MusicInfo("", "", null, false)

        fun byteFromBitmap(albumArt: Bitmap?): ByteArray? {
            return albumArt?.let { art ->
                val stream = ByteArrayOutputStream()
                art.compress(Bitmap.CompressFormat.PNG, 100, stream)
                stream.toByteArray()
            }
        }
    }

    fun toMap(): Map<String, Any?> {
        return mutableMapOf<String, Any?>().apply {
            put("title", title)
            put("artist", artist)
            put("albumArt", byteFromBitmap(albumArt))
            put("isPlay", if (isPlay) 1 else 0)
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

    override fun hashCode(): Int {
        var result = title.hashCode()
        result = 31 * result + artist.hashCode()
        result = 31 * result + getBitmapSize()
        result = 31 * result + isPlay.hashCode()
        return result
    }
}
