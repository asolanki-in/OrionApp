//
//  CommentReplyView.swift
//  Orion
//
//  Created by Anil Solanki on 07/03/22.
//

import SwiftUI

struct CommentReplyView: View {
    
    @State var text: String = ""
    let placeholder: String = "Tap here to start writing comment"
    
    let comment: CommentNode?
    
    @Environment(\.presentationMode) private var presentationMode
    @EnvironmentObject var postModel : PostViewModel

    var body: some View {
        NavigationView {
            VStack(alignment: .leading) {
                ZStack(alignment: .topLeading) {
                    if text.isEmpty {
                        Text(placeholder)
                            .foregroundColor(Color(.label))
                            .padding(.top, 10)
                            .padding(.horizontal)
                    }
                    TextEditor(text: $text)
                        .opacity(text.isEmpty ? 0.7 : 1)
                        .padding(.horizontal)
                }
                .overlay(RoundedRectangle(cornerRadius: 6).stroke(Color(.systemGray5), lineWidth: 1.0))
                .padding()
                
                
                if let comment = comment {
                    Spacer()
                    Text("You are Replying to:")
                        .font(.callout)
                        .foregroundColor(.secondary)
                        .padding(.horizontal)
                    VStack(alignment: .leading, spacing: 0) {
                        Divider().padding(.bottom, 10)
                        AuthorView(comment: comment.data).padding(.horizontal, 10).padding(.vertical, 5)
                        if let markdown = comment.data.markdown {
                            Text(markdown).font(.system(size: 15)).fixedSize(horizontal: false, vertical: true).padding(.horizontal, 10)
                                .lineLimit(5)
                        } else {
                            Text("Deleted comment").font(.system(size: 15)).foregroundColor(.gray).padding(.horizontal, 10)
                        }
                        Divider().padding(.top, 10)
                    }
                }
            }
            .navigationTitle("Enter Comment")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: actionDone) {
                        Text("Submit")
                    }
                }
                
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(action: actionCancel) {
                        Text("Cancel")
                    }
                }
            }
        }
    }
    
    @ViewBuilder private func AuthorView(comment: Comment) -> some View {
        if let author = comment.author {
            HStack(alignment: .center, spacing: 5) {
                AsyncImageView(url: profileImage,
							   size: .init(width: 26, height: 26),
							   ratio: .fill)
                    .clipShape(Circle())
                Text(author).font(.footnote).fontWeight(.bold).foregroundColor(.secondary)
                Text(" · \(comment.createdUtc?.timeAgoDisplay() ?? "na") · ")
                    .font(.footnote)
                    .foregroundColor(.secondary)
                HStack(alignment: .center, spacing: 0) {
                    Image(systemName: "arrow.up")
                    Text("\(comment.score ?? 0) ")
                }
                .font(.footnote)
            }
        } else {
            Text("Deleted User").font(.footnote)
        }
    }

    var profileImage : URL? {
        if let profile = comment?.data.profileImage {
            return URL(string: profile)
        }
        return URL(string: "https://www.redditstatic.com/avatars/avatar_default_02_545452.png")
    }
    
    private func actionDone() {
        if let comment = comment {
            self.postModel.addComment(text: self.text, node: comment)
        } else {
            self.postModel.addComment(text: self.text, node: nil)
        }
        self.dismissAction()
    }
    
    private func actionCancel() {
        self.dismissAction()
    }
    
    private func dismissAction() {
        self.presentationMode.wrappedValue.dismiss()
    }

}

//struct CommentReplyView_Previews: PreviewProvider {
//    static var previews: some View {
//            CommentReplyView()
//    }
//}
