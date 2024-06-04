//
//  VideoPlayerController.swift
//  Orion
//
//  Created by Anil Solanki on 01/10/22.
//

import UIKit
import AVKit

class VideoPlayerController: UIViewController {

	var playerController : AVPlayerViewController?

	init(url: URL) {
		let player = AVPlayer(url: url)
		self.playerController = AVPlayerViewController()
		self.playerController?.player = player
		super.init(nibName: nil, bundle: nil)
	}

	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	override func viewDidLoad() {
		super.viewDidLoad()
		if let playerController = self.playerController {
			self.addChild(playerController)
			playerController.view.frame = view.bounds
			view.addSubview(playerController.view)
			playerController.player?.play()
		}
	}

	override func didReceiveMemoryWarning() {
		self.playerController = nil
		self.dismiss(animated: true)
	}

	deinit {
		print("DEINIT \(self)")
		self.playerController?.player?.pause()
		self.playerController?.player = nil
		self.playerController = nil
	}

}
