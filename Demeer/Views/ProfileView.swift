//
//  ProfileView.swift
//  Salon
//
//  Created by Alex Demerjian on 8/25/22.
//

import SwiftUI

struct ProfileView: View {
    
    @EnvironmentObject var currentUser: CurrentUser
    @State private var showAccountDetailsSheet = false
    @State private var firstName = ""
    @State private var lastName = ""
    @State private var email1 = ""
    @State private var phone1 = ""
    @State private var status = ""
    
    var body: some View{
        
        NavigationView{
            
            VStack{
                
                HStack{
                    
                    if (UserDefaults.standard.value(forKey: "firstName") != nil && UserDefaults.standard.value(forKey: "lastName") != nil){
                        
                        Text((UserDefaults.standard.value(forKey: "firstName") as! String) + " " + (UserDefaults.standard.value(forKey: "lastName") as! String))
                            .font(
                                    .system(size: 35)
                                    .weight(.heavy)
                                )
                    }
                }
                
                Image(systemName: "person.crop.circle")
                    .resizable()
                    .frame(width: 100, height: 100)
                
                Text("Bio: ")
                
                Rectangle()
                    .fill(.gray)
                    .frame(height:2)
                    .padding()
                
                HStack
                {
                    VStack
                    {
                        Text("5")
                        Text("Compositions")
                            .bold()
                    }
                    .padding(.trailing)
                    VStack
                    {
                        Text("25")
                        Text("Admirers")
                            .bold()
                    }
                    .padding(.trailing)
                    VStack
                    {
                        Text("100")
                        Text("Admiring")
                            .bold()
                    }
                }
                
                
                Rectangle()
                    .fill(.gray)
                    .frame(height:2)
                    .padding()
                
                
                Text("Your Images")
            }
            .onAppear(perform:{
                
                /*
                apiRequest1.getUserContentList(sessionID: currentUser.SessionID, uID: 3, sort: "", completion: {
                    result in
                    switch result
                    {
                                                   
                        case.success(let successString):
                        print (successString)
                                                   
                        case.failure(let apiError):
                        print("An issue occurred: " + apiError.description)
                    }})
                */
                
            })
            
            
        }
        
    }
}

