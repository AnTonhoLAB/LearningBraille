//
//  Auth.swift
//  LearningBraille
//
//  Created by George Gomes on 20/08/18.
//  Copyright © 2018 George Gomes. All rights reserved.
//

import Foundation
import Firebase
import FirebaseAuth
import RxSwift
import RxCocoa

enum AutenticationError: Error {
    case server
    case badReponse(String)
    case badCredentials
}

enum AutheticationStatus {
    case error(AutenticationError)
    case success(User)
}

class Authentication{
    
    var ref: DatabaseReference!
    
    init() {
        ref = Database.database().reference()
    }
    
    func createUser(with email: String, _ password: String, completion: @escaping (AuthDataResult?, Error?) -> Void){
        Auth.auth().createUser(withEmail: email, password: password) { (res, err) in
            completion(res, err)
        }
    }
    
    func login(with email: String,_ password: String, completion: @escaping (AuthDataResult?, Error?) -> Void){
        Auth.auth().signIn(withEmail: email, password: password) { (res, err) in
            completion(res, err)
        }
    }
    
    func rxLogin(with email: String,_ password: String) -> Observable<AutheticationStatus>  {
       
        return Observable<AutheticationStatus>.create{ observer in
        
            Auth.auth().signIn(withEmail: email, password: password) { (res, err) in
                if err == nil {
                    let usr: User = CoreDataManager.managerInstance().Object()
                    usr.name = res?.user.email
                    usr.email = res?.user.email
                    usr.token = res?.user.uid
                    CoreDataManager.managerInstance().saveThis(usr)
                    observer.onNext(.success(usr))
                    observer.onCompleted()
                }else{

                    observer.onNext(.error(.server))
                    observer.onCompleted()
                }
            }
            return Disposables.create()
        }
    }
}
