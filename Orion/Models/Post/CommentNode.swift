//
//  CommentNode.swift
//  Orion
//
//  Created by Anil Solanki on 25/12/22.
//

import Foundation

class CommentNode : Identifiable {
	let id = UUID().uuidString
	var data: Comment
	var children: [CommentNode] = []
	weak var parent: CommentNode?
	var moreCount : Int?
	var kind : String?

	var indent: Int

	init(_ data: Comment, _ indent: Int, _ parent: CommentNode?) {
		self.data = data
		self.indent = indent
		self.parent = parent
	}

	func addChild(node: CommentNode) {
		children.append(node)
		node.parent = self
	}

	static func tree(thing: Thing<Comment>) -> CommentNode {
		let node = CommentNode(thing.data, 0, nil)
		node.moreCount = thing.data.children?.count
		node.kind = thing.kind
		if let replies = thing.data.replies {
			for thing in replies.data.children {
				let childNode = tree(thing: thing)
				node.addChild(node: childNode)
			}
		}
		return node
	}

	static func findRootNode(Id: String, array: [CommentNode]) -> [CommentNode] {
		var nodes = [CommentNode]()
		for child in array {
			if child.data.parentId == Id {
				nodes.append(child)
			}
		}
		return nodes
	}

}


extension CommentNode {
	func find(_ children: [CommentNode]) -> CommentNode {
		for child in children {
			if child.data.parentId == self.data.name {
				self.addChild(node: child.find(children))
			}
		}
		return self
	}
}
