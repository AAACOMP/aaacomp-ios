import Foundation

struct DepositionsAboutUsCodable : Codable {

	var description : String?
	var image : String?
	var name : String?
	var typePerson : String?
	var uuid : String?

	enum CodingKeys: String, CodingKey {

		case description = "description"
		case image = "image"
		case name = "name"
		case typePerson = "typePerson"
		case uuid = "uuid"
	}

	init(from decoder: Decoder) throws {

		let values = try decoder.container(keyedBy: CodingKeys.self)

		description = try values.decodeIfPresent(String.self, forKey: .description)
		image = try values.decodeIfPresent(String.self, forKey: .image)
		name = try values.decodeIfPresent(String.self, forKey: .name)
		typePerson = try values.decodeIfPresent(String.self, forKey: .typePerson)
		uuid = try values.decodeIfPresent(String.self, forKey: .uuid)
	}
}