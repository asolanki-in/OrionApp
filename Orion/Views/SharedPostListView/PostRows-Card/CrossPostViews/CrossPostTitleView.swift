//
//  CrossPostTitleView.swift
//  OrionBeta
//
//  Created by Anil Solanki on 21/08/22.
//

import SwiftUI

struct CrossPostTitleView: View {
	let title: String
    var body: some View {
		Text(title).foregroundColor(.primary)
			.fixedSize(horizontal: false, vertical: true)
			.padding(EdgeInsets(top: 0, leading: 15, bottom: 10, trailing: 15))
    }
}

struct CrossPostTitleView_Previews: PreviewProvider {
    static var previews: some View {
        CrossPostTitleView(title: "")
    }
}
