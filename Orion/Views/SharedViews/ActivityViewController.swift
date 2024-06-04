//
//  ActivityViewController.swift
//  Orion
//
//  Created by Anil Solanki on 06/11/22.
//

import SwiftUI


struct ActivityViewController: UIViewControllerRepresentable {

	var activityItems: [Any]
	var applicationActivities: [UIActivity]? = nil

	func makeUIViewController(context: UIViewControllerRepresentableContext<ActivityViewController>) -> UIActivityViewController {
		let controller = UIActivityViewController(activityItems: activityItems, applicationActivities: applicationActivities)
		return controller
	}

	func updateUIViewController(_ uiViewController: UIActivityViewController, context: UIViewControllerRepresentableContext<ActivityViewController>) {}

}
