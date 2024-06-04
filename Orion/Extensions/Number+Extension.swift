//
//  Number+Extension.swift
//  Orion
//
//  Created by Anil Solanki on 20/11/22.
//

import Foundation

extension Int {
	func displayFormat() -> String? {
		let numberFormatter = NumberFormatter()
		numberFormatter.numberStyle = .decimal
		return numberFormatter.string(from: NSNumber(value:self))
	}
}
