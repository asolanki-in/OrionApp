//
//  ModeratorRow.swift
//  Orion
//
//  Created by Anil Solanki on 10/06/21.
//

import SwiftUI

struct ModeratorRow: View {
    let name: String
    let flairString: String?
    var body: some View {
        HStack(alignment: .center, spacing: 10) {
            Text(name).font(.title3)
//            if let flair = flairString, flair.isEmpty == false {
//                Text(flair)
//                    .font(.subheadline)
//                    .foregroundColor(.primary)
//                    .padding(.horizontal, 5)
//                    .padding(.vertical, 2)
//                    .background(Color(.systemGray4))
//                    .clipShape(Capsule())
//            }
        }
        .padding(.vertical, 6)
    }
}

struct ModeratorRow_Previews: PreviewProvider {
    static var previews: some View {
        ModeratorRow(name: "", flairString: "")
    }
}
