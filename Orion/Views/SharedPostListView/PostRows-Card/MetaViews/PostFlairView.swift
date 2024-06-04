//
//  PostFlairView.swift
//  OrionBeta
//
//  Created by Anil Solanki on 09/08/22.
//

import SwiftUI
import SDWebImageSwiftUI

struct PostFlairView: View {

	let post: Post

	var body: some View {
		Group {
			switch post.linkFlairType {
			case "richtext":
				if let flairs = post.linkFlairRichtext {
					HStack(spacing: 2) {
						ForEach(flairs, id:\.self) { flair in
							switch flair.e {
							case "text":
								Text(flair.t ?? "")
									.foregroundColor(post.postFlairTextColor)
									.font(.caption)
									.fontWeight(.medium)
							case "emoji":
								WebImage(url: URL(string: flair.u ?? ""))
									.resizable()
									.frame(width: 15, height: 15)
							default:
								EmptyView()
							}
						}
					}
					.padding(EdgeInsets(top: 2, leading: 6, bottom: 2, trailing: 6))
					.background(postFlairBackgroundColor)
					.clipShape(Capsule())
				}
			case "text":
				if let text = post.linkFlairText {
					Text(text)
						.foregroundColor(postFlairTextColor)
						.font(.caption)
						.fontWeight(.medium)
						.padding(EdgeInsets(top: 2, leading: 6, bottom: 2, trailing: 6))
						.background(postFlairBackgroundColor)
						.clipShape(Capsule())
				}
			default:
				EmptyView()
			}
		}
		.padding(EdgeInsets(top: 0, leading: 15, bottom: 10, trailing: 15))
	}

	//MARK: Flairs
	var postFlairTextColor: Color {
		if let textColor = post.linkFlairTextColor, textColor == "dark" {
			return .black
		}
		return .white
	}

	var postFlairBackgroundColor: Color {
		if let textColor = post.linkFlairBackgroundColor, textColor.isEmpty == false {
			if textColor != "transparent" {
				return Color(hex: textColor)
			}
		}
		return Color(.systemGray5)
	}
}

//struct PostFlairView_Previews: PreviewProvider {
//	static var previews: some View {
//		PostFlairView()
//	}
//}
