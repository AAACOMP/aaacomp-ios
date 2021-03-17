//
//  DetailUserTableViewCell.swift
//  AAACOMP iOS
//
//  Created by Rafael Escaleira on 19/07/20.
//  Copyright © 2020 Rafael Escaleira. All rights reserved.
//

import UIKit
import Firebase

class DetailUserTableViewCell: UITableViewCell, UINavigationControllerDelegate, UIImagePickerControllerDelegate, MDatePickerViewDelegate {
    
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var cpfTextField: UITextField!
    @IBOutlet weak var rgaTextField: UITextField!
    @IBOutlet weak var birthdayTextField: UITextField!
    @IBOutlet weak var phoneTextField: UITextField!
    @IBOutlet weak var courseTextField: UITextField!
    
    @IBOutlet weak var userImage: UIImageView!
    @IBOutlet weak var chooseButton: UIButton!
    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var resetPasswordButton: UIButton!
    @IBOutlet weak var dateView: UIView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    private var picker = UIImagePickerController()
    private var isNewImage: Bool = false
    var controller: DetailUserViewController!
    var user: UserCodable?
    
    lazy var MDate : MDatePickerView = {
        let mdate = MDatePickerView()
        mdate.Color = .systemBlue
        mdate.delegate = self
        mdate.from = 1950
        mdate.translatesAutoresizingMaskIntoConstraints = false
        mdate.Col.layer.cornerRadius = 10
        mdate.to = Date.currentYear
        return mdate
    }()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.picker.delegate = self
        self.mdatePickerView(selectDate: Date())
        self.chooseButton.addTarget(self, action: #selector(self.chooseButtonAction), for: .touchUpInside)
        
        self.cpfTextField.addTarget(self, action: #selector(self.cpfDidChange(textField:)), for: .editingChanged)
        self.rgaTextField.addTarget(self, action: #selector(self.rgaDidChange(textField:)), for: .editingChanged)
        self.phoneTextField.addTarget(self, action: #selector(self.phoneDidChange(textField:)), for: .editingChanged)
        self.courseTextField.addTarget(self, action: #selector(self.courseDidChange(textField:)), for: .editingDidBegin)
        self.resetPasswordButton.addTarget(self, action: #selector(self.resetPasswordAction), for: .touchUpInside)
        self.saveButton.addTarget(self, action: #selector(self.saveAction), for: .touchUpInside)
        
        dateView.addSubview(MDate)
        
        NSLayoutConstraint.activate([
            NSLayoutConstraint(item: MDate, attribute: .leading, relatedBy: .equal, toItem: dateView, attribute: .leading, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: MDate, attribute: .trailing, relatedBy: .equal, toItem: dateView, attribute: .trailing, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: MDate, attribute: .bottom, relatedBy: .equal, toItem: dateView, attribute: .bottom, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: MDate, attribute: .top, relatedBy: .equal, toItem: dateView, attribute: .top, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: MDate, attribute: .height, relatedBy: .equal, toItem: .none, attribute: .notAnAttribute, multiplier: 1, constant: 200)
        ])
    }
    
    @objc func cpfDidChange(textField: UITextField) { textField.text = textField.text?.applyMask(.cpf) }
    @objc func rgaDidChange(textField: UITextField) { textField.text = textField.text?.applyMask(.rga) }
    @objc func phoneDidChange(textField: UITextField) { textField.text = textField.text?.applyMask(.phone) }
    
    @objc func courseDidChange(textField: UITextField) {
        
        textField.resignFirstResponder()
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        guard let controller = storyboard.instantiateViewController(withIdentifier: "CoursesViewController") as? CoursesViewController else { return }
        controller.delegate = self.controller.self
        controller.datasource = self.controller.self
        self.controller.navigationController?.pushViewController(controller, animated: true)
    }
    
    @objc func resetPasswordAction() {
        
        Auth.auth().sendPasswordReset(withEmail: self.user?.email ?? "") { (error) in
            if error == nil {
                Alert(isSuccess: true, title: "Sucesso ao Solicitar Nova Senha", message: "Um link para redefinir sua senha foi enviado ao e-mail cadastrado.", style: .alert).show(controller: self.controller)
            }
            else { Alert(isSuccess: true, title: "Erro ao Solicitar Nova Senha", message: error?.localizedDescription, style: .alert).show(controller: self.controller) }
        }
    }
    
    @objc func saveAction() {
        
        self.isLoading(true)
        
        let isValid = self.verifyFields()
        
        if isValid.isSuccess {
            
            let currentUser = Auth.auth().currentUser
            
            if self.isNewImage == true {
                
                guard let imageData = self.userImage.image?.jpegData(compressionQuality: 0.5) else {
                    Alert(isSuccess: false, title: "Erro ao carregar imagem", message: "Selecione uma imagem válida", style: .alert).show(controller: self.controller)
                    self.isLoading(false)
                    return
                }
                
                Storage.storage().reference().child("users").child(currentUser?.uid ?? "").delete { (error) in
                    
                    if error == nil {
                        
                        Storage.storage().reference().child("users").child(currentUser?.uid ?? "").putData(imageData, metadata: StorageMetadata(dictionary: ["contentType": "image/jpeg"])) { (storageMetadata, error) in
                            
                            if error != nil {
                                Alert(isSuccess: false, title: "Erro ao fazer upload da imagem", message: error?.localizedDescription, style: .alert).show(controller: self.controller)
                                self.isLoading(false)
                                return
                            }
                            
                            Storage.storage().reference().child("users").child(currentUser?.uid ?? "").downloadURL { (url, error) in
                                
                                if error != nil || url == nil {
                                    Alert(isSuccess: false, title: "Erro ao fazer upload da imagem", message: error?.localizedDescription, style: .alert).show(controller: self.controller)
                                    self.isLoading(false)
                                    return
                                }
                                
                                var user: [String: Any] = [
                                    "birthday": self.birthdayTextField.text ?? "",
                                    "completeName": self.nameTextField.text ?? "",
                                    "contact": self.phoneTextField.text ?? "",
                                    "course": self.courseTextField.text ?? "",
                                    "cpf": self.cpfTextField.text ?? "",
                                    "email": self.user?.email ?? "",
                                    "image": url?.absoluteString ?? "",
                                    "paymentStatusUUID": self.user?.paymentStatusUUID ?? "",
                                    "paymentTypeUUID": self.user?.paymentTypeUUID ?? "",
                                    "rga": self.rgaTextField.text ?? ""
                                ]
                                
                                if self.user?.credits ?? -1 != -1 { user["credits"] = self.user?.credits ?? 0 }
                                if self.user?.associationStatusUUID?.count ?? 0 != 0 { user["associationStatusUUID"] = self.user?.associationStatusUUID ?? [] }
                                if self.user?.associationTypeUUID?.isEmpty == false { user["associationTypeUUID"] = self.user?.associationTypeUUID }
                                
                                Download.getPath(databaseKey: .users).child(currentUser?.uid ?? "").updateChildValues(user) { (error, databaseReference) in
                                    
                                    if error == nil {
                                        self.isLoading(false)
                                        self.controller.navigationController?.popViewController(animated: true)
                                    }
                                        
                                    else { self.isLoading(false) }
                                }
                            }
                        }
                    }
                    
                    else {
                        Alert(isSuccess: false, title: "Erro ao remover imagem existente", message: error?.localizedDescription, style: .alert).show(controller: self.controller)
                        self.isLoading(false)
                    }
                }
            }
            
            else {
                
                var user: [String: Any] = [
                    "birthday": self.birthdayTextField.text ?? "",
                    "completeName": self.nameTextField.text ?? "",
                    "contact": self.phoneTextField.text ?? "",
                    "course": self.courseTextField.text ?? "",
                    "cpf": self.cpfTextField.text ?? "",
                    "email": self.user?.email ?? "",
                    "image": self.user?.image ?? "",
                    "paymentStatusUUID": self.user?.paymentStatusUUID ?? "",
                    "paymentTypeUUID": self.user?.paymentTypeUUID ?? "",
                    "rga": self.rgaTextField.text ?? ""
                ]
                
                if self.user?.credits ?? -1 != -1 { user["credits"] = self.user?.credits ?? 0 }
                if self.user?.associationStatusUUID?.count ?? 0 != 0 { user["associationStatusUUID"] = self.user?.associationStatusUUID ?? [] }
                if self.user?.associationTypeUUID?.isEmpty == false { user["associationTypeUUID"] = self.user?.associationTypeUUID }
                
                Download.getPath(databaseKey: .users).child(currentUser?.uid ?? "").updateChildValues(user) { (error, databaseReference) in
                    
                    if error == nil {
                        self.isLoading(false)
                        self.controller.navigationController?.popViewController(animated: true)
                    }
                        
                    else { self.isLoading(false) }
                }
            }
        }
            
        else {
            self.isLoading(false)
            isValid.show(controller: self.controller)
        }
    }
    
    func verifyFields() -> (Alert) {
        
        if self.userImage.image == nil || userImage.image == UIImage() || userImage.isEqualTo(image: #imageLiteral(resourceName: "user-circle")) { return (Alert(isSuccess: false, title: "Campo Vazio", message: "Selecione um foto para prosseguir com o cadastro", style: .alert)) }
        if self.nameTextField.text?.isEmpty != false { return (Alert(isSuccess: false, title: "Campo Vazio", message: "Preencha o campo nome completo para prosseguir com o cadastro", style: .alert)) }
        if self.cpfTextField.text?.isEmpty != false { return (Alert(isSuccess: false, title: "Campo Vazio", message: "Preencha o campo CPF para prosseguir com o cadastro", style: .alert)) }
        if self.rgaTextField.text?.isEmpty != false { return (Alert(isSuccess: false, title: "Campo Vazio", message: "Preencha o campo RGA para prosseguir com o cadastro", style: .alert)) }
        if self.birthdayTextField.text?.isEmpty != false { return (Alert(isSuccess: false, title: "Campo Vazio", message: "Preencha o campo data de nascimento para prosseguir com o cadastro", style: .alert)) }
        if self.phoneTextField.text?.isEmpty != false { return (Alert(isSuccess: false, title: "Campo Vazio", message: "Preencha o campo telefone para prosseguir com o cadastro", style: .alert)) }
        if self.courseTextField.text?.isEmpty != false { return (Alert(isSuccess: false, title: "Campo Vazio", message: "Preencha o campo curso para prosseguir com o cadastro", style: .alert)) }
        
        return Alert(isSuccess: true, title: nil, message: nil, style: .alert)
    }
    
    func mdatePickerView(selectDate: Date) {
        
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/yyyy"
        let date = formatter.string(from: selectDate)
        self.birthdayTextField.text = date
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    @objc func chooseButtonAction() {
        picker.sourceType = .photoLibrary
        self.controller.present(picker, animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        guard let image = info[.originalImage] as? UIImage else { return }
        picker.dismiss(animated: true, completion: nil)
        self.controller.image = image
        self.isNewImage = true
        self.controller.tableView.reloadData()
    }
    
    private func isLoading(_ sender: Bool) {
        
        let mode: VisibleMode = sender ? .disappear : .appear
        
        self.chooseButton.visibleMode(mode: mode, 0.4)
        self.saveButton.visibleMode(mode: mode, 0.4)
        self.resetPasswordButton.visibleMode(mode: mode, 0.4)
        
        if sender { self.activityIndicator.startAnimating() }
        else { self.activityIndicator.stopAnimating() }
    }
}
