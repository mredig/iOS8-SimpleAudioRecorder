//
//  AudioRecorder.swift
//  iOS8-SimpleAudioRecorder
//
//  Created by Michael Redig on 10/1/19.
//  Copyright © 2019 Red_Egg Productions. All rights reserved.
//

import AVFoundation

class AudioRecorder: NSObject {

	private var audioRecorder: AVAudioRecorder
	var isRecording: Bool {
		audioRecorder.isRecording
	}

	override init() {
		audioRecorder = AVAudioRecorder()

		super.init()
	}

	func record() {
		let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
		let name = ISO8601DateFormatter.string(from: Date(), timeZone: .current, formatOptions: [.withInternetDateTime])

		let file = documentsDirectory.appendingPathComponent(name).appendingPathExtension("caf")

		let format = AVAudioFormat(standardFormatWithSampleRate: 44_100, channels: 1)! // fix force unwrap

		audioRecorder = try! AVAudioRecorder(url: file, format: format) // fix force try
		audioRecorder.record()
	}

	func stop() {
		audioRecorder.stop() // save to disk
	}

}