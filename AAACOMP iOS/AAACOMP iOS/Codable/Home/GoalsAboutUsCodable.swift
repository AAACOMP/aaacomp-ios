import Foundation

struct GoalsAboutUsCodable : Codable {

	var description : String?
	var image : String?
	var title : String?

	enum CodingKeys: String, CodingKey {

		case description = "description"
		case image = "image"
		case title = "title"
	}

	init(from decoder: Decoder) throws {

		let values = try decoder.container(keyedBy: CodingKeys.self)

		description = try values.decodeIfPresent(String.self, forKey: .description)
		image = try values.decodeIfPresent(String.self, forKey: .image)
		title = try values.decodeIfPresent(String.self, forKey: .title)
	}
}