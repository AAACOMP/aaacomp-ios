//
//  AssociationStatusCodable.swift
//  AAACOMP iOS
//
//  Created by Rafael Escaleira on 13/06/20.
//  Copyright © 2020 Rafael Escaleira. All rights reserved.
//

import Foundation

struct AssociationStatusCodable : Codable {

    let isValidate : Bool?
    let timestamp : Double?
    let uuid : String?
    let validate : String?

    enum CodingKeys: String, CodingKey {

        case isValidate = "isValidate"
        case timestamp = "timestamp"
        case uuid = "uuid"
        case validate = "validate"
    }

    init(from decoder: Decoder) throws {

        let values = try decoder.container(keyedBy: CodingKeys.self)

        isValidate = try values.decodeIfPresent(Bool.self, forKey: .isValidate)
        timestamp = try values.decodeIfPresent(Double.self, forKey: .timestamp)
        uuid = try values.decodeIfPresent(String.self, forKey: .uuid)
        validate = try values.decodeIfPresent(String.self, forKey: .validate)
    }
}
