package com.ohmnia.car_music_info.model

import com.ohmnia.car_music_info.intent.Intent
import com.ohmnia.car_music_info.model.MusicInfo
import com.ohmnia.car_music_info.util.MusicInfoStorage
import io.reactivex.Observable
import io.reactivex.android.schedulers.AndroidSchedulers
import io.reactivex.subjects.BehaviorSubject
import timber.log.Timber
import javax.inject.Inject
import javax.inject.Singleton


@Singleton
class MusicInfoStore @Inject constructor() {
    private var prevMusicInfo: MusicInfo =
        MusicInfoStorage.getPrevMusicInfo() ?: MusicInfo.empty

    private val intents = BehaviorSubject.create<Intent<MusicInfo>>()

    val store: Observable<MusicInfo> = intents
        .observeOn(AndroidSchedulers.mainThread())
        .scan(prevMusicInfo) { oldState, intent -> intent.reduce(oldState) }
        .distinctUntilChanged()

    fun process(intent: Intent<MusicInfo>) = intents.onNext(intent)

    private val internalDisposable = store.subscribe(::internalLogger)

    private fun internalLogger(state: MusicInfo) = Timber.i("State: $state")
}