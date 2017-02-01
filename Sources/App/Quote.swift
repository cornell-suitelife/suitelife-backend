import Vapor
import Fluent
import Foundation

final class Quote: Model {
    var id: Node?
    var content: String
    var author: String
    var timestamp: TimeInterval
    
    init(content: String, author: String, timestamp: TimeInterval) {
        self.id = UUID().uuidString.makeNode()
        self.content = content
        self.author = author
        self.timestamp = timestamp
    }

    init(node: Node, in context: Context) throws {
        id = try node.extract("id")
        content = try node.extract("content")
        author = try node.extract("author")
        timestamp = try node.extract("timestamp")
    }

    func makeNode(context: Context) throws -> Node {
        return try Node(node: [
            "id": id,
            "content": content,
            "author": author,
            "timestamp": timestamp
        ])
    }
}

extension Quote: Preparation {
    static func prepare(_ database: Database) throws {
        try database.create("quotes") { quotes in
            quotes.id()
            quotes.string("content")
            quotes.string("author")
            quotes.double("timestamp")
        }
    }

    static func revert(_ database: Database) throws {
        try database.delete("quotes")
    }
}
