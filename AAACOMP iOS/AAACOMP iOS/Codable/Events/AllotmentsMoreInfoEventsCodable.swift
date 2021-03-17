import Foundation

struct AllotmentsMoreInfoEventsCodable : Codable {
    
    internal init(finalDate: String?, image: String?, initialDate: String?, priceTitle: String?, priceValue: Double?, title: String?) {
        self.finalDate = finalDate
        self.image = image
        self.initialDate = initialDate
        self.priceTitle = priceTitle
        self.priceValue = priceValue
        self.title = title
    }
    
	let finalDate : String?
	let image : String?
	let initialDate : String?
	let priceTitle : String?
	let priceValue : Double?
	let title : String?

	enum CodingKeys: String, CodingKey {

		case finalDate = "finalDate"
		case image = "image"
		case initialDate = "initialDate"
		case priceTitle = "priceTitle"
		case priceValue = "priceValue"
		case title = "title"
	}

	init(from decoder: Decoder) throws {

		let values = try decoder.container(keyedBy: CodingKeys.self)

		finalDate = try values.decodeIfPresent(String.self, forKey: .finalDate)
		image = try values.decodeIfPresent(String.self, forKey: .image)
		initialDate = try values.decodeIfPresent(String.self, forKey: .initialDate)
		priceTitle = try values.decodeIfPresent(String.self, forKey: .priceTitle)
		priceValue = try values.decodeIfPresent(Double.self, forKey: .priceValue)
		title = try values.decodeIfPresent(String.self, forKey: .title)
	}
}
