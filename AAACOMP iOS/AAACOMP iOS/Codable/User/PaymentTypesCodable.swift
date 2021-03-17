import Foundation

struct PaymentTypesCodable : Codable {

	var name : String?
    var observation: String?
	var uuid : String?

	enum CodingKeys: String, CodingKey {

		case name = "name"
        case observation = "observation"
		case uuid = "uuid"
	}

	init(from decoder: Decoder) throws {

		let values = try decoder.container(keyedBy: CodingKeys.self)

		name = try values.decodeIfPresent(String.self, forKey: .name)
        observation = try values.decodeIfPresent(String.self, forKey: .observation)
		uuid = try values.decodeIfPresent(String.self, forKey: .uuid)
	}
}
