import Foundation

struct ResponsibleCodable : Codable {
    
    internal init(email: String? = nil, image: String? = nil, name: String? = nil, phone: String? = nil, rga: String? = nil, uuid: String? = nil) {
        self.email = email
        self.image = image
        self.name = name
        self.phone = phone
        self.rga = rga
        self.uuid = uuid
    }
    
	var email : String?
	var image : String?
	var name : String?
	var phone : String?
	var rga : String?
	var uuid : String?

	enum CodingKeys: String, CodingKey {

		case email = "email"
		case image = "image"
		case name = "name"
		case phone = "phone"
		case rga = "rga"
		case uuid = "uuid"
	}

	init(from decoder: Decoder) throws {

		let values = try decoder.container(keyedBy: CodingKeys.self)
		
		email = try values.decodeIfPresent(String.self, forKey: .email)
		image = try values.decodeIfPresent(String.self, forKey: .image)
		name = try values.decodeIfPresent(String.self, forKey: .name)
		phone = try values.decodeIfPresent(String.self, forKey: .phone)
		rga = try values.decodeIfPresent(String.self, forKey: .rga)
		uuid = try values.decodeIfPresent(String.self, forKey: .uuid)
	}
}
