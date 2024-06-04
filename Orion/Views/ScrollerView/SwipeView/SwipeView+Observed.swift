//
//  SwipeView+Observed.swift
//  Orion
//
//  Created by Anil Solanki on 14/05/23.
//

import Foundation

extension SwipeView {
	final class Observed : ObservableObject {

		@Published var post = ["1", "2", "3", "4", "5", "6", "7", "8", "9"]

	}
}
