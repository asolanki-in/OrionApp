//
//  PlayerViewController.swift
//  Orion
//
//  Created by Anil Solanki on 01/10/22.
//

import Foundation

import AVKit
import SwiftUI

struct PlayerViewController: UIViewControllerRepresentable {
	var videoURL: URL

	func makeUIViewController(context: Context) -> VideoPlayerController {
		let controller = VideoPlayerController(url: videoURL)
		controller.modalPresentationStyle = .fullScreen
		return controller
	}

	func updateUIViewController(_ playerController: VideoPlayerController, context: Context) {}
}
