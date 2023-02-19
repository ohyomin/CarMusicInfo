package com.ohmnia.car_music_info.core

import com.ohmnia.car_music_info.model.MusicInfo
import io.reactivex.Observable
import io.reactivex.android.schedulers.AndroidSchedulers
import io.reactivex.subjects.BehaviorSubject


class MusicInfoStore {
    private val subject = BehaviorSubject.create<MusicInfo>()

    val store: Observable<MusicInfo> = subject
        .observeOn(AndroidSchedulers.mainThread())
        .distinctUntilChanged()

    fun addInfo(info: MusicInfo) = subject.onNext(info)
}