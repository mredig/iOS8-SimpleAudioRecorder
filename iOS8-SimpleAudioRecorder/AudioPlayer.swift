//
//  AudioPlayer.swift
//  iOS8-SimpleAudioRecorder
//
//  Created by Michael Redig on 10/1/19.
//  Copyright © 2019 Red_Egg Productions. All rights reserved.
//

import AVFoundation

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
	}

	func pause() {
		audioPlayer.pause()
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
