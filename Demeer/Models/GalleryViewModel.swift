//
//  GalleryViewModel.swift
//  Demeer
//
//  Created by Alex Demerjian on 7/8/23.
//

import Foundation
import SwiftUI

class GalleryViewModel: ObservableObject{
    
    //create array of compositions for gallery view
    @Published var compositionGroupViews: [CompositionGroupView] = [CompositionGroupView()]
    
    
    func upload(compositionUpload: CompositionUpload) async -> Bool{
        
        guard let sessionID = CurrentUser.shared.SessionID else {print("Missing Session ID"); return false}
        
        let result = await Network.shared.uploadImage(sessionID: sessionID, imageName: compositionUpload.imageName, image: compositionUpload.image, compositionTitle: compositionUpload.title, compositionDescription: compositionUpload.description, compositionForAdults: compositionUpload.adultOnly, compositionPrivate: compositionUpload.isPrivate)
        
        switch result{
            
        case.success(let successString):
            print(successString)
            return true
            
        case.failure(let apiError):
            print("An issue occurred: " + apiError.localizedDescription)
            return false
        }
    }
    
    /*
    func reFetchComposition(index: Int, contentID: Int)
    {
        
        apiRequest1.getImage(sessionID: currentUser.SessionID, contentID: contentID, random: 0, completion:{
                result in
                switch result
                {
            
                    case.success(let compositionCallBack):
                    
                        DispatchQueue.main.async
                        {
                            compositions[index].image = compositionCallBack.image
                        }
                        
                    case.failure(_):
                    
                        print("An issue occurred fetching the image with CID: " + String(contentID) + " from the server.")
                }
            })
        
    }
     */
    
    /*
    
    func getImageForGrid(contentID: Int) -> Image
    {
        var finalImage: Image =
        
            apiRequest1.getImage(sessionID: UserDefaults.standard.value(forKey: "SessionID") as! String, contentID: contentID, random: 0, completion: {
            result in
            switch result{
                
            case.success(let image):
                finalImage = image
                
            case.failure(_):
                print("An issue occurred fetching the image with CID: " + String(contentID) + " from the server.")
                
            }})
        
        return finalImage
    }
     */
}
