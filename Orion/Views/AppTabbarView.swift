//
//  AppTabbarView.swift
//  Orion
//
//  Created by Anil Solanki on 24/09/22.
//

import SwiftUI

struct AppTabbarView: View {

	@EnvironmentObject var observedUser : ObservedUser
	@EnvironmentObject var appSettings : AppSettings
	@EnvironmentObject var router : Router
	@AppStorage(.appTintOption, store: .standard) var tintOption : Int = 0

	var body: some View {
		TabView(selection: $router.currentTab) {
			NavigationStack(path: $router.HOME_NAV_PATH) {
				HomeView()
					.navBar(with: observedUser.loggedInUser.displayName)
					.navigationDestination(for: Destination.self) { destination in
						desinationView(destination).environmentObject(router)
					}
			}
			.tabItem {
				Label("Home", systemImage: "house.fill")
					.imageScale(.small)
			}
			.tag(0)

			NavigationStack(path: $router.NEWS_NAV_PATH) {
				NewsCategoryListView()
					.navBar(with: "News on Reddit")
					.toolbarBackground(.visible, for: .tabBar)
					.navigationBarTitleDisplayMode(.inline)
					.navigationDestination(for: Destination.self) { destination in
						desinationView(destination).environmentObject(router)
					}
			}
			.tabItem {
				Label("News", systemImage: "newspaper.fill")
					.imageScale(.small)
			}
			.tag(1)

//			NavigationStack(path: $router.SCROLLER_NAV_PATH) {
//				ScrollerRootView()
//					.navBar(with: "Scroller")
//					.toolbarBackground(.visible, for: .tabBar)
//					.navigationBarTitleDisplayMode(.inline)
//					.navigationDestination(for: Destination.self) { destination in
//						desinationView(destination).environmentObject(router)
//					}
//			}
//			.tabItem {
//				Label("Scroller", systemImage: "square.stack.fill")
//					.imageScale(.small)
//			}
//			.tag(2)

			NavigationStack(path: $router.SEARCH_NAV_PATH) {
				SearchView()
					.navBar(with: "Search")
					.navigationDestination(for: Destination.self) { destination in
						desinationView(destination).environmentObject(router)
					}
			}
			.tabItem {
				Label("Search", systemImage: "magnifyingglass")
					.imageScale(.small)
			}
			.tag(2)

			NavigationStack(path: $router.SETTINGS_NAV_PATH) {
				SettingView()
					.navBar(with: "Settings")
					.navigationDestination(for: Destination.self) { destination in
						desinationView(destination).environmentObject(router)
					}
			}
			.tabItem {
				Label("Settings", systemImage: "gear")
					.imageScale(.small)
			}
			.tag(3)
		}
	}


	@ViewBuilder
	private func desinationView(_ destination: Destination) -> some View {
		//print(destination)
		switch destination {
		case .All:
			SharedPostListView(listType: .all)
		case .HOME:
			SharedPostListView(listType: .custom(""))
		case .POPULAR:
			SharedPostListView(listType: .popular)
		case .Custom(let name):
			SharedPostListView(listType: .custom(name))
		case .Subreddit(let name):
			SharedPostListView(listType: .subreddit(name))
		case .UserSharedPostList(let type):
			SharedPostListView(listType: type)
		case .User(let name):
			UserView(username: name)
		case .MyCommunities:
			MyCommunitiesListView()
		case .SubredditPage(let name):
			CommunityDetailView(name: name)
		case .UserPostList(let name):
			UserPostListView(username: name)
		case .UserUpvoteList(let name):
			UpvotedPostListView(username: name)
		case .SavedPosts(let name):
			SavedPostListView(username: name)
		case .CustomFeedView(let name):
			UserCustomFeedListView(username: name)
		case .FullSearchUser(let query):
			FullSearchUserView(query: query)
		case .FullSearchSubreddit(let query):
			FullSearchSubredditView(query: query)
		case .FullSearchPostView(let query):
			FullSearchPostView(query: query)
		case .DiscoverCommunity:
			DiscoverComListView()
		case .DiscoverDefaultList(let query):
			DiscoverSubredditListView(query: query)
		case .ContentFilterView:
			ContentFilterView()
		case .AccountList:
			AccountsView()
		case .General:
			GeneralSettingView()
		case .Appearance:
			AppearenceView()
		case .AppLock:
			AppLockView()
		case .AboutView:
			AboutView()
		case .UserProfile:
			if observedUser.loggedInUser.isAnonymous {
				Text("You are Anonymous. Please Login to View.")
			} else {
				UserView(username: observedUser.loggedInUser.displayName)
			}
		case .PostDetail(let viewModel):
			PostDetailView(postViewModel: viewModel)
		case .TipView:
			Text("")
		case .TrophyListView(let username):
			TrophyListView(username: username)
		case .CustomFeedOther(let username):
			OtherCustomFeedView(username: username)
		case .ModeratorsView(let name):
			ModeratorsView(name: name)
		case .RulesView(let name):
			RulesView(name: name)
		case .SubredditAboutView(let text):
			SubredditAboutView(text: text)
		case .SwipeView(let name):
			SwipeView(communityName: name)
		default:
			Text("This is an error.\nContact Developer of this App.")
		}
	}
}

struct AppTabbarView_Previews: PreviewProvider {
	static var previews: some View {
		AppTabbarView()
	}
}

extension View {
	func navBar(with title: String) -> some View {
		modifier(navigationCustomBar(title: title))
	}
}

struct navigationCustomBar: ViewModifier {
	var title: String
	func body(content: Content) -> some View {
		content
			.navigationTitle(title)
			.navigationBarTitleDisplayMode(.inline)
			.toolbarBackground(.visible, for: .tabBar)
	}
}
