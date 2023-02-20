package com.ohmnia.car_music_info.model

import android.graphics.Bitmap
import android.media.MediaMetadata
import java.io.ByteArrayOutputStream

class MusicInfo private constructor(
    val title: String? = null,
    val artist: String? = null,
    val albumArt: Bitmap? = null,
    val isPlay: Boolean? = null
) {
    companion object {
        fun parse(metadata: MediaMetadata, isPlay: Boolean? = null): MusicInfo {
            return metadata.run {
                MusicInfo(
                    title = getString(MediaMetadata.METADATA_KEY_TITLE) ?: "",
                    artist = getString(MediaMetadata.METADATA_KEY_ARTIST) ?: "",
                    albumArt = getBitmap(MediaMetadata.METADATA_KEY_ALBUM_ART)
                        ?: getBitmap(MediaMetadata.METADATA_KEY_ART),
                    isPlay = isPlay
                )
            }
        }

        fun parse(isPlay: Boolean): MusicInfo {
            return MusicInfo(isPlay = isPlay)
        }
    }

    fun reduce(other: MusicInfo): MusicInfo {
        return MusicInfo(
            title = title ?: other.title,
            artist = artist ?: other.artist,
            albumArt = albumArt ?: other.albumArt,
            isPlay = isPlay ?: other.isPlay
        )
    }

    fun toMap(): Map<String, Any?> {
        return mutableMapOf<String, Any?>().apply {
            put("title", title)
            put("artist", artist)
            put("albumArt", byteFromBitmap())
            put("isPlay", if (isPlay == true) 1 else 0)
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

    fun getBitmapSize() = albumArt?.byteCount ?: 0

    override fun hashCode(): Int {
        var result = title.hashCode()
        result = 31 * result + artist.hashCode()
        result = 31 * result + isPlay.hashCode()
        result = 31 * result + (albumArt?.byteCount ?: 0)
        return result
    }

    override fun toString(): String {
        return "title:$title, artist:$artist, albumArt:${getBitmapSize()}, isPlay: $isPlay"
    }
}