import Vapor
import VaporPostgreSQL

let drop = Droplet()
try drop.addProvider(VaporPostgreSQL.Provider.self)
drop.preparations.append(Quote.self)
drop.middleware.insert(CORSMiddleware(), at: 0)

drop.get { req in
    return try drop.view.make("welcome", [
    	"message": drop.localization[req.lang, "welcome", "title"]
    ])
}

let quoteController = QuoteController()
drop.resource("api/v1/quotes", quoteController)


drop.run()
