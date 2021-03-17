import Foundation

struct VictoriesCodable : Codable {

	var championship : String?
	var classification : String?
    var uuid: String?
	var year : String?

	enum CodingKeys: String, CodingKey {

		case championship = "championship"
		case classification = "classification"
        case uuid = "uuid"
		case year = "year"
	}

	init(from decoder: Decoder) throws {

		let values = try decoder.container(keyedBy: CodingKeys.self)

		championship = try values.decodeIfPresent(String.self, forKey: .championship)
		classification = try values.decodeIfPresent(String.self, forKey: .classification)
        uuid = try values.decodeIfPresent(String.self, forKey: .uuid)
		year = try values.decodeIfPresent(String.self, forKey: .year)
	}
}
