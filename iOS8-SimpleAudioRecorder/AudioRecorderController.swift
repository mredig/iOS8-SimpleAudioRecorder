//
//  ViewController.swift
//  AudioRecorder
//
//  Created by Paul Solt on 10/1/19.
//  Copyright © 2019 Lambda, Inc. All rights reserved.
//

import UIKit

class AudioRecorderController: UIViewController {
    
    @IBOutlet weak var recordButton: UIButton!
    @IBOutlet weak var playButton: UIButton!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var timeRemainingLabel: UILabel!
    @IBOutlet weak var timeSlider: UISlider!

	private lazy var timeFormatter: DateComponentsFormatter = {
		let formatting = DateComponentsFormatter()
		formatting.unitsStyle = .positional // 00:00
		formatting.zeroFormattingBehavior = .pad
		formatting.allowedUnits = [.minute, .second]
		return formatting
	}()

	let player = AudioPlayer()

	private func updateViews() {
		let title = player.isPlaying ? "Pause" : "Play"
		playButton.setTitle(title, for: .normal)

		timeLabel.text = timeFormatter.string(from: player.elapsedTime)
		timeRemainingLabel.text = timeFormatter.string(from: player.timeRemaining)

		updateSlider()
	}

	override func viewDidLoad() {
		super.viewDidLoad()

        timeLabel.font = UIFont.monospacedDigitSystemFont(ofSize: timeLabel.font.pointSize,
                                                          weight: .regular)
        timeRemainingLabel.font = UIFont.monospacedDigitSystemFont(ofSize: timeRemainingLabel.font.pointSize,
                                                                   weight: .regular)

		let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!

		player.delegate = self
	}


    @IBAction func playButtonPressed(_ sender: Any) {
		player.playPause()
		updateSlider()
	}

	private func updateSlider() {
		timeSlider.minimumValue = 0
		timeSlider.maximumValue = Float(player.duration)
		timeSlider.value = Float(player.elapsedTime)
	}
    
    @IBAction func recordButtonPressed(_ sender: Any) {
    
    }
}

extension AudioRecorderController: AudioPlayerDelegate {
	func playerDidChangeState(_ player: AudioPlayer) {
		// update views
		updateViews()
	}
}
