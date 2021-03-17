//
//  DetailWarningTableViewCell.swift
//  AAACOMP iOS
//
//  Created by Rafael Escaleira on 14/06/20.
//  Copyright © 2020 Rafael Escaleira. All rights reserved.
//

import UIKit
import Firebase
import Alamofire

class DetailWarningTableViewCell: UITableViewCell, UINavigationControllerDelegate, UIImagePickerControllerDelegate {

    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var messageTextField: UITextField!
    @IBOutlet weak var tagTextField: UITextField!
    @IBOutlet weak var linkTextField: UITextField!
    @IBOutlet weak var warningImageView: UIImageView!
    @IBOutlet weak var heightConstraint: NSLayoutConstraint!
    @IBOutlet weak var chooseButton: UIButton!
    @IBOutlet weak var clearButton: UIButton!
    @IBOutlet weak var postButton: UIButton!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    private var user: UserCodable?
    private var picker = UIImagePickerController()
    private var controller: DetailWarningViewController!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.picker.delegate = self
        self.postButton.addTarget(self, action: #selector(self.postButtonAction), for: .touchUpInside)
        self.chooseButton.addTarget(self, action: #selector(self.chooseButtonAction), for: .touchUpInside)
        self.clearButton.addTarget(self, action: #selector(self.clearButtonAction), for: .touchUpInside)
    }
    
    func setCell(user: UserCodable?, controller: DetailWarningViewController) {
        self.controller = controller
        self.user = user
    }
    
    @objc func postButtonAction() {
        
        if user == nil || user?.isAdm != true { return }
        
        self.isLoading(true)
        
        if self.titleTextField.text?.isEmpty == false && self.messageTextField.text?.isEmpty == false {
            
            let uuid = Date.currentTimeStamp
            
            var values: [String: Any] = [
                "date": String.getCurrentDateFormatted(dateFormat: "dd/MM/yyyy"),
                "message": self.messageTextField.text ?? "",
                "title": self.titleTextField.text ?? "",
                "user": user?.completeName ?? "",
                "uuid": uuid
            ]
            
            if self.tagTextField.text?.isEmpty == false { values["tag"] = self.tagTextField.text ?? "" }
            if self.linkTextField.text?.isEmpty == false { values["link"] = self.linkTextField.text ?? "" }
            
            if self.warningImageView.image != nil {
                
                self.uploadImage(uuid: uuid) { (isSuccess, urlString) in
                    
                    if isSuccess {
                        values["image"] = urlString ?? ""
                        self.postWarning(values: values, uuid: uuid)
                    }
                }
            }
            
            else { self.postWarning(values: values, uuid: uuid) }
        }
    }
    
    func postWarning(values: [String: Any], uuid: String) {
        
        Download.getPath(databaseKey: .warnings).child(uuid).updateChildValues(values) { (error, _) in
            
            if error != nil {
                Alert(isSuccess: false, title: "Erro ao postar aviso", message: error?.localizedDescription, style: .alert).show(controller: self.controller)
                self.isLoading(false)
                return
            }
            
            self.isLoading(false)
            self.sendNotification(title: values["title"] as? String, message: values["message"] as? String)
            self.controller.navigationController?.popViewController(animated: true)
        }
    }
    
    func uploadImage(uuid: String, completion: @escaping (Bool, String?) -> ()) {
        
        guard let imageData = self.warningImageView.image?.jpegData(compressionQuality: 0.5) else {
            Alert(isSuccess: false, title: "Erro ao carregar imagem", message: "Selecione uma imagem válida", style: .alert).show(controller: self.controller)
            self.isLoading(false)
            return
        }
        
        Storage.storage().reference().child("warnings").child(uuid).putData(imageData, metadata: StorageMetadata(dictionary: ["contentType": "image/jpeg"])) { (storageMetadata, error) in
            
            if error != nil {
                Alert(isSuccess: false, title: "Erro ao fazer upload da imagem", message: error?.localizedDescription, style: .alert).show(controller: self.controller)
                self.isLoading(false)
                return
            }
            
            Storage.storage().reference().child("warnings").child(uuid).downloadURL { (url, error) in
                
                if error != nil || url == nil {
                    Alert(isSuccess: false, title: "Erro ao fazer upload da imagem", message: error?.localizedDescription, style: .alert).show(controller: self.controller)
                    self.isLoading(false)
                    return
                }
                
                completion(true, url?.absoluteString)
            }
        }
    }
    
    func sendNotification(title: String?, message: String?) {
        
        let headers = ["Authorization": "key=AAAAWm0zr8g:APA91bE2KSZOf3MlyrhyrWPMHbYIb-mhSOrhQts45E5xIcbvaqSY7A2ht34c_9S2h-QTeAUI_7Li0vwZWXdIh4Ww5nuGdqKgk2GijlO7AfgoE0b95vkmV4A3s3PGhYqXbEA68B1_8K8P", "Content-Type": "application/json"]
        
        let body: [String: Any] = [
            "to": "/topics/warnings",
            "notification": [
                "title": title ?? "",
                "body": message ?? ""
            ]
        ]
        
        Alamofire.request("https://fcm.googleapis.com/fcm/send", method: .post, parameters: body, encoding: JSONEncoding.default, headers: headers).resume()
    }
    
    @objc func chooseButtonAction() {
        picker.sourceType = .photoLibrary
        self.controller.present(picker, animated: true, completion: nil)
    }
    
    @objc func clearButtonAction() {
        self.warningImageView.image = nil
        self.heightConstraint.constant = 0
        self.controller.tableView.reloadData()
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        guard let image = info[.originalImage] as? UIImage else { return }
        picker.dismiss(animated: true, completion: nil)
        self.warningImageView.image = image
        self.heightConstraint.constant = self.warningImageView.resize()
        self.controller.tableView.reloadData()
    }
    
    private func isLoading(_ sender: Bool) {
        
        let mode: VisibleMode = sender ? .disappear : .appear
        
        self.postButton.visibleMode(mode: mode, 0.4)
        self.chooseButton.visibleMode(mode: mode, 0.4)
        self.clearButton.visibleMode(mode: mode, 0.4)
        
        if sender { self.activityIndicator.startAnimating() }
        else { self.activityIndicator.stopAnimating() }
    }
}
