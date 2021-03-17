import Foundation

struct OfficeCodable : Codable {

	var title : String?
	var uuid : String?

	enum CodingKeys: String, CodingKey {

		case title = "title"
		case uuid = "uuid"
	}

	init(from decoder: Decoder) throws {

		let values = try decoder.container(keyedBy: CodingKeys.self)

		title = try values.decodeIfPresent(String.self, forKey: .title)
		uuid = try values.decodeIfPresent(String.self, forKey: .uuid)
	}
}