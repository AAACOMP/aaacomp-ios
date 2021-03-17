import Foundation

struct WarningCodable : Codable {

	let date : String?
	let image : String?
	let link : String?
	let message : String?
	let tag : String?
	let title : String?
	let user : String?
	let uuid : String?

	enum CodingKeys: String, CodingKey {

		case date = "date"
		case image = "image"
		case link = "link"
		case message = "message"
		case tag = "tag"
		case title = "title"
		case user = "user"
		case uuid = "uuid"
	}

	init(from decoder: Decoder) throws {

		let values = try decoder.container(keyedBy: CodingKeys.self)

		date = try values.decodeIfPresent(String.self, forKey: .date)
		image = try values.decodeIfPresent(String.self, forKey: .image)
		link = try values.decodeIfPresent(String.self, forKey: .link)
		message = try values.decodeIfPresent(String.self, forKey: .message)
		tag = try values.decodeIfPresent(String.self, forKey: .tag)
		title = try values.decodeIfPresent(String.self, forKey: .title)
		user = try values.decodeIfPresent(String.self, forKey: .user)
		uuid = try values.decodeIfPresent(String.self, forKey: .uuid)
	}
}
