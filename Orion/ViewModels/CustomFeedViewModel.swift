//
//  CustomFeedViewModel.swift
//  Orion
//
//  Created by Anil Solanki on 09/10/22.
//

import Foundation

class CustomFeedViewModel : ObservableObject, Identifiable {
	var id = UUID().uuidString
	var feed: CustomFeed
	init(feed: CustomFeed) {
		self.feed = feed
	}
}

