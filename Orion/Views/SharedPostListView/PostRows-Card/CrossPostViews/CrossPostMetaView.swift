//
//  CrossPostMetaView.swift
//  OrionBeta
//
//  Created by Anil Solanki on 21/08/22.
//

import SwiftUI

struct CrossPostMetaView: View {

	let post: Post

	var body: some View {
		HStack(alignment: .center, spacing: 12) {
			HStack(alignment: .center, spacing: 10) {
				Label("\(post.ups)", systemImage: "arrow.up").labelStyle(MetaLabel(spacing: 2))
				Label("\(post.commentCount)", systemImage: "bubble.right").labelStyle(MetaLabel(spacing: 2))
			}
			Spacer()
			Text("u/\(post.author)").font(.footnote).foregroundColor(.secondary)
		}
		.padding(EdgeInsets(top: 10, leading: 15, bottom: 10, trailing: 15))
	}
}

//struct CrossPostMetaView_Previews: PreviewProvider {
//    static var previews: some View {
//        CrossPostMetaView()
//    }
//}
