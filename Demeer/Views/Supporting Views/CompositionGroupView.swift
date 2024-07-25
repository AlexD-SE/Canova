//
//  TumbnailView.swift
//  Demeer
//
//  Created by Alex Demerjian on 7/8/23.
//

import SwiftUI

struct CompositionGroupView: View{
    
    @State private var compositionGroup: [Composition] = [Composition(), Composition(), Composition(), Composition()]
    @State private var timer: Timer?
    
    var body: some View{
        
        VStack{
            
            HStack{
                
                ForEach(0..<2, id: \.self){
                    index in
                    
                    NavigationLink(destination: CompositionView(composition: compositionGroup[index]), label:{
                        
                        if let compositionImage = compositionGroup[index].image{
                            compositionImage
                                .resizable()
                                .cornerRadius(7)
                                .padding(5)
                                .background(.black)
                                .cornerRadius(10.0)
                                .scaledToFit()
                                .padding([.leading, .trailing, .top], 10)
                        }else{
                            
                            Image(systemName: "paintbrush.pointed")
                                .resizable()
                                .cornerRadius(7)
                                .padding(5)
                                .background(.black)
                                .cornerRadius(10.0)
                                .scaledToFit()
                                .padding([.leading, .trailing, .top], 10)
                                .symbolEffect(.pulse.byLayer)
                        }
                    })
                }
                
            }
                               
            HStack{
                
                ForEach(2..<4, id:\.self){
                    
                    index in
                    
                    NavigationLink(destination: CompositionView(composition: compositionGroup[index]), label:{
                        
                        if let compositionImage = compositionGroup[index].image{
                            compositionImage
                                .resizable()
                                .cornerRadius(7)
                                .padding(5)
                                .background(.black)
                                .cornerRadius(10.0)
                                .scaledToFit()
                                .padding([.leading, .trailing, .top], 10)
                        }else{
                            
                            Image(systemName: "paintbrush.pointed")
                                .resizable()
                                .cornerRadius(7)
                                .padding(5)
                                .background(.black)
                                .cornerRadius(10.0)
                                .scaledToFit()
                                .padding([.leading, .trailing, .top], 10)
                                .symbolEffect(.pulse.byLayer)
                        }
                        
                    })
                }
            }
        }
        .onAppear{
            
            if compositionGroup[0].image == nil{
                
                timer = Timer.scheduledTimer(withTimeInterval: TimeInterval(2.0), repeats: false){
                    _ in
                    
                    Task.init(priority: .userInitiated){
                        
                        //create random content ids
                        var contentIDs: [Int] = []
                        
                        while contentIDs.count < 4{
                            
                            let randomNum = Int.random(in: 1..<40)
                            
                            if !contentIDs.contains(randomNum){
                                
                                contentIDs.append(randomNum)
                            }
                        }
                        
                        //get the compositions corresponding to those content ids
                        await getCompositions(contentIDs: contentIDs)
                    }
                }
            }
            
        }.onDisappear(){
            
            //invalidate the timer if its not nil
            if timer != nil{

                timer?.invalidate()
                timer = nil
                
            }
            
        }
    }
    
    func getCompositions(contentIDs: [Int]) async {
        
        for index in 0..<contentIDs.count{
            
            guard let sessionID = CurrentUser.shared.SessionID else{return print("Missing Session ID")}
            
            let result = await Network.shared.getImage(sessionID: sessionID, contentID: contentIDs[index], random: 0)
            
            switch result{
                
            case.success(let compositionCallBack):
                
                if compositionCallBack.message != ""{
                    print(compositionCallBack.message + " with CID: " + String(compositionCallBack.contentID))
                }
                
                compositionGroup[index].contentID = compositionCallBack.contentID
                
                DispatchQueue.main.async{
                    compositionGroup[index].image = compositionCallBack.image
                }
                
            case.failure(_):
                print("An error occurred fetching the image from the server.")
            }
            
            do{
                try await Task.sleep(nanoseconds: 500)
            }catch{
                print(error)
            }
            
        }
        
    }
    
    
}
