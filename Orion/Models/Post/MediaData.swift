//
//  MediaData.swift
//  OrionBeta
//
//  Created by Anil Solanki on 20/08/22.
//

import Foundation

struct Preview: Decodable {
	let images: [PreviewImage]
	let redditVideoPreview: RedditVideo?
	enum CodingKeys: String, CodingKey {
		case images
		case redditVideoPreview = "reddit_video_preview"
	}
}

struct PreviewImage: Decodable {
	let source: Source
	let resolutions: [Source]
	let variants : Variants?
}

struct Source: Decodable {
	let url: String
	let width, height: Int
}

// MARK: - Variants
struct Variants: Decodable {
	let gif: GIF?
	let mp4: GIF?
}

// MARK: - GIF
struct GIF: Decodable {
	let source: Source
}

// MARK: - Media
struct Media: Decodable {
	let redditVideo: RedditVideo?
	let oembed: RedditVideo?
	let type: String?
	enum CodingKeys: String, CodingKey {
		case redditVideo = "reddit_video"
		case type, oembed
	}
}

// MARK: - RedditVideo
struct RedditVideo: Decodable {
	let height, width: Int?
	let duration: Int?
	let hlsURL: String?
	let isGIF: Bool?

	enum CodingKeys: String, CodingKey {
		case height, width
		case duration
		case hlsURL = "hls_url"
		case isGIF = "is_gif"
	}
}

// MARK: - MediaMetadatum
struct MediaMetadata: Codable {
	let status: String
	let e: String?
	let p: [SingleMedia]?
	let s: SingleMedia?
	let id: String
}

// MARK: - S
struct SingleMedia: Codable, Hashable {
	let y, x: Int
	let u: String?
	let gif: String?
	let mp4: String?
	let caption: String?
}

//MARK: RPAN
struct RPANSource : Decodable {
	let hlsURL: String
	let thumbnail: String
	enum CodingKeys: String, CodingKey {
		case hlsURL = "hls_url"
		case thumbnail = "scrubber_media_url"
	}
}

// MARK: - GalleryData
struct GalleryData : Decodable {
	let items: [GalleryItem]
}

struct GalleryItem : Decodable, Identifiable {
	let mediaId: String
	let id: Int
	let caption: String?
	enum CodingKeys: String, CodingKey {
		case mediaId = "media_id"
		case id, caption
	}
}


// MARK: - Streamable
struct Streamable : Decodable {
	let files: MP4Files
}

// MARK: - Files
struct MP4Files : Decodable {
	let mp4: Mp4
}

// MARK: - Mp4
struct Mp4 : Decodable {
	let url: String?
	let duration: Double
}
