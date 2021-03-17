//
//  CellIdentifier.swift
//  AAACOMP iOS
//
//  Created by Rafael Escaleira on 29/05/20.
//  Copyright © 2020 Rafael Escaleira. All rights reserved.
//

import Foundation

class CellIdentifier {
    
    enum Identifiers {
        
        case events
        case modality
        case store
        case areas
        case goals
        case directors
        case history
        case attributes
        case partners
        case signIn
        case signUp
        case user
        case userOption
        case warning
        case administration
        case wallet
        case association
        case associationtype
        case statusAssociation
        case deposition
        case depositionCollection
        
        case detailEvents
        case moreDetailEvents
        case detailWarning
        case responsibleModalities
        case moreInfoModalities
        case detailAdministration
        case associationUser
        case simple
        case esports
        case detailUser
        
        case defaultCard
    }
    
    static func get(identifier: Identifiers) -> String {
        
        switch identifier {
            
        case .events: return "EventsTableViewCell"
        case .modality: return "ModalitiesTableViewCell"
        case .store: return "StoreTableViewCell"
        case .areas: return "AreasTableViewCell"
        case .goals: return "GoalsTableViewCell"
        case .directors: return "DirectoresTableViewCell"
        case .history: return "HistoryTableViewCell"
        case .attributes: return "AttributesTableViewCell"
        case .partners: return "PartnersTableViewCell"
        case .signIn: return "SignInTableViewCell"
        case .signUp: return "SignUpTableViewCell"
        case .user: return "UserTableViewCell"
        case .userOption: return "UserOptionTableViewCell"
        case .warning: return "WarningTableViewCell"
        case .administration: return "AdministrationTableViewCell"
        case .wallet: return "WalletTableViewCell"
        case .association: return "AssociationTableViewCell"
        case .associationtype: return "AssociationTypeTableViewCell"
        case .statusAssociation: return "StatusAssociationTableViewCell"
        case .deposition: return "DepositionsTableViewCell"
        case .depositionCollection: return "DepositionCollectionViewCell"
            
        case .detailEvents: return "DetailEventsTableViewCell"
        case .moreDetailEvents: return "MoreDetailEventsTableViewCellTableViewCell"
        case .detailWarning: return "DetailWarningTableViewCell"
        case .responsibleModalities: return "ResponsibleModalitiesTableViewCell"
        case .moreInfoModalities: return "MoreInfoModalitiesTableViewCell"
        case .detailAdministration: return "DetailAdministrationTableViewCell"
        case .associationUser: return "AssociationUserTableViewCell"
        case .simple: return "SimpleTableViewCell"
        case .esports: return "ESportsTableViewCell"
        case .detailUser: return "DetailUserTableViewCell"
            
        case .defaultCard: return "DefaultCardCollectionViewCell"
            
        }
    }
}
