//
//  SubredditViewModel.swift
//  Orion
//
//  Created by Anil Solanki on 02/10/22.
//

import Foundation

class SubredditViewModel : ObservableObject, Identifiable {
	var id = UUID().uuidString
	var subreddit: Subreddit
	init(subreddit: Subreddit) {
		self.subreddit = subreddit
	}
}
