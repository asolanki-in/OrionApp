//
//  LoaderView.swift
//  Orion
//
//  Created by Anil Solanki on 01/10/22.
//

import SwiftUI

struct LoaderView: View {
	var message: String = "LOADING"
	var font: Font = .footnote
    var body: some View {
		ProgressView { Text(message).font(font) }.controlSize(.regular)
	}
}

struct LoaderView_Previews: PreviewProvider {
    static var previews: some View {
        LoaderView()
    }
}
