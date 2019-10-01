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

	weak var delegate: AudioPlayerDelegate?

	override init() {
		audioPlayer = AVAudioPlayer()
		super.init()
		let song = Bundle.main.url(forResource: "piano", withExtension: "mp3")!
		try! load(url: song)
	}

	func load(url: URL) throws {
		audioPlayer = try AVAudioPlayer(contentsOf: url)
	}

	func play() {
		audioPlayer.play()
		notifyDelegate()
	}

	func pause() {
		audioPlayer.pause()
		notifyDelegate()
	}

	func notifyDelegate() {
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
