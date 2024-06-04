//
//  UserImageView.swift
//  Orion
//
//  Created by Anil Solanki on 27/11/22.
//

import SwiftUI

struct UserImageView: View {

	let user: User
	@Environment(\.colorScheme) var colorScheme

	var body: some View {
		VStack(alignment: .center) {
			AsyncImage(url: user.profileImage) { phase in
				switch phase {
				case .empty:
					Color(.systemGray6)
						.frame(width: 150, height: 150)
				case .success(let image):
					image.resizable()
						.aspectRatio(contentMode: .fit)
						.frame(maxWidth: 150, maxHeight: 150)
						.shadow(color: .white, radius: 1)
				case .failure:
					Image(systemName: "photo")
				@unknown default:
					EmptyView()
				}
			}

			Text(user.displayName).bold()
				.font(.title2)
				.foregroundColor(.primary)

			if let verified = user.verifiedEmail, verified == true {
				HStack(alignment: .center, spacing: 3) {
					Image(systemName: "checkmark.seal.fill")
						.foregroundColor(.accentColor)
						.imageScale(.medium)
					Text("email verified")
						.foregroundColor(.secondary)
				}
			}
		}
		.frame(width: UIScreen.screenWidth - 40, alignment: .center)
		.padding(.bottom, 10)
	}
}

