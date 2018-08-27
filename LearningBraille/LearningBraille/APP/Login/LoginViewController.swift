//
//  LoginViewController.swift
//  LearningBraille
//
//  Created by George Gomes on 20/08/18.
//  Copyright © 2018 George Gomes. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import Firebase

enum AlertType: String{
    case sucess = "Sucess"
    case fail = "Failure"
}

class LoginViewController: UIViewController{
    
    private var loginViewModel: LoginViewModel!
    private let disposeBag = DisposeBag()
    
    @IBOutlet weak var tfEmail: UITextField!
    @IBOutlet weak var tfPassword: UITextField!
    
    @IBOutlet weak var btForgotPassword: UIButton!
    @IBOutlet weak var btSignIn: UIButton!
    
    var attempts: Int = 0 {
        didSet{
            if attempts >= 3{
                self.btForgotPassword.setTitle("forgot your password?", for: .normal)
            }
        }
    }
    
    var text: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.loginViewModel = LoginViewModel()

        self.btForgotPassword.setTitle("", for: .normal)
        self.hideKeyboard()
        
        setupBindings()
    }
    
    @IBAction func btForgotPassword(_ sender: Any) {
        print(self.text)
    }

    @IBAction func btCreateAcc(_ sender: Any) {

    }
    
    // Mark: - Setup bindings
    
    func setupBindings(){
        // setup tex field bildings
        _ = self.tfEmail.rx.text.map{ $0 ?? "" }.bind(to: self.loginViewModel.email)
        _ = self.tfPassword.rx.text.map{ $0 ?? "" }.bind(to: self.loginViewModel.password)

        // setup button bindigns
        self.btSignIn.rx.tap
            .bind(to: self.loginViewModel.signInDidTapSubject)
            .disposed(by: self.disposeBag);
        
        self.loginViewModel.loginActionResult.asObservable().subscribe{
            
        }.disposed(by: disposeBag)
        
        _ = self.loginViewModel.loginActionResult.asObservable().subscribe(onNext: { [unowned self] response in
            switch response{
            case .error(let err):
                print(err)
                self.createAllert(with: .fail, message: "Falha ao logar", action: nil)
            case .success(let usr):
                print(usr)
                self.createAllert(with: .sucess, message: "Logado com sucesso", action: {
                    self.performSegue(withIdentifier: "unwindToMain", sender: nil)
                })
            }
        })
    }
    
    func createAllert(with type:AlertType,  message: String, action: (()-> Void)?) {
        let alert = UIAlertController(title: type.rawValue, message: message, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (aler) in
            if let act = action{
                act()
            }
        }))
         self.present(alert, animated: true, completion: nil)
    }
}

extension LoginViewController {
    func hideKeyboard() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(LoginViewController.dismissKeyboard))
    
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard(){
        view.endEditing(true)
    }
}

extension String {
    func translateFBError() -> String! {
        return (range(of: "\"")?.upperBound).flatMap { substringFrom in
            (range(of: "\"", range: substringFrom..<endIndex)?.lowerBound).map { substringTo in
                String(self[substringFrom..<substringTo])
            }
        }
    }
}
