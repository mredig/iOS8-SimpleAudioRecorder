//
//  AudioPlayer.swift
//  iOS8-SimpleAudioRecorder
//
//  Created by Michael Redig on 10/1/19.
//  Copyright © 2019 Red_Egg Productions. All rights reserved.
//

import AVFoundation

protocol AudioPlayerDelegate: AnyObject {
	func playerDidChangeState(_ player: AudioPlayer)
}

class AudioPlayer: NSObject {
	// load song
	// play
	// pause
	// are we playing?
	// timecode
		// duration/timeremaining/current position

	var audioPlayer: AVAudioPlayer
	var isPlaying: Bool {
		audioPlayer.isPlaying
	}
	var elapsedTime: TimeInterval {
		audioPlayer.currentTime
	}
	var duration: TimeInterval {
		audioPlayer.duration
	}
	var timeRemaining: TimeInterval {
		duration - elapsedTime
	}
//	/// 0.0 - 1.0
//	var elapsedPercentage: Double {
//		elapsedTime / duration
//	}
	weak var delegate: AudioPlayerDelegate?
	var timer: Timer?

	override init() {
		audioPlayer = AVAudioPlayer()
		super.init()
		let song = Bundle.main.url(forResource: "piano", withExtension: "mp3")!
		try! load(url: song)
	}

	func load(url: URL) throws {
		audioPlayer = try AVAudioPlayer(contentsOf: url)
		audioPlayer.delegate = self
	}

	func play() {
		audioPlayer.play()
		startTimer()
		notifyDelegate()
	}

	func pause() {
		audioPlayer.pause()
		stopTimer()
		notifyDelegate()
	}

	private func startTimer() {
		stopTimer()
		timer = Timer.scheduledTimer(withTimeInterval: 1/60.0, repeats: true, block: { _ in
			self.notifyDelegate()
		})
	}

	private func stopTimer() {
		timer?.invalidate()
		timer = nil
	}

	private func notifyDelegate() {
		delegate?.playerDidChangeState(self)
	}

	/// figure out based on state what to do
	func playPause() {
		if isPlaying {
			pause()
		} else {
			play()
		}
	}
}


extension AudioPlayer: AVAudioPlayerDelegate {
	func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
		//TODO: Should we add a delegate protocol method?
		notifyDelegate()
	}

	func audioPlayerDecodeErrorDidOccur(_ player: AVAudioPlayer, error: Error?) {
		//TODO: Should we propogate this error?
		if let error = error {
			NSLog("Error playing audio file: \(error)")
		}
		notifyDelegate()
	}
}
