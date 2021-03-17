import Foundation

struct AssociationCodable : Codable {

	var description : String?
	var isOpen : Bool?
	var link : String?
	var observation : String?
	var types : [TypesAssociationCodable]?

	enum CodingKeys: String, CodingKey {

		case description = "description"
		case isOpen = "isOpen"
		case link = "link"
		case observation = "observation"
		case types = "types"
	}

	init(from decoder: Decoder) throws {

		let values = try decoder.container(keyedBy: CodingKeys.self)

		description = try values.decodeIfPresent(String.self, forKey: .description)
		isOpen = try values.decodeIfPresent(Bool.self, forKey: .isOpen)
		link = try values.decodeIfPresent(String.self, forKey: .link)
		observation = try values.decodeIfPresent(String.self, forKey: .observation)
		types = try values.decodeIfPresent([TypesAssociationCodable].self, forKey: .types)
	}
}
