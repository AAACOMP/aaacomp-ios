import Foundation

struct ValuesTypesAssociationCodable : Codable {

	var title : String?
	var value : String?

	enum CodingKeys: String, CodingKey {

		case title = "title"
		case value = "value"
	}

	init(from decoder: Decoder) throws {

		let values = try decoder.container(keyedBy: CodingKeys.self)

		title = try values.decodeIfPresent(String.self, forKey: .title)
		value = try values.decodeIfPresent(String.self, forKey: .value)
	}
}
