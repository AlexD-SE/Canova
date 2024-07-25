//
//  CompositionCallBack.swift
//  Demeer
//
//  Created by Alex Demerjian on 1/6/23.
//

import Foundation
import SwiftUI

class CompositionCallBack{
    
    let image: Image
    let contentID: Int
    let message: String
    
    init(image: Image, contentID: Int, message: String){
        self.image = image
        self.contentID = contentID
        self.message = message
    }
}
