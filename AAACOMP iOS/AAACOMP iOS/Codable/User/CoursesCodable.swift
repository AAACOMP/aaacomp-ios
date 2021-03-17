//
//  CoursesCodable.swift
//  AAACOMP iOS
//
//  Created by Rafael Escaleira on 18/07/20.
//  Copyright © 2020 Rafael Escaleira. All rights reserved.
//

import Foundation

struct CoursesCodable: Codable {
    
    let centro : String?
    let centro_id : Int?
    let codigo : String?
    let modalidade_id : Int?
    let name : String?
    let turno : String?

    enum CodingKeys: String, CodingKey {

        case centro = "centro"
        case centro_id = "centro_id"
        case codigo = "codigo"
        case modalidade_id = "modalidade_id"
        case name = "name"
        case turno = "turno"
    }

    init(from decoder: Decoder) throws {
        
        let values = try decoder.container(keyedBy: CodingKeys.self)
        
        centro = try values.decodeIfPresent(String.self, forKey: .centro)
        centro_id = try values.decodeIfPresent(Int.self, forKey: .centro_id)
        codigo = try values.decodeIfPresent(String.self, forKey: .codigo)
        modalidade_id = try values.decodeIfPresent(Int.self, forKey: .modalidade_id)
        name = try values.decodeIfPresent(String.self, forKey: .name)
        turno = try values.decodeIfPresent(String.self, forKey: .turno)
    }
}
