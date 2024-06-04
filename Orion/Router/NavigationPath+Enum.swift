//
//  NavigationPath+Enum.swift
//  Orion
//
//  Created by Anil Solanki on 06/11/22.
//

import Foundation

enum Destination : Hashable {
	case All
	case HOME
	case POPULAR
	case Custom(String)
	case Subreddit(String)
	case User(String)
	case UserPostList(String)
	case UserUpvoteList(String)
	case SavedPosts(String)
	case CustomFeedView(String)
	case News(String)
	case MyCommunities
	case SubredditPage(String)
	case FullSearchSubreddit(String)
	case FullSearchUser(String)
	case FullSearchPostView(String)
	case DiscoverCommunity
	case DiscoverDefaultList(String)
	case ContentFilterView
	case AccountList
	case General
	case Appearance
	case UserProfile
	case AppLock
	case AboutView
	case PostDetail(PostViewModel)
	case TipView
	case TrophyListView(String)
	case CustomFeedOther(String)
	case ModeratorsView(String)
	case RulesView(String)
	case SubredditAboutView(AttributedString?)
	case UserSharedPostList(PostListType)
	case SwipeView(String)
}
