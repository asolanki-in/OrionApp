//
//  MailView.swift
//  Orion
//
//  Created by Anil Solanki on 24/12/22.
//

import Foundation
import SwiftUI
import UIKit
import MessageUI

struct MailView: UIViewControllerRepresentable {

	@Environment(\.presentationMode) var presentation
	@Binding var result: Result<MFMailComposeResult, Error>?
	public var configure: ((MFMailComposeViewController) -> Void)?

	public class Coordinator: NSObject, MFMailComposeViewControllerDelegate {

		@Binding var presentation: PresentationMode
		@Binding var result: Result<MFMailComposeResult, Error>?

		init(presentation: Binding<PresentationMode>,
			 result: Binding<Result<MFMailComposeResult, Error>?>) {
			_presentation = presentation
			_result = result
		}

		public func mailComposeController(_ controller: MFMailComposeViewController,
								   didFinishWith result: MFMailComposeResult,
								   error: Error?) {
			defer {
				$presentation.wrappedValue.dismiss()
			}
			guard error == nil else {
				self.result = .failure(error!)
				return
			}
			self.result = .success(result)
		}
	}

	public func makeCoordinator() -> Coordinator {
		return Coordinator(presentation: presentation, result: $result)
	}

	public func makeUIViewController(context: UIViewControllerRepresentableContext<MailView>) -> MFMailComposeViewController {
		let vc = MFMailComposeViewController()
		vc.mailComposeDelegate = context.coordinator
		configure?(vc)
		return vc
	}

	public func updateUIViewController(
		_ uiViewController: MFMailComposeViewController,
		context: UIViewControllerRepresentableContext<MailView>) {
	}
}
