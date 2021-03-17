import Foundation

struct TypesAssociationCodable : Codable {

	var benefits : [String]?
	var image : String?
	var title : String?
	var values : [ValuesTypesAssociationCodable]?
    var uuid : String?

	enum CodingKeys: String, CodingKey {

		case benefits = "benefits"
		case image = "image"
		case title = "title"
		case values = "values"
        case uuid = "uuid"
	}

	init(from decoder: Decoder) throws {

		let valuesDecoder = try decoder.container(keyedBy: CodingKeys.self)

		benefits = try valuesDecoder.decodeIfPresent([String].self, forKey: .benefits)
		image = try valuesDecoder.decodeIfPresent(String.self, forKey: .image)
		title = try valuesDecoder.decodeIfPresent(String.self, forKey: .title)
		values = try valuesDecoder.decodeIfPresent([ValuesTypesAssociationCodable].self, forKey: .values)
        uuid = try valuesDecoder.decodeIfPresent(String.self, forKey: .uuid)
	}
}
