import Foundation

struct AttractionsMoreInfoEventsCodable : Codable {
    
    internal init(description: String? = nil, image: String? = nil, name: String? = nil) {
        self.description = description
        self.image = image
        self.name = name
    }
    
	var description : String?
	var image : String?
	var name : String?

	enum CodingKeys: String, CodingKey {

		case description = "description"
		case image = "image"
		case name = "name"
	}

	init(from decoder: Decoder) throws {

		let values = try decoder.container(keyedBy: CodingKeys.self)

		description = try values.decodeIfPresent(String.self, forKey: .description)
		image = try values.decodeIfPresent(String.self, forKey: .image)
		name = try values.decodeIfPresent(String.self, forKey: .name)
	}
}
