//
//  Sort.swift
//  Orion
//
//  Created by Anil Solanki on 01/10/22.
//

import Foundation

struct Sort: Identifiable, Codable, Equatable {
	var id = UUID().uuidString
	var title: String
	let children: [Sort]?
	let icon: String
	let parent: String?
	let itemValue: String

	enum CodingKeys: String, CodingKey {
		case title, children, icon, parent, itemValue
	}

	var displayName : String {
		if let parent = self.parent {
			return "\(parent): \(self.title)"
		} else {
			return self.title
		}
	}
}

extension Sort {
	init(from decoder: Decoder) throws {
		let values = try decoder.container(keyedBy: CodingKeys.self)
		//self.id = try values.decode(UUID.self, forKey: .id)
		self.title = try values.decode(String.self, forKey: .title)
		self.children = try? values.decode([Sort].self, forKey: .children)
		self.icon = try values.decode(String.self, forKey: .icon)
		self.parent = try? values.decode(String.self, forKey: .parent)
		self.itemValue = try values.decode(String.self, forKey: .itemValue)
	}

	func encode(to encoder: Encoder) throws {
		var container = encoder.container(keyedBy: CodingKeys.self)
		//try container.encode(id, forKey: .id)
		try container.encode(title, forKey: .title)
		try container.encode(children, forKey: .children)
		try container.encode(icon, forKey: .icon)
		try container.encode(parent, forKey: .parent)
		try container.encode(itemValue, forKey: .itemValue)
	}
}


extension Sort {
	static var postFilterStubData: [Sort] {
		[
			Sort(title: "Hot", children: nil, icon: "flame.fill", parent: nil, itemValue: "hot"),
			Sort(title: "New", children: nil, icon: "clock.arrow.circlepath", parent: nil, itemValue: "new"),
			Sort(title: "Rising", children: nil, icon: "chart.line.uptrend.xyaxis", parent: nil, itemValue: "rising"),
			Sort(title: "Top", children: [
				Sort(title: "This Hour", children: nil, icon: "1.square.fill", parent: "Top", itemValue: "hour"),
				Sort(title: "This Day", children: nil, icon: "24.square.fill", parent: "Top", itemValue: "day"),
				Sort(title: "This Week", children: nil, icon: "7.square.fill", parent: "Top", itemValue: "week"),
				Sort(title: "This Month", children: nil, icon: "30.square.fill", parent: "Top", itemValue: "month"),
				Sort(title: "This Year", children: nil, icon: "calendar", parent: "Top", itemValue: "year"),
				Sort(title: "All Time", children: nil, icon: "infinity", parent: "Top", itemValue: "all")], icon: "chart.bar.xaxis", parent: nil, itemValue: "top"),
			Sort(title: "Controversial", children: [
				Sort(title: "This Hour", children: nil, icon: "1.square.fill", parent: "Controversial", itemValue: "hour"),
				Sort(title: "This Day", children: nil, icon: "24.square.fill", parent: "Controversial", itemValue: "day"),
				Sort(title: "This Week", children: nil, icon: "7.square.fill", parent: "Controversial", itemValue: "week"),
				Sort(title: "This Month", children: nil, icon: "30.square.fill", parent: "Controversial", itemValue: "month"),
				Sort(title: "This Year", children: nil, icon: "calendar", parent: "Controversial", itemValue: "year"),
				Sort(title: "All Time", children: nil, icon: "infinity", parent: "Controversial", itemValue: "all")], icon: "bubble.left.and.exclamationmark.bubble.right.fill", parent: nil, itemValue: "controversial"),
		]
	}

	static var userstubs: [Sort] {
		[
			Sort(title: "Hot", children: nil, icon: "flame.fill", parent: nil, itemValue: "hot"),
			Sort(title: "New", children: nil, icon: "clock.arrow.circlepath", parent: nil, itemValue: "new"),
			Sort(title: "Top", children: [
				Sort(title: "This Hour", children: nil, icon: "1.square.fill", parent: "Top", itemValue: "hour"),
				Sort(title: "This Day", children: nil, icon: "24.square.fill", parent: "Top", itemValue: "day"),
				Sort(title: "This Week", children: nil, icon: "7.square.fill", parent: "Top", itemValue: "week"),
				Sort(title: "This Month", children: nil, icon: "30.square.fill", parent: "Top", itemValue: "month"),
				Sort(title: "This Year", children: nil, icon: "calendar", parent: "Top", itemValue: "year"),
				Sort(title: "All Time", children: nil, icon: "infinity", parent: "Top", itemValue: "all")], icon: "arrow.up.square.fill", parent: nil, itemValue: "top"),
			Sort(title: "Controversial", children: [
				Sort(title: "This Hour", children: nil, icon: "1.square.fill", parent: "Top", itemValue: "hour"),
				Sort(title: "This Day", children: nil, icon: "24.square.fill", parent: "Top", itemValue: "day"),
				Sort(title: "This Week", children: nil, icon: "7.square.fill", parent: "Top", itemValue: "week"),
				Sort(title: "This Month", children: nil, icon: "30.square.fill", parent: "Top", itemValue: "month"),
				Sort(title: "This Year", children: nil, icon: "calendar", parent: "Top", itemValue: "year"),
				Sort(title: "All Time", children: nil, icon: "infinity", parent: "Top", itemValue: "all")], icon: "wind", parent: nil, itemValue: "controversial")
		]
	}

	static var commentstubs: [Sort] {
		[
			Sort(title: "Best", children: nil, icon: "hand.thumbsup", parent: nil, itemValue: "best"),
			Sort(title: "Top", children: nil, icon: "arrow.up.square", parent: nil, itemValue: "top"),
			Sort(title: "New", children: nil, icon: "clock.arrow.circlepath", parent: nil, itemValue: "new"),
			Sort(title: "Controversial", children: nil, icon: "wind", parent: nil, itemValue: "controversial"),
			Sort(title: "Old", children: nil, icon: "clock.arrow.circlepath", parent: nil, itemValue: "old"),
			Sort(title: "Q&A", children: nil, icon: "questionmark.app.dashed", parent: nil, itemValue: "qa"),
			Sort(title: "Random", children: nil, icon: "shuffle", parent: nil, itemValue: "random")
		]
	}

	static var searchstubs: [Sort] {
		[
			Sort(title: "Relevance", children: [
				Sort(title: "This Hour", children: nil, icon: "1.square.fill", parent: "Relevance", itemValue: "hour"),
				Sort(title: "This Day", children: nil, icon: "24.square.fill", parent: "Relevance", itemValue: "day"),
				Sort(title: "This Week", children: nil, icon: "7.square.fill", parent: "Relevance", itemValue: "week"),
				Sort(title: "This Month", children: nil, icon: "30.square.fill", parent: "Relevance", itemValue: "month"),
				Sort(title: "This Year", children: nil, icon: "calendar", parent: "Relevance", itemValue: "year"),
				Sort(title: "All Time", children: nil, icon: "infinity", parent: "Relevance", itemValue: "all")], icon: "circle.circle", parent: nil, itemValue: "relevance"),
			Sort(title: "Hot", children: nil, icon: "flame.fill", parent: nil, itemValue: "hot"),
			Sort(title: "Top", children: [
				Sort(title: "This Hour", children: nil, icon: "1.square.fill", parent: "Top", itemValue: "hour"),
				Sort(title: "This Day", children: nil, icon: "24.square.fill", parent: "Top", itemValue: "day"),
				Sort(title: "This Week", children: nil, icon: "7.square.fill", parent: "Top", itemValue: "week"),
				Sort(title: "This Month", children: nil, icon: "30.square.fill", parent: "Top", itemValue: "month"),
				Sort(title: "This Year", children: nil, icon: "calendar", parent: "Top", itemValue: "year"),
				Sort(title: "All Time", children: nil, icon: "infinity", parent: "Top", itemValue: "all")], icon: "arrow.up.square.fill", parent: nil, itemValue: "top"),
			Sort(title: "New", children: nil, icon: "clock.arrow.circlepath", parent: nil, itemValue: "new"),
			Sort(title: "Comments", children: [
				Sort(title: "This Hour", children: nil, icon: "1.square.fill", parent: "Comments", itemValue: "hour"),
				Sort(title: "This Day", children: nil, icon: "24.square.fill", parent: "Comments", itemValue: "day"),
				Sort(title: "This Week", children: nil, icon: "7.square.fill", parent: "Comments", itemValue: "week"),
				Sort(title: "This Month", children: nil, icon: "30.square.fill", parent: "Comments", itemValue: "month"),
				Sort(title: "This Year", children: nil, icon: "calendar", parent: "Comments", itemValue: "year"),
				Sort(title: "All Time", children: nil, icon: "infinity", parent: "Comments", itemValue: "all")], icon: "text.bubble", parent: nil, itemValue: "comments"),
		]
	}

	static var userSearchstubs: [Sort] {
		[
			Sort(title: "Relevance", children: nil, icon: "circle.circle", parent: nil, itemValue: "relevance"),
			Sort(title: "Activity", children: nil, icon: "person.fill.and.arrow.left.and.arrow.right", parent: nil, itemValue: "activity")
		]
	}
}
