//
//  NewsCategoryRow.swift
//  Orion
//
//  Created by Anil Solanki on 20/11/22.
//

import SwiftUI

struct NewsCategoryRow: View {

	let title: String
	let subtitle: String?
	let systemName: String
	let color: Color

    var body: some View {
		HStack(spacing: 20) {
			//Image(systemName: categories[index].descriptionMD)
			Image(systemName: systemName)
				.imageScale(.medium)
				.fontWeight(.bold)
				.foregroundColor(.white)
				.frame(width: 40, height: 40,  alignment: .center)
				.background(color)
				.cornerRadius(8)
				.overlay(RoundedRectangle(cornerRadius: 8).stroke(Color.systemGray6, lineWidth: 1))

			VStack(alignment: .leading) {
				Text(title).font(.body)
				Text(subtitle ?? "").font(.footnote).foregroundColor(.secondary)
			}
		}
		.padding(.vertical, 4)
    }
}
