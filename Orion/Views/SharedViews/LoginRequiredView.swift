//
//  LoginRequiredView.swift
//  Orion
//
//  Created by Anil Solanki on 02/10/22.
//

import SwiftUI

struct LoginRequiredView: View {

	@EnvironmentObject var observedUser : ObservedUser

	var body: some View {
		VStack(alignment: .center, spacing: 3) {
			Image("logo")
				.resizable()
				.scaledToFit()
				.frame(height: 80, alignment: .center)
				.cornerRadius(12)
				.padding(.bottom, 10)
			Text("Login Required").font(.headline).foregroundColor(.secondary)
			Text("To continue, you need to login with a Reddit account.").font(.subheadline).foregroundColor(.secondary).multilineTextAlignment(.center)
			Button("Login") {
				observedUser.performLogin()
			}
			.buttonStyle(BorderedButtonStyle())
			.tint(.accentColor)
			.padding(.vertical, 10)
		}
		.padding()
		.presentationDetents([.medium])
	}
}

struct LoginRequiredView_Previews: PreviewProvider {
    static var previews: some View {
        LoginRequiredView()
    }
}
