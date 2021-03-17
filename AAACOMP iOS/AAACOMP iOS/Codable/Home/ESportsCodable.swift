//
//  ESportsCodable.swift
//  AAACOMP iOS
//
//  Created by Rafael Escaleira on 17/07/20.
//  Copyright © 2020 Rafael Escaleira. All rights reserved.
//

import Foundation

struct ESportsCodable : Codable {

    let title : String?
    let description : String?
    let link : String?
    let image: String?
    let players : [String]?

    enum CodingKeys: String, CodingKey {

        case title = "title"
        case description = "description"
        case link = "link"
        case image = "image"
        case players = "players"
    }

    init(from decoder: Decoder) throws {

        let values = try decoder.container(keyedBy: CodingKeys.self)

        title = try values.decodeIfPresent(String.self, forKey: .title)
        description = try values.decodeIfPresent(String.self, forKey: .description)
        link = try values.decodeIfPresent(String.self, forKey: .link)
        image = try values.decodeIfPresent(String.self, forKey: .image)
        players = try values.decodeIfPresent([String].self, forKey: .players)
    }
}
