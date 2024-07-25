//
//  SettingsView.swift
//  Salon
//
//  Created by Alex Demerjian on 8/25/22.
//

import SwiftUI


struct SettingsView: View {
    
    @EnvironmentObject private var currentUser: CurrentUser
    @State private var loading: Bool = false
    @State private var alertTitle: String = ""
    @State private var alertMessage: String = ""
    @State private var showAlert: Bool = false
    @State private var selectedAppColor: Color = ColorData().loadSelectedAppColor()
    let colors = [Color.blue, Color.red, Color.yellow, Color.orange, Color.green, Color.brown, Color.pink, Color.indigo, Color.cyan, Color.mint, Color.teal]
    
    var body: some View {
        
        NavigationView(){
            
            ZStack{
                
                VStack{
                    
                    //create button for logout
                    Button{
                        
                        //turn on the loading indicator
                        loading = true
                        
                        //if button is clicked, send apiRequest to logout.php
                        Task.init{
                            let result = await Network.shared.logout()
                            
                            switch result{
                            //if successful, remove the sessionID key
                            case.success(_):
                                
                                //turn off the loading indicator
                                loading = false
                                UserDefaults.standard.removeObject(forKey: "SessionID")
                                
                                //set the SessionID for the currentUser to nothing
                                DispatchQueue.main.async{
                                    currentUser.SessionID = ""
                                }
                                
                                //if fail, print "An issue occurred when attempting to logout
                            case.failure(let logoutError):
                                
                                //turn off the loading indicator
                                loading = false
                                
                                //show alert message
                                alertTitle = "Logout Failed"
                                alertMessage = logoutError.localizedDescription
                                showAlert = true
                                
                            }
                        }
                        
                    }label:{
                        
                        HStack{
                            Image(systemName: "arrow.right.square")
                            Text("Logout")
                        }
                    }
                    .buttonStyle(.bordered)
                    .padding()
                    
                    ColorPicker("App Color: ", selection: $selectedAppColor)
                    .onChange(of: selectedAppColor, perform: { color in
                        
                        ColorData().saveSelectedAppColor(selectedAppColor: color)

                                })
                    .padding([.leading, .trailing],100)
                    
                    
                    .alert(alertTitle, isPresented: $showAlert){
                        
                        Button("OK"){
                            showAlert = false
                            alertTitle = ""
                            alertMessage = ""
                        }
                        
                    }message:{
                        
                        Text(alertMessage)
                    }
                    
                    .navigationTitle("Settings")
                    
                    
                }
               
                if loading == true{
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle(tint:.blue))
                        .frame(width: 50, height: 50)
                        .background(.regularMaterial, in: RoundedRectangle(cornerRadius: 8, style: .continuous))
                }
                
            }
            
            
        }
    
    }
}

