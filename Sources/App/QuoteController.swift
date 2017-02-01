import Vapor
import HTTP

final class QuoteController: ResourceRepresentable {
    func index(request: Request) throws -> ResponseRepresentable {
        return try Quote.all().makeNode().converted(to: JSON.self)
    }

    func create(request: Request) throws -> ResponseRepresentable {
        var quote = try request.quote()
        try quote.save()
        return quote
    }
    
    func show(request: Request, quote: Quote) throws -> ResponseRepresentable {
        return quote
    }

    func delete(request: Request, quote: Quote) throws -> ResponseRepresentable {
        try quote.delete()
        return JSON([:])
    }

    func clear(request: Request) throws -> ResponseRepresentable {
        try Quote.query().delete()
        return JSON([])
    }

    func update(request: Request, quote: Quote) throws -> ResponseRepresentable {
        let new = try request.quote()
        var quote = quote
        quote.content = new.content
        try quote.save()
        return quote
    }

    func replace(request: Request, quote: Quote) throws -> ResponseRepresentable {
        try quote.delete()
        return try create(request: request)
    }

    func makeResource() -> Resource<Quote> {
        return Resource(
            index: index,
            store: create,
            show: show,
            replace: replace,
            modify: update,
            destroy: delete,
            clear: clear
        )
    }
}

extension Request {
    func quote() throws -> Quote {
        guard let json = json else { throw Abort.badRequest }
        return try Quote(node: json)
    }
}
