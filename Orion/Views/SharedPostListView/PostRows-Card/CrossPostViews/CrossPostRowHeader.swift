//
//  CrossPostRowHeader.swift
//  OrionBeta
//
//  Created by Anil Solanki on 21/08/22.
//

import SwiftUI

struct CrossPostRowHeader: View {

	let post: Post

    var body: some View {
		HStack(alignment: .center, spacing: 12) {
			Text(post.subreddit.displayNamePrefixed).font(.footnote).foregroundColor(.secondary)
			Spacer()
			Text(post.timeAgo).font(.footnote).foregroundColor(.secondary)
		}
		.padding(EdgeInsets(top: 10, leading: 15, bottom: 5, trailing: 15))
    }
}

//struct CrossPostRowHeader_Previews: PreviewProvider {
//    static var previews: some View {
//        CrossPostRowHeader()
//    }
//}
