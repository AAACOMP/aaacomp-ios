import Foundation

struct PaymentStatusCodable : Codable {

	var name : String?
	var uuid : String?

	enum CodingKeys: String, CodingKey {

		case name = "name"
		case uuid = "uuid"
	}

	init(from decoder: Decoder) throws {

		let values = try decoder.container(keyedBy: CodingKeys.self)

		name = try values.decodeIfPresent(String.self, forKey: .name)
		uuid = try values.decodeIfPresent(String.self, forKey: .uuid)
	}
}