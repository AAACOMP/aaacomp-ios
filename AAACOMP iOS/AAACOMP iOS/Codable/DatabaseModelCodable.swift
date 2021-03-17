import Foundation

struct DatabaseModelCodable : Codable {

	var aboutUs : AboutUsCodable?
	var association : AssociationCodable?
	var events : [EventsCodable]?
	var modalities : [ModalitiesCodable]?
	var office : [OfficeCodable]?
	var partners : [PartnersCodable]?
	var paymentStatus : [PaymentStatusCodable]?
	var paymentTypes : [PaymentTypesCodable]?
	var responsible : [ResponsibleCodable]?
	var victories : [VictoriesCodable]?

	enum CodingKeys: String, CodingKey {

		case aboutUs = "aboutUs"
		case association = "association"
		case events = "events"
		case modalities = "modalities"
		case office = "office"
		case partners = "partners"
		case paymentStatus = "paymentStatus"
		case paymentTypes = "paymentTypes"
		case responsible = "responsible"
		case victories = "victories"
	}

	init(from decoder: Decoder) throws {

		let values = try decoder.container(keyedBy: CodingKeys.self)
        
		aboutUs = try values.decodeIfPresent(AboutUsCodable.self, forKey: .aboutUs)
		association = try values.decodeIfPresent(AssociationCodable.self, forKey: .association)
		events = try values.decodeIfPresent([EventsCodable].self, forKey: .events)
		modalities = try values.decodeIfPresent([ModalitiesCodable].self, forKey: .modalities)
		office = try values.decodeIfPresent([OfficeCodable].self, forKey: .office)
		partners = try values.decodeIfPresent([PartnersCodable].self, forKey: .partners)
		paymentStatus = try values.decodeIfPresent([PaymentStatusCodable].self, forKey: .paymentStatus)
		paymentTypes = try values.decodeIfPresent([PaymentTypesCodable].self, forKey: .paymentTypes)
		responsible = try values.decodeIfPresent([ResponsibleCodable].self, forKey: .responsible)
		victories = try values.decodeIfPresent([VictoriesCodable].self, forKey: .victories)
	}
}
