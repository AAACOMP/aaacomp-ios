//
//  SignInTableViewCell.swift
//  AAACOMP iOS
//
//  Created by Rafael Escaleira on 13/06/20.
//  Copyright © 2020 Rafael Escaleira. All rights reserved.
//

import UIKit
import Firebase

class SignInTableViewCell: UITableViewCell {
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var signInButton: UIButton!
    @IBOutlet weak var signUpButton: UIButton!
    @IBOutlet weak var forgotPasswordButton: UIButton!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    private var controller: UserViewController!
    private var auth: Auth!

    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.signInButton.addTarget(self, action: #selector(self.signInButtonAction), for: .touchUpInside)
        self.signUpButton.addTarget(self, action: #selector(self.signUpButtonAction), for: .touchUpInside)
        self.forgotPasswordButton.addTarget(self, action: #selector(self.forgotPasswordButtonAction), for: .touchUpInside)
    }
    
    func setCell(controller: UserViewController, auth: Auth) {
        self.controller = controller
        self.auth = auth
    }
    
    @objc private func signInButtonAction() {
        
        self.isLoading(true)
        
        if (self.emailTextField.text?.isEmpty == false) && (self.passwordTextField.text?.isEmpty == false) {
            
            self.auth.signIn(withEmail: self.emailTextField.text ?? "", password: self.passwordTextField.text ?? "") { (authDataResult, error) in
                
                if error == nil {
                    
                    self.emailTextField.text = ""
                    self.passwordTextField.text = ""
                    
                    self.isLoading(false)
                    self.controller.loadData(uid: self.auth.currentUser?.uid ?? "")
                }
                    
                else {
                    self.isLoading(false)
                    Alert(isSuccess: false, title: "Erro ao fazer login", message: error?.localizedDescription, style: .alert).show(controller: self.controller)
                }
            }
        }
        
        else {
            self.isLoading(false)
            Alert(isSuccess: false, title: "Campos Vazios", message: "Para efetuar o login é necessário preencher todos os campos", style: .alert).show(controller: self.controller)
        }
    }

    @objc private func signUpButtonAction() {
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        guard let controller = storyboard.instantiateViewController(withIdentifier: "SignUpViewController") as? SignUpViewController else { return }
        self.controller.navigationController?.pushViewController(controller, animated: true)
    }
    
    @objc private func forgotPasswordButtonAction() {
        
        let alert = Alert(isSuccess: true, title: "Esqueceu sua senha?", message: "Informe seu e-mail que enviaremos um link para você", style: .alert)
        
        alert.alert.addTextField { (textField) in
            textField.placeholder = "Informe seu e-mail"
        }
        
        alert.alert.addAction(UIAlertAction(title: "Enviar Link", style: .default, handler: { (_) in
            
            if alert.alert.textFields?.first?.text?.isEmpty == false {
                
                self.auth.sendPasswordReset(withEmail: alert.alert.textFields?.first?.text ?? "") { (error) in
                    
                    if error == nil {
                        Alert(isSuccess: false, title: "Sucesso ao enviar link", message: "Um link foi enviado ao seu e-mail, verifique na caixa de Spam.", style: .alert).show(controller: self.controller)
                    }
                    
                    else { Alert(isSuccess: false, title: "Erro ao enviar link", message: error?.localizedDescription, style: .alert).show(controller: self.controller) }
                }
            }
            
            else { Alert(isSuccess: false, title: "Campo Vazio", message: "Preencha o campo do e-mail para podermos lhe enviar o link", style: .alert).show(controller: self.controller) }
        }))
        
        alert.show(controller: self.controller)
    }
    
    private func isLoading(_ sender: Bool) {
        
        let mode: VisibleMode = sender ? .disappear : .appear
        
        self.signInButton.visibleMode(mode: mode, 0.4)
        self.signUpButton.visibleMode(mode: mode, 0.4)
        self.forgotPasswordButton.visibleMode(mode: mode, 0.4)
        
        if sender { self.activityIndicator.startAnimating() }
        else { self.activityIndicator.stopAnimating() }
    }
}
