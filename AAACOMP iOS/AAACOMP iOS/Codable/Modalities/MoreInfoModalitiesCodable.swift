import Foundation

struct MoreInfoModalitiesCodable : Codable {

	var address : String?
	var description : String?
    var image : String?

	enum CodingKeys: String, CodingKey {

		case address = "address"
		case description = "description"
		case image = "image"
	}

	init(from decoder: Decoder) throws {

		let values = try decoder.container(keyedBy: CodingKeys.self)

		address = try values.decodeIfPresent(String.self, forKey: .address)
		description = try values.decodeIfPresent(String.self, forKey: .description)
		image = try values.decodeIfPresent(String.self, forKey: .image)
	}
}
