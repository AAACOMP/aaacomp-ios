import Foundation

struct StoreCodable : Codable {

    var description : String?
    var isOpen : Bool?
    var forms : String?
    var image : String?
    var title : String?

    enum CodingKeys: String, CodingKey {

        case description = "description"
        case isOpen = "isOpen"
        case forms = "forms"
        case image = "image"
        case title = "title"
    }

    init(from decoder: Decoder) throws {

        let values = try decoder.container(keyedBy: CodingKeys.self)

        description = try values.decodeIfPresent(String.self, forKey: .description)
        isOpen = try values.decodeIfPresent(Bool.self, forKey: .isOpen)
        forms = try values.decodeIfPresent(String.self, forKey: .forms)
        image = try values.decodeIfPresent(String.self, forKey: .image)
        title = try values.decodeIfPresent(String.self, forKey: .title)
    }
}
