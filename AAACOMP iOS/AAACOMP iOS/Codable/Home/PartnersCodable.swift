import Foundation

struct PartnersCodable : Codable {

	var description : String?
	var image : String?
	var name : String?
	var url : String?

	enum CodingKeys: String, CodingKey {

		case description = "description"
		case image = "image"
		case name = "name"
		case url = "url"
	}

	init(from decoder: Decoder) throws {

		let values = try decoder.container(keyedBy: CodingKeys.self)

		description = try values.decodeIfPresent(String.self, forKey: .description)
		image = try values.decodeIfPresent(String.self, forKey: .image)
		name = try values.decodeIfPresent(String.self, forKey: .name)
		url = try values.decodeIfPresent(String.self, forKey: .url)
	}
}