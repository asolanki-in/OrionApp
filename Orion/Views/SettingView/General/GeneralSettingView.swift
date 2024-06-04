//
//  GeneralSettingView.swift
//  Orion
//
//  Created by Anil Solanki on 04/02/23.
//

import SwiftUI

struct GeneralSettingView: View {

	enum SortSheet: Identifiable {
   case Post
   case Subreddit
   case Comment
   case Search
   case News

   var id: Int {
	 hashValue
   }
 }

 @EnvironmentObject var settings : AppSettings
 @State var activeSheet : SortSheet?

 var body: some View {
   List {
	 Section(header: Text("Default Sorting")) {
	   Button(action: actionPostSort) {
		 HStack {
		   Text("Posts")
		   Spacer()
		   Text(settings.postDefaultSort.displayName).foregroundColor(.secondary)
		 }
	   }
	   .buttonStyle(PlainButtonStyle())

	   Button(action: actionSubredditSort) {
		 HStack {
		   Text("Community")
		   Spacer()
		   Text(settings.subredditDefaultSort.displayName).foregroundColor(.secondary)
		 }
	   }
	   .buttonStyle(PlainButtonStyle())

	   Button(action: actionNewsSort) {
		 HStack {
		   Text("News")
		   Spacer()
		   Text(settings.newsDefaultSort.displayName).foregroundColor(.secondary)
		 }
	   }
	   .buttonStyle(PlainButtonStyle())

	   Button(action: actionCommentSort) {
		 HStack {
		   Text("Comments")
		   Spacer()
		   Text(settings.commentDefaultSort.displayName).foregroundColor(.secondary)
		 }
	   }
	   .buttonStyle(PlainButtonStyle())

	   Button(action: actionSearchSort) {
		 HStack {
		   Text("Search")
		   Spacer()
		   Text(settings.searchDefaultSort.displayName).foregroundColor(.secondary)
		 }
	   }
	   .buttonStyle(PlainButtonStyle())
	 }

	 Section(header: Text("Links")) {
//        Picker(selection: $settings.linkOpenOption, label: Text("Open Links in")) {
//          ForEach(LinkOpenOption.allCases, id: \.self) { option in
//            Text(option.rawValue).font(.footnote)
//          }
//        }
	   Toggle("Reader Mode Always On", isOn: $settings.isReaderModeEnable)
	 }
   }
   .navigationTitle("General")
   .navigationBarTitleDisplayMode(.inline)
   .sheet(item: $activeSheet) { item in
	 switch item {
	 case .Post:
		 FilterView(filterItem: $settings.postDefaultSort, stubs: Sort.postFilterStubData)
	 case .Subreddit:
		 FilterView(filterItem: $settings.subredditDefaultSort, stubs: Sort.postFilterStubData)
	 case .Comment:
		 FilterView(filterItem: $settings.commentDefaultSort, stubs: Sort.commentstubs)
	 case .Search:
		 FilterView(filterItem: $settings.searchDefaultSort, stubs: Sort.searchstubs)
	 case .News:
		 FilterView(filterItem: $settings.newsDefaultSort, stubs: Sort.postFilterStubData)
	 }
   }
 }

 private func actionPostSort() {
   self.activeSheet = .Post
 }

 private func actionSubredditSort() {
   self.activeSheet = .Subreddit
 }

 private func actionCommentSort() {
   self.activeSheet = .Comment
 }

 private func actionSearchSort() {
   self.activeSheet = .Search
 }

 private func actionNewsSort() {
   self.activeSheet = .News
 }
}

struct GeneralSettingView_Previews: PreviewProvider {
    static var previews: some View {
        GeneralSettingView()
    }
}
