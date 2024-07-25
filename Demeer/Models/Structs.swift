//
//  Structs.swift
//  Demeer
//
//  Created by Alex Demerjian on 1/7/23.
//

import Foundation
import SwiftUI

struct NewUser: Decodable{
    
    var session: Session
    var user: User
    
    struct Session: Decodable{
        var SessionID: String
        var timestamp: String
    }
    
    struct User: Decodable{
        var uid: String
        var firstname: String
        var lastname: String
        var phone1: String
        var email1: String
        var status: String
        var lastlogin: String
    }
    
}

struct Composition{
    
    var image: Image? = nil
    var contentID: Int? = nil
    
}

struct CompositionUpload{
    
    var imageName: String
    var image: UIImage
    var title: String
    var description: String
    var adultOnly: Bool
    var isPrivate: Bool
    
    init(imageName: String, image: UIImage, title: String, description: String, adultOnly: Bool, isPrivate: Bool) {
        self.imageName = imageName
        self.image = image
        self.title = title
        self.description = description
        self.adultOnly = adultOnly
        self.isPrivate = isPrivate
    }
    
}
