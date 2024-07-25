//
//  LoginView.swift
//  Salon
//
//  Created by Alex Demerjian on 7/28/22.
//

import SwiftUI
import Foundation
import CryptoKit

struct LoginView: View{
    
    @ObservedObject private var loginViewModel = LoginViewModel()
    @State private var username: String = ""
    @State private var password: String = ""
    
    @State private var showAccountCreationSheet = false
    @State private var newAccountFirstName = ""
    @State private var newAccountLastName = ""
    @State private var newAccountUsername = ""
    @State private var newAccountEmail = ""
    @State private var newAccountPhone1 = ""
     
     
     
    let deviceType = UIDevice.current.localizedModel
    
    var body: some View{
        
        if CurrentUser.shared.SessionID == nil{
            
            ZStack{
                
                ScrollView{
                    
                    Text("Welcome To DeMeer!")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .padding(.top, 25)
                    
                    Text("The platform built for artists.")
                        .font(.title2)
                        .foregroundColor(.gray)
                    
                    Image("LoginScreenImage")
                        .resizable()
                        .frame(width: deviceType == "iPhone" ? 300: 500, height: deviceType == "iPhone" ? 300: 500)
                        .padding(20)
                    
                    TextField("Username", text:$username)
                        .textInputAutocapitalization(.never)
                        .disableAutocorrection(true)
                        .textFieldStyle(.roundedBorder)
                        .padding(.leading, 50)
                        .padding(.trailing, 50)
                    SecureField("Password", text:$password)
                        .textInputAutocapitalization(.never)
                        .disableAutocorrection(true)
                        .textFieldStyle(.roundedBorder)
                        .padding(.leading, 50)
                        .padding(.trailing, 50)
                        .padding(.bottom, 25)
                    
                    Button(action:{
                        
                        loginViewModel.loadingLogin = true
                        
                        //perform the login request using the username and password that the user provided
                        Task.init(priority: .userInitiated){
                            
                            await loginViewModel.login(username: username, password: password)
                            
                        }
                    }){
                        
                        Text("Sign In")
                    }
                    .buttonStyle(.borderedProminent)
                    .disabled((username == "") || (password == ""))
                    .padding()
                    
                    HStack{
                        
                        Text("Don't have an account?")
                        Button(action:{
                            showAccountCreationSheet = true
                        })
                        {
                            Text("Create One")
                        }
                        .buttonStyle(.borderless)
                    }
                    
                    
                    Text("Pre-Alpha Build. © 2023 A&R Demerjian")
                        .font(.footnote)
                        .foregroundColor(.gray)
                        .padding(.top, 75)
                    
                }
                
                if loginViewModel.loadingLogin == true{
                    
                    ZStack(){
                        
                        ProgressView()
                            .progressViewStyle(CircularProgressViewStyle(tint:.blue))
                            .frame(width: 50, height: 50)
                            .background(.regularMaterial, in: RoundedRectangle(cornerRadius: 8, style: .continuous))
                    }
                }
                    
            }
            .alert(loginViewModel.alertTitle, isPresented: $loginViewModel.showAlert){
                
                Button("OK"){
                    loginViewModel.showAlert = false
                    loginViewModel.alertTitle = ""
                    loginViewModel.alertMessage = ""
                }
            }
            message:{
                
                Text(loginViewModel.alertMessage)
            }
            .sheet(isPresented: $showAccountCreationSheet, content:
                    {
                
                ScrollView{
                    
                    Text("Create Account")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.top, 25)
                        .padding(.leading, 18)
                        .padding(.bottom, 20)
                    
                    Image(systemName: "person.crop.circle.badge.plus")
                        .resizable()
                        .frame(width: 175, height: 150)
                        .padding()
                    
                    HStack{
                        
                        Text("First Name:")
                        TextField("(Required)", text: $newAccountFirstName)
                            .textFieldStyle(.roundedBorder)
                    }
                    .padding()
                    .padding([.leading, .trailing], 20)
                    
                    HStack{
                        
                        Text("Last Name:")
                        TextField("(Required)", text: $newAccountLastName)
                            .textFieldStyle(.roundedBorder)
                    }
                    .padding()
                    .padding([.leading, .trailing], 20)
                    
                    HStack{
                        
                        Text("Username:")
                        TextField("(Required)", text: $newAccountUsername)
                            .textFieldStyle(.roundedBorder)
                    }
                    .padding()
                    .padding([.leading, .trailing], 20)
                    
                    HStack{
                        
                        Text("Email:")
                        TextField("(Required)", text: $newAccountEmail)
                            .textFieldStyle(.roundedBorder)
                    }
                    .padding()
                    .padding([.leading, .trailing], 20)
                    
                    HStack{
                        
                        Text("Phone:")
                        TextField("(Optional)", text: $newAccountPhone1)
                            .textFieldStyle(.roundedBorder)
                    }
                    .padding()
                    .padding([.leading, .trailing], 20)
                }
                
            })
            
        }else{
                
            TabView{
                SearchView()
                    .tabItem {
                        Label("Search", systemImage: "magnifyingglass.circle")
                }
                    
                GalleryView()
                    .tabItem{
                        Label("Gallery", systemImage: "photo.artframe")
                }
                    
                ProfileView()
                    .tabItem{
                        Label("Profile", systemImage: "person")
                }
                    
                SettingsView()
                    .tabItem{
                        Label("Settings", systemImage: "gearshape")
                }
            }
                
        }
    }
    
    
}
