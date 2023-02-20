package com.ohmnia.car_music_info.core

import com.ohmnia.car_music_info.model.MusicInfo
import io.reactivex.Observable
import io.reactivex.android.schedulers.AndroidSchedulers
import io.reactivex.subjects.BehaviorSubject
import timber.log.Timber


class MusicInfoStore {
    private val subject = BehaviorSubject.create<MusicInfo>()

    val store: Observable<MusicInfo> = subject
        .observeOn(AndroidSchedulers.mainThread())
        .scan { old, new ->
            val result = new.reduce(old)
            //Timber.d("old : $old, new : $new, result : $result")
            result
        }
        .distinctUntilChanged()

    fun addInfo(info: MusicInfo) = subject.onNext(info)
}