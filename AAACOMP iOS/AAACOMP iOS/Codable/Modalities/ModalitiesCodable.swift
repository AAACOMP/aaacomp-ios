import Foundation

struct ModalitiesCodable : Codable {

	var genderUUID : String?
	var image : String?
	var moreInfo : MoreInfoModalitiesCodable?
	var name : String?
	var responsibleUUID : String?
	var uuid : String?
	var victoriesUUID : [String]?

	enum CodingKeys: String, CodingKey {

		case genderUUID = "genderUUID"
		case image = "image"
		case moreInfo = "moreInfo"
		case name = "name"
		case responsibleUUID = "responsibleUUID"
		case uuid = "uuid"
		case victoriesUUID = "victoriesUUID"
	}

	init(from decoder: Decoder) throws {

		let values = try decoder.container(keyedBy: CodingKeys.self)
		genderUUID = try values.decodeIfPresent(String.self, forKey: .genderUUID)
		image = try values.decodeIfPresent(String.self, forKey: .image)
		moreInfo = try values.decodeIfPresent(MoreInfoModalitiesCodable.self, forKey: .moreInfo)
		name = try values.decodeIfPresent(String.self, forKey: .name)
		responsibleUUID = try values.decodeIfPresent(String.self, forKey: .responsibleUUID)
		uuid = try values.decodeIfPresent(String.self, forKey: .uuid)
		victoriesUUID = try values.decodeIfPresent([String].self, forKey: .victoriesUUID)
	}
}
