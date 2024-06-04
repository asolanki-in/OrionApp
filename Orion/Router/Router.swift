//
//  Router.swift
//  Orion
//
//  Created by Anil Solanki on 06/11/22.
//

import SwiftUI

class Router: ObservableObject {
	
	@Published var currentTab : Int = 0

	@Published var HOME_NAV_PATH: NavigationPath = .init()
	@Published var NEWS_NAV_PATH: NavigationPath = .init()
	@Published var SCROLLER_NAV_PATH: NavigationPath = .init()
	@Published var SEARCH_NAV_PATH: NavigationPath = .init()
	@Published var SETTINGS_NAV_PATH: NavigationPath = .init()

	public func pushView(value: any Hashable) {
		switch currentTab {
		case 0:
			HOME_NAV_PATH.append(value)
		case 1:
			NEWS_NAV_PATH.append(value)
		case 2:
			SCROLLER_NAV_PATH.append(value)
		case 3:
			SEARCH_NAV_PATH.append(value)
		case 4:
			SETTINGS_NAV_PATH.append(value)
		default:
			HOME_NAV_PATH.append(value)
		}
	}

}
