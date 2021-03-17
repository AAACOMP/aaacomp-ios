import Foundation

struct AboutUsCodable : Codable {

	var areas : [AreasAboutUsCodable]?
	var attributes : [AttributesAboutUsCodable]?
	var contact : [ContactAboutUsCodable]?
	var depositions : [DepositionsAboutUsCodable]?
	var directors : [DirectorsAboutUsCodable]?
	var goals : [GoalsAboutUsCodable]?
	var story : String?

	enum CodingKeys: String, CodingKey {

		case areas = "areas"
		case attributes = "attributes"
		case contact = "contact"
		case depositions = "depositions"
		case directors = "directors"
		case goals = "goals"
		case story = "story"
	}

	init(from decoder: Decoder) throws {

		let values = try decoder.container(keyedBy: CodingKeys.self)
		areas = try values.decodeIfPresent([AreasAboutUsCodable].self, forKey: .areas)
		attributes = try values.decodeIfPresent([AttributesAboutUsCodable].self, forKey: .attributes)
		contact = try values.decodeIfPresent([ContactAboutUsCodable].self, forKey: .contact)
		depositions = try values.decodeIfPresent([DepositionsAboutUsCodable].self, forKey: .depositions)
        
        directors = []
        
        let directorsValues = try values.decodeIfPresent([String: Any].self, forKey: .directors)
        directorsValues?.forEach({ (value) in

            if let jsonData = try? JSONSerialization.data(withJSONObject: value.value, options: []) {
                if let director = try? JSONDecoder().decode(DirectorsAboutUsCodable.self, from: jsonData) { directors?.append(director) }
            }
        })
        
        directors?.sort(by: { (prev, next) -> Bool in
            return prev.officeUUID ?? "" > next.officeUUID ?? ""
        })
        
		goals = try values.decodeIfPresent([GoalsAboutUsCodable].self, forKey: .goals)
		story = try values.decodeIfPresent(String.self, forKey: .story)
	}
}
