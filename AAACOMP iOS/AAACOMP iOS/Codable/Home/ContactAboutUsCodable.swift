import Foundation

struct ContactAboutUsCodable : Codable {

    var image : String?
    var description : String?
	var title : String?
	var value : String?

	enum CodingKeys: String, CodingKey {

        case description = "description"
        case image = "image"
		case title = "title"
		case value = "value"
	}

	init(from decoder: Decoder) throws {

		let values = try decoder.container(keyedBy: CodingKeys.self)

        description = try values.decodeIfPresent(String.self, forKey: .description)
        image = try values.decodeIfPresent(String.self, forKey: .image)
		title = try values.decodeIfPresent(String.self, forKey: .title)
		value = try values.decodeIfPresent(String.self, forKey: .value)
	}
}
