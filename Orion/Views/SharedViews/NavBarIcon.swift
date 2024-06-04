//
//  NavBarIcon.swift
//  Orion
//
//  Created by Anil Solanki on 01/10/22.
//

import SwiftUI

struct NavBarIcon: View {
	let systemName: String
	var body: some View {
		Image(systemName: systemName).imageScale(.large).symbolRenderingMode(.hierarchical)
	}
}

struct NavBarIcon_Previews: PreviewProvider {
    static var previews: some View {
        NavBarIcon(systemName: "")
    }
}
