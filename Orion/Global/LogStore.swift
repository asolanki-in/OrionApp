//
//  LogStore.swift
//  Orion
//
//  Created by Anil Solanki on 06/06/23.
//

import OSLog
import Foundation

@MainActor final class LogStore: ObservableObject {
	private static let logger = Logger(
		subsystem: Bundle.main.bundleIdentifier!,
		category: String(describing: LogStore.self)
	)

	@Published private(set) var entries: [String] = []

	func export() async {
		do {
			let store = try OSLogStore(scope: .currentProcessIdentifier)
			let position = store.position(timeIntervalSinceLatestBoot: 1)
			entries = try store
				.getEntries(at: position)
				.compactMap { $0 as? OSLogEntryLog }
				.filter { $0.subsystem == Bundle.main.bundleIdentifier! }
				.map { "[\($0.date.formatted())] [\($0.category)] \($0.composedMessage)" }
		} catch {
			Self.logger.warning("\(error.localizedDescription, privacy: .public)")
		}
	}
}
