//
//  SignUpTableViewCell.swift
//  AAACOMP iOS
//
//  Created by Rafael Escaleira on 13/06/20.
//  Copyright © 2020 Rafael Escaleira. All rights reserved.
//

import UIKit
import Firebase
import M13Checkbox

class SignUpTableViewCell: UITableViewCell, UINavigationControllerDelegate, UIImagePickerControllerDelegate, MDatePickerViewDelegate {
    
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var cpfTextField: UITextField!
    @IBOutlet weak var rgaTextField: UITextField!
    @IBOutlet weak var birthdayTextField: UITextField!
    @IBOutlet weak var phoneTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var courseTextField: UILabel!
    
    @IBOutlet weak var userImage: UIImageView!
    @IBOutlet weak var chooseButton: UIButton!
    @IBOutlet weak var signUpButton: UIButton!
    @IBOutlet weak var termsButton: UIButton!
    @IBOutlet weak var coursesButton: UIButton!
    @IBOutlet weak var dateView: UIView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    @IBOutlet weak var termsCheckBox: M13Checkbox!
    
    private var picker = UIImagePickerController()
    var controller: SignUpViewController!
    
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
        self.coursesButton.addTarget(self, action: #selector(self.courseDidChange), for: .touchUpInside)
        self.signUpButton.addTarget(self, action: #selector(self.signUpAction), for: .touchUpInside)
        
        dateView.addSubview(MDate)
       
        NSLayoutConstraint.activate([
            NSLayoutConstraint(item: MDate, attribute: .leading, relatedBy: .equal, toItem: dateView, attribute: .leading, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: MDate, attribute: .trailing, relatedBy: .equal, toItem: dateView, attribute: .trailing, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: MDate, attribute: .bottom, relatedBy: .equal, toItem: dateView, attribute: .bottom, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: MDate, attribute: .top, relatedBy: .equal, toItem: dateView, attribute: .top, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: MDate, attribute: .height, relatedBy: .equal, toItem: .none, attribute: .notAnAttribute, multiplier: 1, constant: 200)
        ])
        
        termsCheckBox.boxType = .square
        termsCheckBox.boxLineWidth = 2
        termsCheckBox.checkmarkLineWidth = 2
        termsCheckBox.animationDuration = 0.5
        termsCheckBox.checkState = .unchecked
        termsCheckBox.tintColor = .systemBlue
    }
    
    @objc func cpfDidChange(textField: UITextField) { textField.text = textField.text?.applyMask(.cpf) }
    @objc func rgaDidChange(textField: UITextField) { textField.text = textField.text?.applyMask(.rga) }
    @objc func phoneDidChange(textField: UITextField) { textField.text = textField.text?.applyMask(.phone) }
    
    @objc func courseDidChange() {
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        guard let controller = storyboard.instantiateViewController(withIdentifier: "CoursesViewController") as? CoursesViewController else { return }
        controller.delegate = self.controller.self
        controller.datasource = self.controller.self
        controller.isSignUpPage = false
        self.controller.navigationController?.pushViewController(controller, animated: true)
    }
    
    @objc func signUpAction() {
        
        self.isLoading(true)
        
        let isValid = self.verifyFields()
        
        if isValid.isSuccess {
            
            Auth.auth().createUser(withEmail: self.emailTextField.text ?? "", password: self.passwordTextField.text ?? "") { (auth, error) in
                
                if error == nil {
                    
                    let currentUser = Auth.auth().currentUser
                    
                    guard let imageData = self.userImage.image?.jpegData(compressionQuality: 0.8) else {
                        Alert(isSuccess: false, title: "Erro ao carregar imagem", message: "Selecione uma imagem válida", style: .alert).show(controller: self.controller)
                        self.isLoading(false)
                        return
                    }
                    
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
                            
                            let user: [String: Any] = [
                                "birthday": self.birthdayTextField.text ?? "",
                                "completeName": self.nameTextField.text ?? "",
                                "contact": self.phoneTextField.text ?? "",
                                "course": self.courseTextField.text ?? "",
                                "cpf": self.cpfTextField.text ?? "",
                                "email": self.emailTextField.text ?? "",
                                "image": url?.absoluteString ?? "",
                                "paymentStatusUUID": "7db8d5ed-ce64-47d0-af4f-f17cdf783f7e",
                                "paymentTypeUUID": "36a0d633-03db-490b-8006-0e5df20cea30",
                                "rga": self.rgaTextField.text ?? ""
                            ]
                            
                            Download.getPath(databaseKey: .users).child(currentUser?.uid ?? "").updateChildValues(user) { (error, databaseReference) in
                                
                                if error == nil {
                                    
                                    self.isLoading(false)
                                    self.controller.navigationController?.popViewController(animated: true)
                                }
                                
                                else {
                                    Alert(isSuccess: false, title: "Erro ao Cadastrar-se", message: error?.localizedDescription, style: .alert).show(controller: self.controller)
                                    self.isLoading(false)
                                }
                            }
                        }
                    }
                }
                
                else {
                    Alert(isSuccess: false, title: "Erro ao Cadastrar-se", message: error?.localizedDescription, style: .alert).show(controller: self.controller)
                    self.isLoading(false)
                }
            }
        }
        
        else {
            self.isLoading(false)
            isValid.show(controller: self.controller)
        }
    }
    
    func verifyFields() -> (Alert) {
        
        if self.userImage.image == nil || userImage.image == UIImage() || userImage.isEqualTo(image: #imageLiteral(resourceName: "user-circle")) { return (Alert(isSuccess: false, title: "Campo Vazio", message: "Selecione uma foto para prosseguir com o cadastro", style: .alert)) }
        if self.emailTextField.text?.isEmpty != false { return (Alert(isSuccess: false, title: "Campo Vazio", message: "Preencha o campo e-mail para prosseguir com o cadastro", style: .alert)) }
        if self.passwordTextField.text?.isEmpty != false { return (Alert(isSuccess: false, title: "Campo Vazio", message: "Preencha o campo senha para prosseguir com o cadastro", style: .alert)) }
        if self.nameTextField.text?.isEmpty != false { return (Alert(isSuccess: false, title: "Campo Vazio", message: "Preencha o campo nome completo para prosseguir com o cadastro", style: .alert)) }
        if self.cpfTextField.text?.isEmpty != false { return (Alert(isSuccess: false, title: "Campo Vazio", message: "Preencha o campo CPF para prosseguir com o cadastro", style: .alert)) }
        if self.rgaTextField.text?.isEmpty != false { return (Alert(isSuccess: false, title: "Campo Vazio", message: "Preencha o campo RGA para prosseguir com o cadastro", style: .alert)) }
        if self.birthdayTextField.text?.isEmpty != false { return (Alert(isSuccess: false, title: "Campo Vazio", message: "Preencha o campo data de nascimento para prosseguir com o cadastro", style: .alert)) }
        if self.phoneTextField.text?.isEmpty != false { return (Alert(isSuccess: false, title: "Campo Vazio", message: "Preencha o campo telefone para prosseguir com o cadastro", style: .alert)) }
        if self.courseTextField.text?.isEmpty != false { return (Alert(isSuccess: false, title: "Campo Vazio", message: "Preencha o campo curso para prosseguir com o cadastro", style: .alert)) }
        if self.termsCheckBox.checkState == .unchecked { return (Alert(isSuccess: false, title: "Termos e Condições de Uso", message: "Aceite os termos e condições de uso.", style: .alert)) }
        
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
        self.userImage.image = image
        self.controller.tableView.reloadData()
    }
    
    private func isLoading(_ sender: Bool) {
        
        let mode: VisibleMode = sender ? .disappear : .appear
        
        self.chooseButton.visibleMode(mode: mode, 0.4)
        self.signUpButton.visibleMode(mode: mode, 0.4)
        
        if sender { self.activityIndicator.startAnimating() }
        else { self.activityIndicator.stopAnimating() }
    }
}
