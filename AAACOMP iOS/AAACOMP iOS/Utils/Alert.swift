//
//  Alert.swift
//  Agrotoq
//
//  Created by Rafael Escaleira on 03/02/20.
//  Copyright © 2020 Rafael Escaleira. All rights reserved.
//

import UIKit

class Alert {
    
    var alert: UIAlertController!
    
    enum withoutConnection: String {
        
        case title = "Sem Conexão"
        case message = "Conecte-se a internet para carregar os dados desejados"
        case messageHasData = "Conecte-se a internet para carregar os dados atualizados"
    }
    
    enum wrongFetchData: String {
        
        case title = "Erro ao Carregar Dados"
        case message = "Verifique se seu aplicativo está atualizado"
    }
    
    enum lostConnection: String {
        
        case title = "Sem conexão"
        case message = "Sua conexão com a internet foi interrompida. Diante disso, os dados apresentados podem estar desatualizados"
    }
    
    let isSuccess: Bool
    let title: String?
    let message: String?
    
    init(isSuccess: Bool, title: String?, message: String?, style: UIAlertController.Style) {
        
        self.isSuccess = isSuccess
        self.title = title
        self.message = message
        
        self.alert = UIAlertController(title: self.title, message: self.message, preferredStyle: style)
    }
    
    func show(controller: UIViewController) {
        
        let ok = UIAlertAction(title: "Ok", style: .cancel, handler: nil)
        alert.addAction(ok)
        
        ok.setValue(UIColor.systemBlue, forKey: "titleTextColor")
        
        DispatchQueue.main.async { controller.present(self.alert, animated: true, completion: nil) }
    }
}
