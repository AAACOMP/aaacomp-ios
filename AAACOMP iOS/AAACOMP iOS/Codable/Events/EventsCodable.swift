import Foundation

struct EventsCodable : Codable {

	var address : String?
	var date : String?
	var description : String?
	var image : String?
	var isParty : Bool?
	var moreInfo : MoreInfoEventsCodable?
	var name : String?
    var time: String?
	var uuid : String?

	enum CodingKeys: String, CodingKey {

		case address = "address"
		case date = "date"
		case description = "description"
		case image = "image"
		case isParty = "isParty"
		case moreInfo = "moreInfo"
		case name = "name"
        case time = "time"
		case uuid = "uuid"
	}

	init(from decoder: Decoder) throws {

		let values = try decoder.container(keyedBy: CodingKeys.self)

		address = try values.decodeIfPresent(String.self, forKey: .address)
		date = try values.decodeIfPresent(String.self, forKey: .date)
		description = try values.decodeIfPresent(String.self, forKey: .description)
		image = try values.decodeIfPresent(String.self, forKey: .image)
		isParty = try values.decodeIfPresent(Bool.self, forKey: .isParty)
        moreInfo = try values.decodeIfPresent(MoreInfoEventsCodable.self, forKey: .moreInfo)
		name = try values.decodeIfPresent(String.self, forKey: .name)
        time = try values.decodeIfPresent(String.self, forKey: .time)
		uuid = try values.decodeIfPresent(String.self, forKey: .uuid)
	}
}
