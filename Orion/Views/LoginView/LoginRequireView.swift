//
//  LoginRequireView.swift
//  Orion
//
//  Created by Anil Solanki on 06/11/22.
//

import SwiftUI

struct LoginRequireView: View {
    var body: some View {
		VStack(alignment: .center) {
			Image("logo")
			Text("Login Required").font(.title)
		}
    }
}

struct LoginRequireView_Previews: PreviewProvider {
    static var previews: some View {
		LoginRequireView().previewLayout(.sizeThatFits)

    }
}
