//
//  KeywordAddView.swift
//  Orion
//
//  Created by Anil Solanki on 03/12/22.
//

import SwiftUI

struct KeywordAddView: View {

	@Environment(\.managedObjectContext) private var viewContext
	@Environment(\.presentationMode) var presentationMode

	let type: Int16
	@Binding var contentFilter : FetchRequest<ContentFilterEntity>.Configuration

	enum Field {
		case keyword
	}

	@State private var usedWords = [String]()
	@State private var newWord = ""
	@FocusState private var focusedField: Field?

	var body: some View {
		NavigationStack {
			List {
				Section {
					TextField("Enter your keyword", text: $newWord)
						.focused($focusedField, equals: .keyword)
				}

				Section {
					ForEach(usedWords, id: \.self) { word in
						Text(word)
					}
				}
			}
			.toolbar(.visible, for: .navigationBar)
			.navigationBarTitleDisplayMode(.inline)
			.navigationTitle("type")
			.toolbar {
				ToolbarItem(placement: .navigationBarTrailing) {
					Button(action: {
						presentationMode.wrappedValue.dismiss()
					}) {
						Text("Done")
					}
				}
			}
			.submitLabel(.done)
			.onSubmit(addNewWord)
			.textInputAutocapitalization(.never)
		}
	}

	func addNewWord() {
		let keyword = newWord.lowercased().trimmingCharacters(in: .whitespacesAndNewlines)
		guard keyword.count > 0 else { return }
		withAnimation {
			usedWords.insert(keyword, at: 0)
		}
		newWord = ""
		createContentFilter(type: type, keyword: keyword)
		DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
			self.focusedField = .keyword
		}
	}

	private func createContentFilter(type: Int16, keyword: String) {
		Task {
			await viewContext.perform {
				let contentFilter = ContentFilterEntity(context: viewContext)
				contentFilter.keyword = keyword
				contentFilter.type = type
				contentFilter.id = UUID()
			}

			try? viewContext.save()
		}
	}
}
