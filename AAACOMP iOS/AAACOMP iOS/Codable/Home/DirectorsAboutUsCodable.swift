import Foundation

struct DirectorsAboutUsCodable : Codable {

	var color : String?
	var facebook : String?
	var image : String?
	var name : String?
	var officeUUID : String?
	var usualName : String?
	var uuid : String?

	enum CodingKeys: String, CodingKey {

		case color = "color"
		case facebook = "facebook"
		case image = "image"
		case name = "name"
		case officeUUID = "officeUUID"
		case usualName = "usualName"
		case uuid = "uuid"
	}

	init(from decoder: Decoder) throws {

		let values = try decoder.container(keyedBy: CodingKeys.self)

		color = try values.decodeIfPresent(String.self, forKey: .color)
		facebook = try values.decodeIfPresent(String.self, forKey: .facebook)
		image = try values.decodeIfPresent(String.self, forKey: .image)
		name = try values.decodeIfPresent(String.self, forKey: .name)
		officeUUID = try values.decodeIfPresent(String.self, forKey: .officeUUID)
		usualName = try values.decodeIfPresent(String.self, forKey: .usualName)
		uuid = try values.decodeIfPresent(String.self, forKey: .uuid)
	}
}