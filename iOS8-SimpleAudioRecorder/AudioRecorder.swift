//
//  AudioRecorder.swift
//  iOS8-SimpleAudioRecorder
//
//  Created by Michael Redig on 10/1/19.
//  Copyright © 2019 Red_Egg Productions. All rights reserved.
//

import AVFoundation

protocol AudioRecorderDelegate: AnyObject {
	func recorderDidChangeState(_ recorder: AudioRecorder)
	func recorderDidFinishSavingFile(_ recorder: AudioRecorder, url: URL)
}

class AudioRecorder: NSObject {

	private var audioRecorder: AVAudioRecorder?
	var isRecording: Bool {
		audioRecorder?.isRecording ?? false
	}
	weak var delegate: AudioRecorderDelegate?

	override init() {
		super.init()
	}

	func record() {
		let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
		let name = ISO8601DateFormatter.string(from: Date(), timeZone: .current, formatOptions: [.withInternetDateTime])

		let file = documentsDirectory.appendingPathComponent(name).appendingPathExtension("caf")

		let format = AVAudioFormat(standardFormatWithSampleRate: 44_100, channels: 1)! // fix force unwrap

		audioRecorder = try! AVAudioRecorder(url: file, format: format) // fix force try
		audioRecorder?.delegate = self
		audioRecorder?.record()
		notifyDelegate()
	}

	func stop() {
		audioRecorder?.stop() // save to disk
		notifyDelegate()
	}

	func toggleRecording() {
		if isRecording {
			stop()
		} else {
			record()
		}
	}

	private func notifyDelegate() {
		delegate?.recorderDidChangeState(self)
	}
}

extension AudioRecorder: AVAudioRecorderDelegate {

    func audioRecorderEncodeErrorDidOccur(_ recorder: AVAudioRecorder, error: Error?) {
        if let error = error {
            print("audioRecorderEncodeErrorDidOccur: \(error)")
        }
    }

    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
		delegate?.recorderDidFinishSavingFile(self, url: recorder.url)
    }
}
