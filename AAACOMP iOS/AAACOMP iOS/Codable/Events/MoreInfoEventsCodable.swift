import Foundation

struct MoreInfoEventsCodable : Codable {

	var allotments : [AllotmentsMoreInfoEventsCodable]?
	var attractions : [AttractionsMoreInfoEventsCodable]?
	var drinks : [DrinksMoreInfoEventsCodable]?
	var moreover : [MoreoverMoreInfoEventsCodable]?
	var sellersUUID : [String]?

	enum CodingKeys: String, CodingKey {

		case allotments = "allotments"
		case attractions = "attractions"
		case drinks = "drinks"
		case moreover = "moreover"
		case sellersUUID = "sellers"
	}

	init(from decoder: Decoder) throws {

		let values = try decoder.container(keyedBy: CodingKeys.self)
        
        allotments = []
        attractions = []
        drinks = []
        moreover = []
        sellersUUID = []

        let allotmentsValues = try values.decodeIfPresent([String: Any].self, forKey: .allotments)
        allotmentsValues?.forEach({ (value) in

            if let jsonData = try? JSONSerialization.data(withJSONObject: value.value, options: []) {
                if let allotment = try? JSONDecoder().decode(AllotmentsMoreInfoEventsCodable.self, from: jsonData) { allotments?.append(allotment) }
            }
        })
        
        let attractionsValues = try values.decodeIfPresent([String: Any].self, forKey: .attractions)
        attractionsValues?.forEach({ (value) in

            if let jsonData = try? JSONSerialization.data(withJSONObject: value.value, options: []) {
                if let attraction = try? JSONDecoder().decode(AttractionsMoreInfoEventsCodable.self, from: jsonData) { attractions?.append(attraction) }
            }
        })
        
        let drinksValues = try values.decodeIfPresent([String: Any].self, forKey: .drinks)
        drinksValues?.forEach({ (value) in

            if let jsonData = try? JSONSerialization.data(withJSONObject: value.value, options: []) {
                if let drink = try? JSONDecoder().decode(DrinksMoreInfoEventsCodable.self, from: jsonData) { drinks?.append(drink) }
            }
        })
        
        let moreoverValues = try values.decodeIfPresent([String: Any].self, forKey: .moreover)
        moreoverValues?.forEach({ (value) in

            if let jsonData = try? JSONSerialization.data(withJSONObject: value.value, options: []) {
                if let more = try? JSONDecoder().decode(MoreoverMoreInfoEventsCodable.self, from: jsonData) { moreover?.append(more) }
            }
        })
        
        let sellersValues = try values.decodeIfPresent([String: String].self, forKey: .sellersUUID)
        sellersValues?.forEach({ (value) in

            sellersUUID?.append(value.value)
        })
	}
}
