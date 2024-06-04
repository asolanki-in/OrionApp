//
//  TempImageZoom.swift
//  OrionBeta
//
//  Created by Anil Solanki on 13/08/22.
//

import SwiftUI

struct TempImageZoom: View {

	@GestureState var scale: CGFloat = 1.0

    var body: some View {
		VStack {
			Text("⚠️").font(.largeTitle) + Text("\nLogin required")
		}
    }
}

struct TempImageZoom_Previews: PreviewProvider {
    static var previews: some View {
        TempImageZoom()
    }
}
