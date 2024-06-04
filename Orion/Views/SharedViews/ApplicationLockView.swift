//
//  ApplicationLockView.swift
//  Orion
//
//  Created by Anil Solanki on 25/09/22.
//

import SwiftUI

struct ApplicationLockView: View {

	@EnvironmentObject var appSettings : AppSettings

	var body: some View {
		VStack {
			Button(action:self.appSettings.unlockApplication) {
				switch self.appSettings.bioMetricType {
				case .faceID:
					Label("Click Here to Unlock", systemImage: "faceid").labelStyle(VerticalIcon())
				case .touchID:
					Label("Click here to Unlock", systemImage: "touchid").labelStyle(VerticalIcon())
				default:
					Text("Unlock")
				}
			}
			.padding()
		}
	}

}

struct ApplicationLockView_Previews: PreviewProvider {
	static var previews: some View {
		ApplicationLockView()
	}
}

struct VerticalIcon: LabelStyle {
	func makeBody(configuration: Configuration) -> some View {
		VStack(alignment: .center, spacing: 5) {
			configuration.icon.font(.system(size: 40))
			configuration.title.font(.title3).fontWeight(.semibold)
		}
	}
}
