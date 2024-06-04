//
//  Post.swift
//  Orion
//
//  Created by Anil Solanki on 01/10/22.
//

import Foundation
import UIKit.UIScreen
import SwiftUI
import HTMLEntities

class Post: Decodable, Identifiable, ObservableObject {

	let service = PostService()

	enum PostType {
		case LINK
		case VIDEO
		case IMAGE
		case TEXT
		case GIF
		case GALLERY
		case STREAMABLE
		case YOUTUBE
		case CROSSPOST
	}

	var id = UUID().uuidString
	var idString: String
	let name: String
	let title : String
	let domain: String
	let postHint: String?
	let thumbnail: String?
	let url: String?
	let author: String
	let preview: Preview?
	let subreddit : Subreddit
	let created: Date
	var ups: Int
	var downs: Int
	let commentCount: Int
	var likes: Bool?
	let awards: [Award]?
	let awardCount: Int
	let rpan : RPANSource?
	let media : Media?
	let isGallery: Bool?
	let galleryData: GalleryData?
	let mediaMetaData: [String : MediaMetadata]?
	let selfText : String?
	let saved: Bool
	let permalink: String
	let archived: Bool

	//Author Flair Compute
	let authorFlairBackgroundColor : String? //transparent or #0a0a0a
	let authorFlairTextColor: String?
	let authorFlairRichtext : [Flair]?
	let authorFlairText: String? //simple or rich both
	let authorFlairType : String? //richtext or text

	//Post Flair Compute
	let linkFlairBackgroundColor : String? //transparent or #0a0a0a
	let linkFlairTextColor: String? //dark and other
	let linkFlairRichtext : [Flair]?
	let linkFlairText: String? //simple or rich both
	let linkFlairType : String? //richtext or text

	let stickied : Bool
	let crossPost : [Post]?


	//MARK: Other Vars which computed when data is available
	var galleryMedia = [SingleMedia]()
	var timeAgo: String = ""
	var AWARD_URLs = [String]()
	var type : PostType = .LINK
	var HQ_IMAGE_URL: URL?
	var LQ_IMAGE_URL: URL?
	var VIDEO_URL: URL?
	var GIF_URL: URL?
	var imageSize: CGSize = CGSize(width: 300, height: 200)
	var youtubeVideoId = ""
	var videoLoop = false
	var markdownString : AttributedString?
	var markdownStringFull: AttributedString?

	var postFlairBackgroundColor: Color {
		if let textColor = self.linkFlairBackgroundColor, textColor.isEmpty == false {
			if textColor != "transparent" {
				return Color(hex: textColor)
			}
		}
		return Color(.secondarySystemFill)
	}

	var postFlairTextColor: Color {
		if let textColor = self.linkFlairTextColor, textColor == "dark" {
			return .black
		}
		return .white
	}

	enum CodingKeys: String, CodingKey {
		case name, title, domain, thumbnail
		case url, preview, author, ups, downs
		case created, media, likes, stickied, saved
		case permalink, archived
		case idString 					= "id"
		case postHint 					= "post_hint"
		case subreddit 					= "sr_detail"
		case commentCount 				= "num_comments"
		case awards 					= "all_awardings"
		case awardCount 				= "total_awards_received"
		case rpan 						= "rpan_video"
		case isGallery 					= "is_gallery"
		case galleryData 				= "gallery_data"
		case mediaMetaData 				= "media_metadata"
		case authorFlairBackgroundColor = "author_flair_background_color"
		case authorFlairTextColor 		= "author_flair_text_color"
		case authorFlairRichtext 		= "author_flair_richtext"
		case authorFlairType 			= "author_flair_type"
		case authorFlairText 			= "author_flair_text"
		case linkFlairBackgroundColor 	= "link_flair_background_color"
		case linkFlairTextColor 		= "link_flair_text_color"
		case linkFlairRichtext 			= "link_flair_richtext"
		case linkFlairType 				= "link_flair_type"
		case linkFlairText 				= "link_flair_text"
		case crossPost 					= "crosspost_parent_list"
		case selfText 					= "selftext"
	}

	required init(from decoder: Decoder) throws {
		let container = try decoder.container(keyedBy: CodingKeys.self)
		self.idString = try container.decode(String.self, forKey: .idString)
		self.name = try container.decode(String.self, forKey: .name)
		self.title = try container.decode(String.self, forKey: .title)
		self.domain = try container.decode(String.self, forKey: .domain)
		self.thumbnail = try container.decodeIfPresent(String.self, forKey: .thumbnail)
		self.url = try container.decodeIfPresent(String.self, forKey: .url)
		self.preview = try container.decodeIfPresent(Preview.self, forKey: .preview)
		self.author = try container.decode(String.self, forKey: .author)
		self.ups = try container.decode(Int.self, forKey: .ups)
		self.downs = try container.decode(Int.self, forKey: .downs)
		self.created = try container.decode(Date.self, forKey: .created)
		self.media = try container.decodeIfPresent(Media.self, forKey: .media)
		self.likes = try container.decodeIfPresent(Bool.self, forKey: .likes)
		self.archived = try container.decode(Bool.self, forKey: .archived)
		self.stickied = try container.decode(Bool.self, forKey: .stickied)
		self.postHint = try container.decodeIfPresent(String.self, forKey: .postHint)
		self.subreddit = try container.decode(Subreddit.self, forKey: .subreddit)
		self.commentCount = try container.decode(Int.self, forKey: .commentCount)
		self.awards = try container.decodeIfPresent([Award].self, forKey: .awards)
		self.awardCount = try container.decode(Int.self, forKey: .awardCount)
		self.rpan = try container.decodeIfPresent(RPANSource.self, forKey: .rpan)
		self.isGallery = try container.decodeIfPresent(Bool.self, forKey: .isGallery)
		self.galleryData = try container.decodeIfPresent(GalleryData.self, forKey: .galleryData)
		self.mediaMetaData = try container.decodeIfPresent([String : MediaMetadata].self, forKey: .mediaMetaData)
		self.authorFlairBackgroundColor = try container.decodeIfPresent(String.self, forKey: .authorFlairBackgroundColor)
		self.authorFlairTextColor = try container.decodeIfPresent(String.self, forKey: .authorFlairTextColor)
		self.authorFlairRichtext = try container.decodeIfPresent([Flair].self, forKey: .authorFlairRichtext)
		self.authorFlairType = try container.decodeIfPresent(String.self, forKey: .authorFlairType)
		self.authorFlairText = try container.decodeIfPresent(String.self, forKey: .authorFlairText)
		self.linkFlairBackgroundColor = try container.decodeIfPresent(String.self, forKey: .linkFlairBackgroundColor)
		self.linkFlairTextColor = try container.decodeIfPresent(String.self, forKey: .linkFlairTextColor)
		self.linkFlairRichtext = try container.decodeIfPresent([Flair].self, forKey: .linkFlairRichtext)
		self.linkFlairType = try container.decodeIfPresent(String.self, forKey: .linkFlairType)
		self.linkFlairText = try container.decodeIfPresent(String.self, forKey: .linkFlairText)
		self.crossPost = try container.decodeIfPresent([Post].self, forKey: .crossPost)
		self.selfText = try container.decodeIfPresent(String.self, forKey: .selfText)
		self.saved = try container.decode(Bool.self, forKey: .saved)
		self.permalink = "https://www.reddit.com\(try container.decode(String.self, forKey: .permalink))"

		self.parseContent()
		self.parseAwards()
		self.timeAgo = self.created.timeAgoDisplay()
		self.loadAttributedString()
	}

	private func loadAttributedString() {
		if let mdtext = self.selfText?.htmlUnescape(), mdtext.isEmpty == false {
			do {
				let trimmedString = mdtext.trimmingCharacters(in: .whitespacesAndNewlines)
					.replacingOccurrences(of: "\\n{2,}", with: "\n\n", options: .regularExpression)
				let inline = AttributedString.MarkdownParsingOptions(interpretedSyntax: .inlineOnlyPreservingWhitespace)
				let full = AttributedString.MarkdownParsingOptions(interpretedSyntax: .full)
				self.markdownString = try AttributedString(markdown: trimmedString, options: full)
				self.markdownStringFull = try AttributedString(markdown: trimmedString, options: inline)
			} catch {
				print(error.localizedDescription)
			}
		}
	}

	private func parseAwards() {
		if self.awardCount > 0, let awards = self.awards {
			for award in awards {
				if let filteredIcon = award.icons.first(where: { $0.width == 32 }) {
					self.AWARD_URLs.append(filteredIcon.url)
				} else if let first = award.icons.first {
					self.AWARD_URLs.append(first.url)
				} else {
					self.AWARD_URLs.append(award.largeIcon)
				}

				if self.AWARD_URLs.count == 3 {
					break;
				}
			}
		}
	}
}

extension Post {
	private func parseImageContent(url: URL) {
		switch url.pathExtension {
		case "jpeg", "jpg", "png":
			self.type = .IMAGE
		case "gif", "gifv", "webp":
			self.type = .GIF
			self.GIF_URL = url
			self.videoLoop = true
		case "webm", "mp4":
			self.type = .VIDEO
			self.VIDEO_URL = url
		default:
			type = .LINK
		}
		self.processImageResolutions()
	}

	private func parseGIFContent(url: URL) {
		switch url.pathExtension {
		case "jpeg", "jpg", "png":
			self.type = .IMAGE
		case "gif", "gifv", "webp":
			self.type = .GIF
			self.GIF_URL = url
			self.videoLoop = true
		case "webm", "mp4":
			self.type = .VIDEO
			self.VIDEO_URL = url
		default:
			if let hlsURL = self.preview?.redditVideoPreview?.hlsURL {
				type = .VIDEO
				VIDEO_URL = URL(string: hlsURL)
			} else {
				type = .LINK
			}
		}
		self.processImageResolutions()
	}

	func parseContent() {

		if let rpan = self.rpan {
			type = .VIDEO
			VIDEO_URL = URL(string: rpan.hlsURL)
			LQ_IMAGE_URL = URL(string: rpan.thumbnail)
			HQ_IMAGE_URL = URL(string: rpan.thumbnail)
			self.parseGalleryImages()
			return
		}

		if let gallery = self.isGallery, gallery == true {
			self.parseGalleryImages()
			if galleryMedia.count > 0 {
				type = .GALLERY
			} else {
				type = .LINK
			}
			return
		}

		if let count = self.crossPost?.count, count > 0 {
			type = .CROSSPOST
			self.parseImageHeightCrossPost(preview: self.preview?.images.first)
			return
		}

		guard let url = self.url, url.isEmpty == false else {
			type = .TEXT
			return
		}

		guard let baseURL = URL(string: url), let host = baseURL.host else {
			type = .TEXT
			return
		}

		//print("[URL] \(host) ---- \(self.domain) ---- \(url)")
		if baseURL.pathExtension.lowercased() == "webm" {
			print("[WEBM] \(host) ---- \(self.domain) ---- \(baseURL.pathExtension)---- \(baseURL)")
		}

		switch host {
		case "i.redd.it":
			self.parseImageContent(url: baseURL)
			return
		case "i.reddituploads.com":
			self.parseImageContent(url: baseURL)
			return
		case "giphy.com":
			self.parseImageContent(url: baseURL)
			return
		case "www.giphy.com":
			self.parseImageContent(url: baseURL)
			return
		case "i.imgur.com":
			self.parseImageContent(url: baseURL)
			return
		case "imgur.com":
			self.parseImageContent(url: baseURL)
			if let _ = LQ_IMAGE_URL {
				self.type = .IMAGE
			}
			return
		case "i.bildgur.de":
			self.parseImageContent(url: baseURL)
			return
		case "v.redd.it", "v.reddituploads.com":
			self.type = .VIDEO
			if let media = self.media, let hlsURL = media.redditVideo?.hlsURL {
				self.VIDEO_URL = URL(string: hlsURL)
				self.processImageResolutions()
			}
			return
		case "gfycat.com":
			self.parseGIFContent(url: baseURL)
			return
		case "www.gfycat.com":
			self.parseGIFContent(url: baseURL)
			return
		case "redgifs.com":
			self.parseGIFContent(url: baseURL)
			return
		case "www.redgifs.com":
			self.parseGIFContent(url: baseURL)
			return
		case "streamable.com":
			type = .STREAMABLE
			self.VIDEO_URL = baseURL
			self.processImageResolutions()
			return
		case "youtu.be", "youtube.com", "youtube.co.uk", "www.youtube.com", "m.youtube.com":
			youtubeVideoId = baseURL.absoluteString.youtubeId ?? ""
			if youtubeVideoId.isEmpty == false {
				type = .YOUTUBE
				LQ_IMAGE_URL = URL(string: "https://img.youtube.com/vi/\(youtubeVideoId)/mqdefault.jpg")
				VIDEO_URL = baseURL
				imageSize = CGSize(width: UIScreen.screenWidth, height: UIScreen.screenWidth * 0.5625)
			} else {
				type = .LINK
			}
			return
		case "www.reddit.com":
			if self.domain.contains("self.") {
				type = .TEXT
				return
			} else if let rpan = self.rpan {
				type = .VIDEO
				VIDEO_URL = URL(string: rpan.hlsURL) ?? nil
				HQ_IMAGE_URL = URL(string: rpan.thumbnail) ?? nil
				LQ_IMAGE_URL = URL(string: rpan.thumbnail) ?? nil
				return
			}
		default:
			switch baseURL.pathExtension {
			case "jpeg", "jpg", "png":
				self.type = .IMAGE
			case "gif", "gifv", "webp":
				self.type = .GIF
				self.GIF_URL = baseURL
				self.videoLoop = true
			case "webm", "mp4":
				self.type = .VIDEO
				self.VIDEO_URL = baseURL
			default:
				type = .LINK
			}
			self.processImageResolutions()
			return
		}
	}

	private func parseGalleryImages() {
		if let gallerydata = self.galleryData, let mediadata = self.mediaMetaData {
			let _ = gallerydata.items.map { item in
				if let media = mediadata[item.mediaId], let res = media.p, res.count > 0 {
					let filteredResolution : [SingleMedia] = res.filter { $0.x > 400 }
					if let fi = filteredResolution.first {
						galleryMedia.append(SingleMedia(y: fi.y,
														x: fi.x,
														u: fi.u,
														gif: fi.gif,
														mp4: fi.mp4,
														caption: item.caption))
					} else {
						if let mediaS = media.s {
							galleryMedia.append(SingleMedia(y: mediaS.y,
															x: mediaS.x,
															u: mediaS.u,
															gif: mediaS.gif,
															mp4: mediaS.mp4,
															caption: item.caption))
						}
					}
				}
			}

			if let firstsource = galleryMedia.first {
				let height = UIScreen.screenWidth * CGFloat(firstsource.y) / CGFloat(firstsource.x)
				if height > UIScreen.screenHeight - 200 {
					imageSize = CGSize(width: UIScreen.screenWidth, height: UIScreen.screenHeight - 200)
				} else {
					imageSize = CGSize(width: UIScreen.screenWidth, height: height)
				}
			}
		}
	}


	private func processImageResolutions() {
		if let preview = self.preview, let image = preview.images.first {
			self.HQ_IMAGE_URL = URL(string: image.source.url)
			if image.resolutions.count > 0 {
				let filteredResolution : [Source] = image.resolutions.filter { $0.width > 400 }
				if let filteredImage = filteredResolution.first {
					self.LQ_IMAGE_URL = URL(string: filteredImage.url)
				} else {
					self.LQ_IMAGE_URL = URL(string: image.source.url)
				}
			} else {
				self.LQ_IMAGE_URL = URL(string: image.source.url)
			}
			self.calculateImageSize(source: image.source)
		} else {
			//self.HQ_IMAGE_URL = URL(string: self.url ?? "")
			//self.LQ_IMAGE_URL = URL(string: self.url ?? "")
		}
	}

	private func calculateImageSize(source: Source) {
		let height = UIScreen.screenWidth * CGFloat(source.height) / CGFloat(source.width)
		if height > UIScreen.screenHeight - 200 {
			imageSize = CGSize(width: UIScreen.screenWidth, height: UIScreen.screenHeight - 200)
		} else {
			imageSize = CGSize(width: UIScreen.screenWidth, height: height)
		}
	}

	private func parseImageHeightCrossPost(preview: PreviewImage?) {
		if let source = preview?.source {
			let screenWidth = UIScreen.screenWidth - 30
			if self.type == .YOUTUBE {
				imageSize = CGSize(width: screenWidth, height: screenWidth * 0.5625)
			} else {
				let height = screenWidth * CGFloat(source.height) / CGFloat(source.width)
				if height > UIScreen.screenHeight - 200 {
					imageSize = CGSize(width: screenWidth, height: UIScreen.screenHeight - 200)
				} else {
					imageSize = CGSize(width: screenWidth, height: height)
				}
			}
		}
	}
}

