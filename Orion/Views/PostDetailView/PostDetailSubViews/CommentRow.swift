//
//  CommentRow.swift
//  Orion
//
//  Created by Anil Solanki on 17/02/22.
//

import SwiftUI
import MapKit

struct CommentRow: View {
    
    @State var comment: CommentNode
    @EnvironmentObject var postModel : PostViewModel
	@EnvironmentObject var observedUser : ObservedUser
	@EnvironmentObject var alertManager : AlertManager

    @State private var isLoading = false
    @State var upvoted : Bool
    @State var voteRunning: Bool = false
    @State var presentAddCommentView: Bool = false
    @State var presentArchivePopup: Bool = false
    
    init(comment: CommentNode) {
        self.comment = comment
        if let status = comment.data.upvoted {
            self.upvoted = status
        } else {
            self.upvoted = false
        }
    }


    var body: some View {
        Group {
            if let _ = comment.data.body {
                HStack(alignment: .center, spacing: 0) {
                    if comment.indent > 0 {
                        IndentView
                    }
                    CommentBody
                }
            } else {
                if let child = comment.data.children {
                    MoreView(children: child)
                }
            }
        }
        .padding(.leading, CGFloat(comment.indent * 6))
        .buttonStyle(PlainButtonStyle())
        .listRowSeparator(.hidden)
        .sheet(isPresented: $presentAddCommentView) {
            CommentReplyView(comment: comment)
        }
        .alert(isPresented: $presentArchivePopup) {
            Alert(title: Text("Can't Comment"),
                  message: Text("This Post is Archived and users can't comment on it."),
                  dismissButton: .cancel(Text("OK")))
        }

    }
    
        
    @ViewBuilder private func MoreView(children: [String]) -> some View {
        HStack(alignment: .center, spacing: 0) {
            if self.isLoading {
                if comment.indent > 0 { IndentView }
                VStack(alignment: .leading, spacing: 5) {
                    Divider().padding(.bottom, 10)
                    Text("Loading...").font(.footnote).padding(.horizontal, 10).foregroundColor(.secondary)
                    Divider().padding(.top, 10)
                }
            } else {
                if children.count > 0 {
                    if comment.indent > 0 { IndentView }
                    Button(action: actionMore) {
                        VStack(alignment: .leading, spacing: 5) {
                            Divider().padding(.bottom, 10)
                                if let count = comment.data.count, count > 0 {
                                    Text("\(count) More Reply").font(.footnote).padding(.horizontal, 10).foregroundColor(.accentColor)
                                } else {
                                    Text("\(comment.data.children?.count ?? 0) More Reply").font(.footnote).padding(.horizontal, 10).foregroundColor(.accentColor)
                                }
                            Divider().padding(.top, 10)
                        }
                    }
                    .buttonStyle(PlainButtonStyle())
                } else {
                    if comment.indent > 0 { IndentView }
                    VStack(alignment: .leading, spacing: 5) {
                        Divider().padding(.bottom, 10)
                        Button(action: actionContinue) {
                            Text("Continue...").font(.callout).fontWeight(.semibold).padding(.horizontal, 5).foregroundColor(.accentColor)
                        }
                        .buttonStyle(PlainButtonStyle())
                        Divider().padding(.top, 10)
                    }
                }
            }
        }
    }
    
    var profileImage : URL? {
        if let profile = comment.data.profileImage {
            return URL(string: profile)
        }
        return URL(string: "https://www.redditstatic.com/avatars/avatar_default_02_545452.png")
    }
    
    var IndentView : some View {
        RoundedRectangle(cornerRadius: 0)
            .foregroundColor(Color(.systemGray6))
            .frame(width: 2)
    }
        
    private func actionMore() {
        self.isLoading = true
        if let _ = comment.parent {
            Task.detached(priority: .background) {
                do {
                    let comments = try await postModel.moreReplies(aNode: comment,
																   linkId: postModel.post.name)
                    if let index = await postModel.getIndex(id: comment.data.id) {
                        await postModel.completedReplies(more: comments, startIndex: index)
                    }
                } catch {
                    await MainActor.run(body: {
                        self.isLoading = false
                    })
                }
            }
        } else {
            Task.detached(priority: .background) {
                do {
                    let comments = try await postModel.moreReplies(aNode: comment, linkId: postModel.post.name)
                    await postModel.completed(more: comments)
                } catch {
                    await MainActor.run(body: {
                        self.isLoading = false
                    })
                }
            }
        }
    }
    
    private func actionContinue() {
        if let parentId = self.comment.data.parentId {
            let jsonId = parentId.replacingOccurrences(of: "t1_", with: "")
            self.postModel.continueCommentsTapped(linkId: self.postModel.post.idString, commentId: jsonId)
        } else {
            self.postModel.continueCommentsTapped(linkId: self.postModel.post.idString, commentId: self.comment.parent?.data.id ?? "")
        }
    }

    //self.postModel.getMoreReplies(childCommentNode: comment, parent: parent)
    //self.postModel.getMoreComments(id: comment.data.id, children: comment.data.childrenString)


}

//struct CommentRow_Previews: PreviewProvider {
//    static var previews: some View {
//        CommentRow().previewLayout(.sizeThatFits)
//    }
//}


extension CommentRow {
    var CommentBody: some View {
        VStack(alignment: .leading, spacing: 0) {
            Divider().padding(.bottom, 10)
            AuthorView.padding(.horizontal, 10).padding(.vertical, 5)
            if let markdown = comment.data.markdown {
                Text(markdown).font(.system(size: 15)).fixedSize(horizontal: false, vertical: true).padding(.horizontal, 10)
            } else {
                Text("Deleted comment").font(.system(size: 15)).foregroundColor(.gray).padding(.horizontal, 10)
            }
            Divider().padding(.top, 10)
        }
    }
    
    var AuthorView : some View {
        if let author = comment.data.author {
            return AnyView(HStack(alignment: .center, spacing: 5) {
				AsyncImageView(url: profileImage,
							   size: .init(width: 26, height: 26),
							   ratio: .fill)
                    .clipShape(Circle())
                Text(author).font(.footnote).fontWeight(.bold).foregroundColor(.secondary)
                Text(" · \(comment.data.createdUtc?.timeAgoDisplay() ?? "na") · ")
                    .font(.footnote)
                    .foregroundColor(.secondary)
                HStack(alignment: .center, spacing: 0) {
                    Image(systemName: "arrow.up")
                    Text("\(comment.data.score ?? 0) ")
                }
                .font(.footnote)
                .foregroundColor(self.upvoted ? .purple : .secondary)
                Spacer()
                if self.voteRunning {
                    ProgressView()
                } else {
                    MoreButton.foregroundColor(.secondary)
                }
            })
        } else {
            return AnyView(Text("Deleted User").font(.footnote))
        }
    }
    
    
    var MoreButton : some View {
        Menu {
            Button(action: actionvote) {
                if comment.data.isUpvoted {
                    Label("Undo Upvote", systemImage: "arrow.up")
                } else {
                    Label("Upvote", systemImage: "arrow.up")
                }
            }
            
            Button(action: actionDownVote) {
                if let status = comment.data.upvoted, status == false {
                    Label("Undo Downvote", systemImage: "arrow.down")
                } else {
                    Label("Downvote", systemImage: "arrow.down")
                }
            }
            
            Button(action: actionReply) {
                Label("Reply", systemImage: "arrowshape.turn.up.left")
            }

            if let author = comment.data.author {
				NavigationLink(value: Destination.User(author)) {
					Label("u/\(author)", systemImage: "person")
				}
            }
        } label: {
            Image(systemName: "ellipsis").frame(width: 40, height: 30, alignment: .trailing)
        }
    }
    
    
    private func actionReply() {
        if observedUser.loggedInUser.isAnonymous {
			alertManager.LoginAlert()
        } else {
            if self.postModel.post.archived {
                self.presentArchivePopup.toggle()
            } else {
                self.presentAddCommentView.toggle()
            }
        }
    }

    func actionvote() {
		if observedUser.loggedInUser.isAnonymous {
			alertManager.LoginAlert()
        } else {
            self.voteRunning = true
            let vote: Int
            if let status = comment.data.upvoted {
                if status == true {
                    vote = 0
                } else {
                    vote = 1
                }
            } else {
                vote = 1
            }
            
            Task.detached(priority: .background) {
                if await postModel.upvoteOnComment(vote: vote, fullname: comment.data.name ?? "") {
                    switch vote {
                    case 1:
                        await updateUpvote(status: true)
                    case -1:
                        await updateUpvote(status: false)
                    default:
                        await updateUpvote(status: nil)
                    }
                }
            }
        }
    }
    
    func actionDownVote() {
		if observedUser.loggedInUser.isAnonymous {
			alertManager.LoginAlert()
		} else {
            self.voteRunning = true
            let vote: Int
            if let status = comment.data.upvoted {
                if status == true {
                    vote = -1
                } else {
                    vote = 0
                }
            } else {
                vote = -1
            }

            Task.detached(priority: .background) {
                if await postModel.upvoteOnComment(vote: vote, fullname: comment.data.name ?? "") {
                    switch vote {
                    case 1:
                        await updateUpvote(status: true)
                    case -1:
                        await updateUpvote(status: false)
                    default:
                        await updateUpvote(status: nil)
                    }
                }
            }
        }
    }
    
    @MainActor private func updateUpvote(status: Bool?) {
        self.comment.data.updateUpvote(to: status)
        if let status = status {
            self.upvoted = status
        } else {
            self.upvoted = false
        }
        self.voteRunning = false
    }

}
