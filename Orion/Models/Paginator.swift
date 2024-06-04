//
//  Paginator.swift
//  Orion
//
//  Created by Anil Solanki on 01/10/22.
//

import Foundation

protocol Loadable {
	var initialLoading: Bool { get set }
	var loadingMore: Bool { get set }
}

struct Paginator : Loadable {
	var initialLoading: Bool = true
	var loadingMore: Bool = false
	var after: String?

	init(initialLoading: Bool = true, loadingMore: Bool = false, after: String?) {
		self.initialLoading = initialLoading
		self.loadingMore = loadingMore
		self.after = after
	}
}
