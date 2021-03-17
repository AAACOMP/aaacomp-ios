import Foundation

struct AreasAboutUsCodable : Codable {

	var description : String?
	var image : String?
	var titleArea : String?
	var uuid : String?

	enum CodingKeys: String, CodingKey {

		case description = "description"
		case image = "image"
		case titleArea = "titleArea"
		case uuid = "uuid"
	}

	init(from decoder: Decoder) throws {

		let values = try decoder.container(keyedBy: CodingKeys.self)

		description = try values.decodeIfPresent(String.self, forKey: .description)
		image = try values.decodeIfPresent(String.self, forKey: .image)
		titleArea = try values.decodeIfPresent(String.self, forKey: .titleArea)
		uuid = try values.decodeIfPresent(String.self, forKey: .uuid)
	}
}