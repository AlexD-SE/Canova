//
//  LoginViewModel.swift
//  Demeer
//
//  Created by Alex Demerjian on 7/8/23.
//

import Foundation

class LoginViewModel: ObservableObject{
    
    @Published public var loadingLogin: Bool = false
    @Published public var alertTitle: String = ""
    @Published public var alertMessage: String = ""
    @Published public var showAlert: Bool = false
    
    
    func login(username: String, password: String) async{
        
        let result = await Network.shared.login(username: username, password: password)
        
        DispatchQueue.main.async{
            self.loadingLogin = false
        }
        
        switch result{
                
        case.success(let newUser):
                
            UserDefaults.standard.set(newUser.session.SessionID, forKey: "SessionID")
            UserDefaults.standard.set(newUser.session.timestamp, forKey: "timestamp")
            UserDefaults.standard.set(newUser.user.uid, forKey: "uid")
            UserDefaults.standard.set(newUser.user.firstname, forKey: "firstName")
            UserDefaults.standard.set(newUser.user.lastname, forKey: "lastName")
            UserDefaults.standard.set(newUser.user.phone1, forKey: "phone1")
            UserDefaults.standard.set(newUser.user.email1, forKey: "email1")
            UserDefaults.standard.set(newUser.user.status, forKey: "status")
            UserDefaults.standard.set(newUser.user.lastlogin, forKey: "lastlogin")
                
            
            DispatchQueue.main.async{
                CurrentUser.shared.SessionID = UserDefaults.standard.value(forKey: "SessionID") as? String
                CurrentUser.shared.timestamp = UserDefaults.standard.value(forKey: "timestamp") as? String
                CurrentUser.shared.uid = UserDefaults.standard.value(forKey: "uid") as? String
                CurrentUser.shared.firstname = UserDefaults.standard.value(forKey: "firstName") as? String
                CurrentUser.shared.lastname = UserDefaults.standard.value(forKey: "lastName") as? String
                CurrentUser.shared.phone1 = UserDefaults.standard.value(forKey: "phone1") as? String
                CurrentUser.shared.email1 = UserDefaults.standard.value(forKey: "email1") as? String
                CurrentUser.shared.status = UserDefaults.standard.value(forKey: "status") as? String
                CurrentUser.shared.lastlogin = UserDefaults.standard.value(forKey: "lastlogin") as? String
            }
                
        case.failure(let error):
            
            DispatchQueue.main.async{
                self.alertTitle = "Login Failed"
                self.alertMessage = error.localizedDescription
                self.showAlert = true
            }
                
        }
    }
}
