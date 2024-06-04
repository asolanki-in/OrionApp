//
//  NewsService.swift
//  Orion
//
//  Created by Anil Solanki on 19/11/22.
//

import Foundation

struct NewsService : NetworkService {
	public func getNewsCategories() async throws -> [Thing<CustomFeed>] {
		let endpoint = NewsEndpoint.categories
		return try await self.load(endpoint, allowRetry: true)
	}
}
