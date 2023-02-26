package com.ohmnia.car_music_info.util

import android.content.ComponentName
import android.content.Context
import android.content.Context.MODE_PRIVATE
import android.content.Intent
import android.content.SharedPreferences
import android.content.pm.PackageManager
import android.graphics.Bitmap
import android.graphics.BitmapFactory
import android.media.MediaMetadata
import android.service.media.MediaBrowserService
import android.util.Base64
import com.ohmnia.car_music_info.model.MusicInfo
import timber.log.Timber

object MusicInfoStorage {
    private const val TITLE = "title"
    private const val ARTIST = "artist"
    private const val ALBUM_ART = "albumArt"
    private const val NAME = "music_info"
    private const val PACKAGE_NAME = "package"
    private const val COMPONENT_NAME = "name"

    private lateinit var pref: SharedPreferences
    private lateinit var packageManager: PackageManager

    fun init(context: Context) {
        pref = context.getSharedPreferences(NAME, MODE_PRIVATE)
        packageManager = context.packageManager
    }

    private fun getAlbumArtEncodedString(albumArt: Bitmap?) =
        MusicInfo.byteFromBitmap(albumArt)?.run{
           Base64.encodeToString(this, Base64.DEFAULT)
        } ?: ""

    private fun getAlbumArt(): Bitmap? {
        val value = pref.getString(ALBUM_ART, null)
            ?: return null

        return Base64.decode(value, Base64.DEFAULT)?.run {
            BitmapFactory.decodeByteArray(this, 0, size)
        }
    }

    fun savePackageInfo(packageName: String) {
        val intent = Intent(MediaBrowserService.SERVICE_INTERFACE)
        packageManager.queryIntentServices(intent, 0).firstOrNull { resolveInfo ->
            resolveInfo.serviceInfo.packageName == packageName
        }?.let { resolveInfo ->
            Timber.d("Found component : ${resolveInfo.serviceInfo}")
            pref.edit().run {
                putString(PACKAGE_NAME, resolveInfo.serviceInfo.packageName)
                putString(COMPONENT_NAME, resolveInfo.serviceInfo.name)
                apply()
            }
        }
    }

    fun getPrevComponent(): ComponentName? {
        val packageName = pref.getString(PACKAGE_NAME, null) ?: return null
        val componentName = pref.getString(COMPONENT_NAME, null) ?: return null
        Timber.d("prev package:$packageName, name:$componentName")
        return ComponentName(packageName, componentName)
    }

    fun saveMeta(data: MediaMetadata) {
        Timber.d("start save meta")
        val title = data.getString(MediaMetadata.METADATA_KEY_TITLE) ?: ""
        val artist = data.getString(MediaMetadata.METADATA_KEY_ARTIST) ?: ""
        val albumArt = data.getBitmap(MediaMetadata.METADATA_KEY_ALBUM_ART)
            ?: data.getBitmap(MediaMetadata.METADATA_KEY_ART)

        val albumArtString = getAlbumArtEncodedString(albumArt)

        pref.edit().run {
            putString(TITLE, title)
            putString(ARTIST, artist)
            putString(ALBUM_ART, albumArtString)
            apply()
        }
        Timber.d("save meta $title, ${albumArtString.length}")
    }

    fun getPrevMusicInfo(): MusicInfo? {
        val title = pref.getString(TITLE, null)
        val artist = pref.getString(ARTIST, null)
        val albumArt = getAlbumArt()

        Timber.d("title:$title, artist:$artist, album:$albumArt")
        if (title == null || artist == null) return null

        return MusicInfo(
            title = title,
            artist = artist,
            albumArt = albumArt,
            isPlay = false
        )
    }
}


