//
//  ModeratorsView+Observed.swift
//  Orion
//
//  Created by Anil Solanki on 04/02/23.
//

import Foundation

extension ModeratorsView {
	final class Observed : ObservableObject {

		@Published var moderators = [Moderator]()
		@Published var requestRunning = false

		var next : String?
		var errorMessage = ""

		let service = SubredditService()

		var showProgress : Bool { return self.requestRunning && self.moderators.count == 0 }

		func loadMore(item : Moderator, name: String) {
			if self.requestRunning { return }
			if self.next == nil { return }
			let thresholdIndex = self.moderators.index(self.moderators.endIndex, offsetBy: -2)
			if self.moderators.firstIndex(where: { $0.id == item.id }) == thresholdIndex {
				loadModerators(name: name)
			}
		}

		func loadModerators(name: String) {
			if self.requestRunning { return }
			if self.next == nil &&  self.moderators.count > 0 { return }
			self.requestRunning = true
			self.fetchModerators(name: name, next: self.next)
		}

		func fetchModerators(name: String, next: String?) {
			Task.detached(priority: .background) { [weak self] in
				do {
					let thing = try await self?.service.getSubRedditModerators(name, next: next)
					self?.next = thing?.data.after
					await self?.completed(moderators: thing?.data.children, error: nil)
				} catch {
					await self?.completed(moderators: nil, error: error)
				}
			}
		}

		@MainActor private func completed(moderators: [Moderator]?, error: Error?) {
			if let error = error {
				self.errorMessage = error.localizedDescription
			} else if let moderators = moderators {
				self.moderators.append(contentsOf: moderators)
				self.errorMessage = ""
			}
			self.requestRunning = false
		}
	}

}
