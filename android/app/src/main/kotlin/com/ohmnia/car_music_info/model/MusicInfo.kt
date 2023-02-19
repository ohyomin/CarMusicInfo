package com.ohmnia.car_music_info.model

import android.graphics.Bitmap
import android.media.MediaMetadata
import java.io.ByteArrayOutputStream

class MusicInfo private constructor(
    val title: String,
    val artist: String,
    val albumArt: Bitmap?
) {
    companion object {
        fun parse(metadata: MediaMetadata): MusicInfo {
            return metadata.run {
                MusicInfo(
                    title = getString(MediaMetadata.METADATA_KEY_TITLE) ?: "",
                    artist = getString(MediaMetadata.METADATA_KEY_ARTIST) ?: "",
                    albumArt = getBitmap(MediaMetadata.METADATA_KEY_ALBUM_ART)
                        ?: getBitmap(MediaMetadata.METADATA_KEY_ART)
                )
            }
        }
    }

    fun toMap(): Map<String, Any?> {
        return mutableMapOf<String, Any?>().apply {
            put("title", title)
            put("artist", artist)
            put("albumArt", byteFromBitmap())
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
                && other.getBitmapSize() == getBitmapSize()
    }

    fun getBitmapSize() = albumArt?.byteCount ?: 0

    override fun hashCode(): Int {
        var result = title.hashCode()
        result = 31 * result + artist.hashCode()
        result = 31 * result + (albumArt?.byteCount ?: 0)
        return result
    }

    override fun toString(): String {
        return "title:$title, artist:$artist, albumArt:${getBitmapSize()}"
    }
}