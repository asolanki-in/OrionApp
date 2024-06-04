//
//  RulesView+Observed.swift
//  Orion
//
//  Created by Anil Solanki on 04/02/23.
//

import Foundation

extension RulesView {
	final class Observed : ObservableObject {

		@Published var rules = [Rule]()
		@Published var requestRunning = false

		let service = SubredditService()

		func loadRules(prefix: String) {
			if self.rules.count > 0 { return }
			if self.requestRunning { return }
			self.requestRunning = true
			self.fetchRules(prefix: prefix)
		}

		func fetchRules(prefix: String) {
			Task.detached(priority: .background) { [weak self] in
				do {
					let thing = try await self?.service.getSubRedditRules(prefix)
					await self?.completed(rules: thing?.rules, error: nil)
				} catch {
					await self?.completed(rules: nil, error: error)
				}
			}
		}

		@MainActor private func completed(rules: [Rule]?, error: Error?) {
			if let error {
			} else if let rules = rules {
				self.rules = rules
			}
			self.requestRunning = false
		}

	}

}
