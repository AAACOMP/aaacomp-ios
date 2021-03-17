//
//  Download.swift
//  AAACOMPiOS
//
//  Created by Rafael Escaleira on 21/04/20.
//  Copyright © 2020 Rafael Escaleira. All rights reserved.
//

import Foundation
import Firebase
import Kingfisher

class Download {
    
    enum DatabaseKeys {
        
        case aboutUs
        case association
        case associationStatus
        case events
        case drums
        case esports
        case modalities
        case office
        case partners
        case paymentStatus
        case paymentTypes
        case responsible
        case courses
        case store
        case users
        case victories
        case warnings
    }
    
    // MARK: - Decode Data
    
    static private func decodeDataToArray(databaseKey: DatabaseKeys, dataArr: [Any]) -> [Any] {
        
        var arr: [Any] = []
        
        for data in (dataArr as? [DataSnapshot] ?? []) {
            
            var singleValue = data.value as? [String: Any] ?? [:]
            
            if databaseKey == .users || databaseKey == .victories { singleValue["uuid"] = data.key }
            
            guard let jsonData = try? JSONSerialization.data(withJSONObject: singleValue, options: .prettyPrinted) else { return arr }
            var value: Any?
            
            if databaseKey == .associationStatus { value = try? JSONDecoder().decode(AssociationStatusCodable.self, from: jsonData) }
            else if databaseKey == .events { value = try? JSONDecoder().decode(EventsCodable.self, from: jsonData) }
            else if databaseKey == .drums { value = try? JSONDecoder().decode(DrumsCodable.self, from: jsonData) }
            else if databaseKey == .esports { value = try? JSONDecoder().decode(ESportsCodable.self, from: jsonData) }
            else if databaseKey == .modalities { value = try? JSONDecoder().decode(ModalitiesCodable.self, from: jsonData) }
            else if databaseKey == .office { value = try? JSONDecoder().decode(OfficeCodable.self, from: jsonData) }
            else if databaseKey == .courses { value = try? JSONDecoder().decode(CoursesCodable.self, from: jsonData) }
            else if databaseKey == .partners { value = try? JSONDecoder().decode(PartnersCodable.self, from: jsonData) }
            else if databaseKey == .paymentStatus { value = try? JSONDecoder().decode(PaymentStatusCodable.self, from: jsonData) }
            else if databaseKey == .paymentTypes { value = try? JSONDecoder().decode(PaymentTypesCodable.self, from: jsonData) }
            else if databaseKey == .responsible { value = try? JSONDecoder().decode(ResponsibleCodable.self, from: jsonData) }
            else if databaseKey == .store { value = try? JSONDecoder().decode(StoreCodable.self, from: jsonData) }
            else if databaseKey == .users { value = try? JSONDecoder().decode(UserCodable.self, from: jsonData) }
            else if databaseKey == .victories { value = try? JSONDecoder().decode(VictoriesCodable.self, from: jsonData) }
            else if databaseKey == .warnings { value = try? JSONDecoder().decode(WarningCodable.self, from: jsonData) }
            
            guard let valuesNoEmpty = value else { return arr }
            arr.append(valuesNoEmpty)
        }
        
        if databaseKey == .users { arr = (arr as? [UserCodable] ?? []).sorted(by: { (prev, next) -> Bool in
            return prev.completeName ?? "" < next.completeName ?? ""
        }) }
        
        if databaseKey == .associationStatus { arr = (arr as? [AssociationStatusCodable] ?? []).sorted(by: { (prev, next) -> Bool in
            return (prev.timestamp ?? 0) < (next.timestamp ?? 0)
        }) }
        
        if databaseKey == .courses { arr = (arr as? [CoursesCodable] ?? []).sorted(by: { (prev, next) -> Bool in
            return (prev.name ?? "") < (next.name ?? "")
        }) }
        
        return arr
    }
    
    static private func decodeData(databaseKey: DatabaseKeys, data: Data) -> Any? {
        
        if databaseKey == .aboutUs { return try? JSONDecoder().decode(AboutUsCodable.self, from: data) }
        else if databaseKey == .association { return try? JSONDecoder().decode(AssociationCodable.self, from: data) }
        else if databaseKey == .users { return try? JSONDecoder().decode(UserCodable.self, from: data) }
        
        return nil
    }
    
    // MARK: - Database Paths
    
    static func getPath(databaseKey: DatabaseKeys) -> DatabaseReference {
        
        let databaseReference = Database.database().reference()
        
        switch databaseKey {
            
        case .aboutUs: return databaseReference.child("aboutUs")
        case .association: return databaseReference.child("association")
        case .associationStatus: return databaseReference.child("associationStatus")
        case .events: return databaseReference.child("events")
        case .drums: return databaseReference.child("drums")
        case .esports: return databaseReference.child("e-sports")
        case .modalities: return databaseReference.child("modalities")
        case .office: return databaseReference.child("office")
        case .courses: return databaseReference.child("courses").child("ufms")
        case .partners: return databaseReference.child("partners")
        case .paymentStatus: return databaseReference.child("paymentStatus")
        case .paymentTypes: return databaseReference.child("paymentTypes")
        case .responsible: return databaseReference.child("responsible")
        case .store: return databaseReference.child("store")
        case .users: return databaseReference.child("users")
        case .victories: return databaseReference.child("victories")
        case .warnings: return databaseReference.child("warnings")
            
        }
    }
    
    // MARK: - Observe Values
    
    static func observeValues(databaseKey: DatabaseKeys, completionHandler: @escaping (Any?, Alert) -> ()) {
        
        let path = self.getPath(databaseKey: databaseKey)
        path.queryOrderedByKey().keepSynced(true)
        
        path.queryOrderedByKey().observe(.value) { (dataSnapshot) in
            
            var decode: Any?
            
            if databaseKey == .aboutUs || databaseKey == .association {
                
                let singleValue = dataSnapshot.value as? [String: Any] ?? [:]
                
                guard let data = try? JSONSerialization.data(withJSONObject: singleValue, options: .prettyPrinted) else {
                    completionHandler(nil, Alert(isSuccess: false, title: Alert.wrongFetchData.title.rawValue, message: Alert.wrongFetchData.message.rawValue, style: .alert))
                    return ;
                }
                
                decode = self.decodeData(databaseKey: databaseKey, data: data)
            }
            
            else { decode = self.decodeDataToArray(databaseKey: databaseKey, dataArr: dataSnapshot.children.allObjects) }
            
            DispatchQueue.main.async { completionHandler(decode, Alert(isSuccess: true, title: nil, message: nil, style: .alert)) }
        }
    }
    
    static func observeUser(uid: String, completionHandler: @escaping (UserCodable?, Alert) -> ()) {
        
        let path = self.getPath(databaseKey: .users).child(uid)
        path.queryOrderedByKey().keepSynced(true)
        
        path.queryOrderedByKey().observe(.value) { (dataSnapshot) in
            
            let singleValue = dataSnapshot.value as? [String: Any] ?? [:]
            
            guard let data = try? JSONSerialization.data(withJSONObject: singleValue, options: .prettyPrinted)
                
            else {
                
                completionHandler(nil, Alert(isSuccess: false, title: Alert.wrongFetchData.title.rawValue, message: Alert.wrongFetchData.message.rawValue, style: .alert))
                return ;
            }
            
            let decoded = self.decodeData(databaseKey: .users, data: data) as? UserCodable
            
            DispatchQueue.main.async { completionHandler(decoded, Alert(isSuccess: true, title: nil, message: nil, style: .alert)) }
        }
    }
    
    static func observeWarnings(completionHandler: @escaping ([WarningCodable], Alert) -> ()) {
        
        let path = self.getPath(databaseKey: .warnings)
        path.queryLimited(toLast: 100).keepSynced(true)
        
        path.queryLimited(toLast: 100).observe(.value) { (dataSnapshot) in
            
            let warnings: [WarningCodable] = self.decodeDataToArray(databaseKey: .warnings, dataArr: dataSnapshot.children.allObjects) as? [WarningCodable] ?? []
            
            DispatchQueue.main.async { completionHandler(warnings.reversed(), Alert(isSuccess: true, title: nil, message: nil, style: .alert)) }
        }
    }
    
    static func images(urls: [String], completionHandler: @escaping ([String: UIImage], Alert) -> ()) {
        
        var images: [String: UIImage] = [:]
        
        urls.forEach { (item) in
            
            if let url = URL(string: item) {
                
                ImageDownloader.default.downloadImage(with: url, retrieveImageTask: .none, options: [.cacheOriginalImage], progressBlock: nil) { (image, error, url, data) in
                    
                    if image != nil {
                        images[url?.absoluteString ?? ""] = image
                        completionHandler(images, Alert(isSuccess: true, title: nil, message: nil, style: .alert))
                    }
                }
            }
            
            else { completionHandler([:], Alert(isSuccess: false, title: "Erro ao fazer download da imagem", message: "Há um erro com a url da imagem", style: .alert)) }
        }
    }
}
