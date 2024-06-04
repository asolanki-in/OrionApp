//
//  AwardRowView.swift
//  OrionBeta
//
//  Created by Anil Solanki on 29/07/22.
//

import SwiftUI

struct AwardRowView: View {
	let totalCount: Int
	let awardURLs : [String]
    var body: some View {
		HStack(alignment: .center, spacing: 6) {
			ForEach(awardURLs, id:\.self) { url in
				IconImageView(url: url, size: .init(width: 16, height: 16))
			}
			Text("\(totalCount) awards").font(.footnote).foregroundColor(.secondary)
		}
		.padding(EdgeInsets(top: 0, leading: 15, bottom: 10, trailing: 15))
    }
}

struct AwardRowViewDetail: View {
	let totalCount: Int
	let awardURLs : [String]
	var body: some View {
		HStack(alignment: .center, spacing: 6) {
			ForEach(awardURLs, id:\.self) { url in
				IconImageView(url: url, size: .init(width: 16, height: 16))
			}
			Text("\(totalCount) awards").font(.footnote).foregroundColor(.secondary)
		}
		.padding(EdgeInsets(top: 0, leading: 15, bottom: 0, trailing: 15))
	}
}

struct AwardRowView_Previews: PreviewProvider {
    static var previews: some View {
		AwardRowView(totalCount: 10, awardURLs: ["https://www.redditstatic.com/gold/awards/icon/gold_32.png", "https://www.redditstatic.com/gold/awards/icon/Faith_in_Humanity_Restored_32.png","https://www.redditstatic.com/gold/awards/icon/SnooClapping_32.png"])
    }
}
