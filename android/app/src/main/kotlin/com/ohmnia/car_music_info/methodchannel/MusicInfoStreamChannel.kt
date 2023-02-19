package com.ohmnia.car_music_info.methodchannel

import com.ohmnia.car_music_info.core.Constants
import com.ohmnia.car_music_info.core.MusicInfoManager
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.EventChannel
import io.reactivex.disposables.Disposable
import timber.log.Timber

class MusicInfoStreamChannel: EventChannel.StreamHandler {

    private var eventSink: EventChannel.EventSink? = null
    private var disposable: Disposable? = null

    fun init(engine: FlutterEngine) {
        val messenger = engine.dartExecutor.binaryMessenger
        EventChannel(messenger, Constants.MUSIC_INFO_CHANNEL)
            .setStreamHandler(this)
    }

    override fun onListen(arguments: Any?, events: EventChannel.EventSink?) {
        Timber.d("onListen")
        if (events == null) return

        eventSink = events
        disposable = MusicInfoManager.subscribe {
            Timber.d("New meta $it")
            eventSink?.success(it.toMap())
        }
    }

    override fun onCancel(arguments: Any?) {
        eventSink = null
        disposable?.dispose()
    }
}