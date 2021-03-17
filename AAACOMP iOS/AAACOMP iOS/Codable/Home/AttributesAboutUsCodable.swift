import Foundation

struct AttributesAboutUsCodable : Codable {

	let color : String?
	let description : String?
	let title : String?

	enum CodingKeys: String, CodingKey {

		case color = "color"
		case description = "description"
		case title = "title"
	}

	init(from decoder: Decoder) throws {

		let values = try decoder.container(keyedBy: CodingKeys.self)

		color = try values.decodeIfPresent(String.self, forKey: .color)
		description = try values.decodeIfPresent(String.self, forKey: .description)
		title = try values.decodeIfPresent(String.self, forKey: .title)
	}
}