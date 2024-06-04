//
//  RulesView.swift
//  Orion
//
//  Created by Anil Solanki on 22/10/20.
//

import SwiftUI

struct RulesView: View {

	@StateObject var observed = Observed()
	@State var viewAppear = true
	let name: String

	var body: some View {
		VStack {
			if observed.requestRunning {
				LoaderView()
			} else {
				if observed.rules.count > 0 {
					List {
						ForEach(observed.rules, content: RuleRow.init)
					}
				} else {
					Text("No Rules Found")
				}
			}
		}
		.navigationBarTitleDisplayMode(.inline)
		.navigationTitle("Rules")
		.task { didAppear() }
		.toolbarBackground(.visible, for: .navigationBar)
	}

	private func didAppear() {
		if viewAppear {
			observed.loadRules(prefix: name)
		}
		viewAppear = false
	}
}

struct RulesView_Previews: PreviewProvider {
	static var previews: some View {
		RulesView(name: "")
	}
}
