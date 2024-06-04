//
//  SafariWebViewController.swift
//  Orion
//
//  Created by Anil Solanki on 01/10/22.
//

import SwiftUI
import SafariServices

struct SafariWebViewController: UIViewControllerRepresentable {
	typealias UIViewControllerType = SFSafariViewController
	var url: URL?
	func makeUIViewController(context: UIViewControllerRepresentableContext<SafariWebViewController>) -> SFSafariViewController {
		let config = SFSafariViewController.Configuration()
		return SFSafariViewController(url: url!, configuration: config)
	}
	func updateUIViewController(_ safariViewController: SFSafariViewController, context: UIViewControllerRepresentableContext<SafariWebViewController>) {
	}
}
