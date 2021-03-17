//
//  UserCodable.swift
//  AAACOMP iOS
//
//  Created by Rafael Escaleira on 13/06/20.
//  Copyright © 2020 Rafael Escaleira. All rights reserved.
//

import Foundation

struct UserCodable : Codable {

    let associationStatusUUID : [String]?
    let associationTypeUUID : String?
    let birthday : String?
    let completeName : String?
    let contact : String?
    let course : String?
    let cpf : String?
    let credits : Int?
    let email : String?
    let image : String?
    let isAdm : Bool?
    let paymentStatusUUID : String?
    let paymentTypeUUID : String?
    let rga : String?
    var uuid: String?

    enum CodingKeys: String, CodingKey {

        case associationStatusUUID = "associationStatusUUID"
        case associationTypeUUID = "associationTypeUUID"
        case birthday = "birthday"
        case completeName = "completeName"
        case contact = "contact"
        case course = "course"
        case cpf = "cpf"
        case credits = "credits"
        case email = "email"
        case image = "image"
        case isAdm = "isAdm"
        case paymentStatusUUID = "paymentStatusUUID"
        case paymentTypeUUID = "paymentTypeUUID"
        case rga = "rga"
        case uuid = "uuid"
    }

    init(from decoder: Decoder) throws {

        let values = try decoder.container(keyedBy: CodingKeys.self)

        associationStatusUUID = try values.decodeIfPresent([String].self, forKey: .associationStatusUUID)
        associationTypeUUID = try values.decodeIfPresent(String.self, forKey: .associationTypeUUID)
        birthday = try values.decodeIfPresent(String.self, forKey: .birthday)
        completeName = try values.decodeIfPresent(String.self, forKey: .completeName)
        contact = try values.decodeIfPresent(String.self, forKey: .contact)
        course = try values.decodeIfPresent(String.self, forKey: .course)
        cpf = try values.decodeIfPresent(String.self, forKey: .cpf)
        credits = try values.decodeIfPresent(Int.self, forKey: .credits)
        email = try values.decodeIfPresent(String.self, forKey: .email)
        image = try values.decodeIfPresent(String.self, forKey: .image)
        isAdm = try values.decodeIfPresent(Bool.self, forKey: .isAdm)
        paymentStatusUUID = try values.decodeIfPresent(String.self, forKey: .paymentStatusUUID)
        paymentTypeUUID = try values.decodeIfPresent(String.self, forKey: .paymentTypeUUID)
        rga = try values.decodeIfPresent(String.self, forKey: .rga)
        uuid = try values.decodeIfPresent(String.self, forKey: .uuid)
    }
}
