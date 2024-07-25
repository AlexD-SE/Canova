//
//  GalleryView.swift
//  Salon
//
//  Created by Alex Demerjian on 8/8/22.
//

import SwiftUI
import PhotosUI

struct GalleryView: View{
    
    @ObservedObject private var galleryViewModel = GalleryViewModel()
    
    @Environment(\.colorScheme) var currentMode
    
    @State private var viewDidLoad = false
    
    
    @State private var showUploadSheet = false
    @State private var selectedImage: PhotosPickerItem? = nil
    @State private var selectedImageName: String = ""
    @State private var selectedImageData: Data? = nil
    @State private var imageSelected = false
    @State private var compositionTitle = ""
    @State private var compositionDescription = ""
    @State private var compositionForAdults = false
    @State private var compositionPrivate = false
    let deviceType = UIDevice.current.localizedModel
    
    var iPhoneColumns = [
        GridItem(.flexible(), spacing: 3)
        ]
    
    var iPadColumns = [
        GridItem(.flexible(), spacing: 3),
        GridItem(.flexible(), spacing: 3)
        ]
    
    var body: some View {
        
        NavigationView(){
            
            GeometryReader{
                
                geometry in
                
                ScrollView{
                    
                    Button(){
                        
                        showUploadSheet = true
                        
                    }label:{
                        
                        HStack(){
                            
                            Image(systemName: "square.and.arrow.up.circle")
                                .resizable()
                                .frame(width: 25, height: 25)
                            Text("Upload Composition")
                                .font(.title3)
                            
                        }
                        
                    }
                    .padding(.leading, (geometry.size.width*0.40))
                    .padding(.bottom, 20)
                    
                    
                    LazyVGrid(columns: deviceType == "iPhone" ? iPhoneColumns : iPadColumns, spacing:4){
                        
                        ForEach(0..<galleryViewModel.compositionGroupViews.count, id:\.self){
                            
                            index in
                            
                            galleryViewModel.compositionGroupViews[index]
                                .onAppear(perform: {
                                    
                                    //if the last composition group view has appeared, append a new composition group view
                                    if index == galleryViewModel.compositionGroupViews.count-1{
                                        galleryViewModel.compositionGroupViews.append(CompositionGroupView())
                                    }
                                    
                                })
                        }
                        
                    }
                    .background(Color(red: 242 / 255, green: 232 / 255, blue: 223 / 255))
                    .cornerRadius(8.0)
                    .padding(.leading, 10)
                    .padding(.trailing, 10)
                }
                
            }
            .sheet(isPresented: $showUploadSheet, content:
                    {
                
                ScrollView{
                    
                    Text("Upload Composition")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.top, 25)
                        .padding(.leading, 18)
                        .padding(.bottom, 20)
                    
                    if let selectedImageData, let uiImage = UIImage(data: selectedImageData){
                        
                        Text(selectedImageName)
                        Image(uiImage: uiImage)
                            .resizable()
                            .frame(width: 300, height: 300)
                            .border(.black, width: 3)
                            .scaledToFit()
                    }
                    
                    PhotosPicker(selection: $selectedImage, matching: .images, photoLibrary: .shared()){
                        
                        Image(systemName: "photo.stack")
                            .resizable()
                            .frame(width: 30, height: 30)
                        Text("Select Photo")
                    }
                    .onChange(of: selectedImage){
                        
                        newItem in
                        Task{
                            
                            // Retrieve selected asset in the form of Data
                            if let data = try? await newItem?.loadTransferable(type: Data.self){
                                selectedImageData = data
                            }
                            
                            //Use local identifier of selected item to get its name
                            if let localID = newItem?.itemIdentifier{
                                
                                let assets = PHAsset.fetchAssets(withLocalIdentifiers: [localID], options: nil)
                                if let firstAsset = assets.firstObject, let firstResource = PHAssetResource.assetResources(for: firstAsset).first{
                                    
                                    selectedImageName = firstResource.originalFilename
                                }
                            }
                        }
                        imageSelected = true
                    }
                    .padding(.bottom, 25)
                    
                    Rectangle()
                        .fill(.gray)
                        .frame(height:2)
                    
                    Text("Details")
                        .font(.title)
                        .padding(.bottom, 10)
                    
                    VStack{
                        
                        Text("Name:")
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(.leading, 20)
                        
                        TextField("(Required)", text:$compositionTitle)
                            .textFieldStyle(.roundedBorder)
                            .padding(.leading, 20)
                            .padding(.trailing, 20)
                        
                    }
                    .padding(.bottom, 20)
                    
                    VStack{
                        
                        Text("Description:")
                            .padding(.leading, 20)
                            .frame(maxWidth: .infinity, alignment: .leading)
                        
                        TextField("(Required)", text:$compositionDescription, axis: .vertical)
                            .textFieldStyle(.roundedBorder)
                            .padding(.leading, 20)
                            .padding(.trailing, 20)
                    }
                    
                    Toggle(isOn: $compositionForAdults){
                        
                        Text("Adults Only")
                            .padding(.leading, 20)
                    }
                    .padding(.trailing, 40)
                    .padding(.bottom, 10)
                    
                    Toggle(isOn: $compositionPrivate){
                        
                        Text("Private")
                            .padding(.leading, 20)
                    }
                    .padding(.trailing, 40)
                    .padding(.bottom, 10)
                    
                    /*
                    Button("Upload", action: {
                        
                        Task.init(priority: .userInitiated){
                            
                            let result = await galleryViewModel.upload(compositionUpload: CompositionUpload(imageName: selectedImageName, image: UIImage(data: selectedImageData!)!, title: compositionTitle, description: compositionDescription, adultOnly: compositionForAdults, isPrivate: compositionPrivate))
                            
                            switch result{
                            case false: 
                            case true:
                            }
                            
                        }
                        
                        
                    })
                    .buttonStyle(.bordered)
                    .disabled(!(imageSelected) || !(compositionTitle != "") || !(compositionDescription != ""))
                    .padding()
                    
                    */
                    
                    
                }
                
                
            })
            .navigationTitle("Gallery")
        }
        
    }
    
    
}

