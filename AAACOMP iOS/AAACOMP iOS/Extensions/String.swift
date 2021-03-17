//
//  String.swift
//  AAACOMPiOS
//
//  Created by Rafael Escaleira on 21/04/20.
//  Copyright © 2020 Rafael Escaleira. All rights reserved.
//

import UIKit

extension String {
    
    func toBase64() -> String { return Data(self.utf8).base64EncodedString() }
    
    enum AboutUS: String {
        
        case areaTitle = "Saiba Mais ..."
        case areaSubtitle = "Algumas de nossas areas"
        
        case goalTitle = "Objetivos"
        case goalSubtitle = "O que buscamos, vai muito além do esporte..."
        
        case aboutTitle = "Sobre"
        case aboutSubtitle = "UNIÃO VISANDO O CRESCIMENTO ACADÊMICO E O LAZER"
        
        case directorTitle = "Gestão"
        case directorSubtitle = "Quem vai à frente da batalha..."
    }
    
    func getDateFormatted(currentDateFormat: String, newDateFormat: String, dateString: String?) -> String? {
        
        let dateFormatterGet = DateFormatter()
        dateFormatterGet.dateFormat = currentDateFormat
        
        let dateFormatterSet = DateFormatter()
        dateFormatterSet.locale = Locale(identifier: "pt-br")
        dateFormatterSet.dateFormat = newDateFormat

        guard let date = dateFormatterGet.date(from: String(dateString?.prefix(10) ?? "")) else { return nil }
        return dateFormatterSet.string(from: date)
    }
    
    static func getCurrentDateFormatted(dateFormat: String) -> String {
        
        let dateFormatterSet = DateFormatter()
        dateFormatterSet.locale = Locale(identifier: "pt-br")
        dateFormatterSet.dateFormat = dateFormat

        return dateFormatterSet.string(from: Date())
    }
    
    static func getDate(dateFormat: String, dateStr: String) -> Date {
        
        let dateFormatterSet = DateFormatter()
        dateFormatterSet.locale = Locale(identifier: "pt-br")
        dateFormatterSet.dateFormat = dateFormat

        return dateFormatterSet.date(from: dateStr) ?? Date()
    }
    
    var stripped: String {
        let okayChars = Set("abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLKMNOPQRSTUVWXYZ1234567890")
        return self.filter {okayChars.contains($0) }
    }
    
    func isValidEmail() -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailPred.evaluate(with: self)
    }
    
    func verifyUrl () -> Bool {
        if let url = NSURL(string: self) { return UIApplication.shared.canOpenURL(url as URL) }
        return false
    }
}

// MARK: - Mask

extension String {
    
    enum MaskType: String {
        
        case cpf = "***.***.***-**"
        case cnpj = "**.***.***/****-**"
        case birthday = "**/**/****"
        case rga = "****.****.***-*"
        case phone = ""
    }
    
    private func stringFilterWithCharacter(_ char: Character) -> Bool {
        
        return char != "." && char != "/" && char != "-"
    }
    
    private func transformStringToFilteredCharCollection(_ text: String) -> [Character] {
        
        var filteredText = [Character]()
        
        text.filter { (char) -> Bool in stringFilterWithCharacter(char) }.forEach { (char) in
            
            filteredText.append(char)
        }
        
        return filteredText
    }
    
    private func transformCharCollectionToString(_ chars: [Character]) -> String {
        
        var rawString = ""
        
        chars.forEach { (char) in rawString += String(char) }
        
        return rawString
    }
    
    private func transformCharCollectionToMaskedString(_ chars: [Character], mask: String) -> String {
        
        let textLength = chars.count
        var textIndex = 0
        var maskedString = ""
        
        mask.forEach { (char) in
            
            if textIndex < textLength {
                
                if char == "*" {
                    
                    maskedString += String(chars[textIndex])
                    textIndex += 1
                }
                
                else  { maskedString += String(char) }
            }
        }
        
        return maskedString
    }
    
    // MARK: - More Actions
    
    mutating func filterMaskFromText() {
        
        let filteredCharCollection = transformStringToFilteredCharCollection(self)
        self = transformCharCollectionToString(filteredCharCollection)
    }
    
    func applyMask(_ mask: MaskType) -> String {
        
        let str = self.replacingOccurrences(of: "(", with: "").replacingOccurrences(of: ")", with: "").replacingOccurrences(of: " ", with: "").replacingOccurrences(of: "-", with: "").replacingOccurrences(of: ".", with: "").replacingOccurrences(of: "/", with: "").replacingOccurrences(of: "+", with: "")
        
        if mask == .phone {
            
            var newMask = "****-****"
            if str.count == 8 { newMask = "****-****" }
            else if str.count == 9 { newMask = "* ****-****" }
            else if str.count == 10 { newMask = "(**) ****-****" }
            else if str.count == 11 { newMask = "(**) * ****-****" }
            
            let filteredCharCollection = transformStringToFilteredCharCollection(str)
            return transformCharCollectionToMaskedString(filteredCharCollection, mask: newMask)
        }
        
        else {
            let filteredCharCollection = transformStringToFilteredCharCollection(str)
            return transformCharCollectionToMaskedString(filteredCharCollection, mask: mask.rawValue)
        }
    }
    
    
}
