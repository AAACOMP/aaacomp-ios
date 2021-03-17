import Foundation

struct DrinksMoreInfoEventsCodable : Codable {
    
    internal init(image: String? = nil, name: String? = nil, type: String? = nil) {
        self.image = image
        self.name = name
        self.type = type
    }
    
	var image : String?
	var name : String?
	var type : String?

	enum CodingKeys: String, CodingKey {

		case image = "image"
		case name = "name"
		case type = "description"
	}

	init(from decoder: Decoder) throws {

		let values = try decoder.container(keyedBy: CodingKeys.self)

		image = try values.decodeIfPresent(String.self, forKey: .image)
		name = try values.decodeIfPresent(String.self, forKey: .name)
		type = try values.decodeIfPresent(String.self, forKey: .type)
	}
}
