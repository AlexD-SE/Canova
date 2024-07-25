//
//  CurrentUser.swift
//  Demeer
//
//  Created by Alex Demerjian on 1/7/23.
//

import Foundation

class CurrentUser: ObservableObject{
    
    @Published var SessionID: String? = nil
    @Published var timestamp: String? = nil
    @Published var uid: String? = nil
    @Published var firstname: String? = nil
    @Published var lastname: String? = nil
    @Published var phone1: String? = nil
    @Published var email1: String? = nil
    @Published var status: String? = nil
    @Published var lastlogin: String? = nil
    
    static let shared = CurrentUser()
    
}
