//
//  AppLockView.swift
//  Orion
//
//  Created by Anil Solanki on 24/12/22.
//

import SwiftUI

struct AppLockView: View {

	@EnvironmentObject var settings : AppSettings

	var body: some View {
		List {
			Section {
				switch settings.bioMetricType {
				case .touchID:
					Toggle("Touch Id", isOn: $settings.isAppLockEnable)
				case .faceID:
					Toggle("Face Id", isOn: $settings.isAppLockEnable)
				default:
					Text("Please enable lock from device settings.")
				}
			}
		}
		.navigationBarTitle("App Lock", displayMode: .inline)
	}
}

struct AppLockView_Previews: PreviewProvider {
	static var previews: some View {
		AppLockView()
	}
}
