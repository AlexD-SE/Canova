//
//  CompositionView.swift
//  Demeer
//
//  Created by Alex Demerjian on 1/5/23.
//

import SwiftUI

struct CompositionView: View
{
    @EnvironmentObject var currentUser: CurrentUser
    @State var composition: Composition
    @State var isFullScreen = false
    @State var scale: CGFloat = 1.0
    @State var dragOffset: CGSize = CGSize(width: UIScreen.main.bounds.width/2, height: UIScreen.main.bounds.height/3)
    
    var body: some View
    {
        GeometryReader
        {
            geometry in
            
            ZStack()
            {
                VStack
                {
                    HStack
                    {
                        
                        Text("Composition Title")
                            .font(.custom(
                                "Baskerville Bold",
                                fixedSize: 36))
                            .padding(5)
                        
                    }
                    .frame(width: geometry.size.width-20)
                    .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 10, style: .continuous))
                    .cornerRadius(10)
                    
                    /*
                    composition.image
                        .resizable()
                        .scaledToFit()
                        .cornerRadius(7)
                        .padding(5)
                        .background(ColorData().loadSelectedAppColor())
                        .cornerRadius(10.0)
                        .padding([.leading, .trailing], 5)
                        .onTapGesture
                        {
                            withAnimation
                            {
                                isFullScreen.toggle()
                            }
                        }
                     */
                    HStack
                    {
                        VStack
                        {
                            Button(action: {}, label: {
                                
                                HStack
                                {
                                    Image(systemName: "person.crop.circle")
                                        .resizable()
                                        .foregroundColor(.blue)
                                        .background(.white)
                                        .cornerRadius(10)
                                        .padding(2)
                                        .frame(width:40, height: 40)
                                        .background(.black)
                                        .cornerRadius(10)
                                        .padding([.top, .leading, .bottom], 3)
                                    
                                    Text("ChrissyCakes")
                                        .foregroundColor(.black)
                                        .font(.custom(
                                            "Baskerville Bold",
                                            fixedSize: 20))
                                        .lineLimit(1)
                                        .truncationMode(.tail)
                                        .padding(.trailing, 5)
                                }
                                .background(ColorData().loadSelectedAppColor())
                                
                            })
                            
                            
                            Text("Uploaded 1/2/23")
                                .font(.custom(
                                    "Baskerville Bold",
                                    fixedSize: 20))
                            
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding([.bottom, .top, .trailing],5)
                        
                        HStack
                        {
                            VStack
                            {
                                Button(action: {}, label: {
                                    
                                    Image(systemName: "bubble.left")
                                        .resizable()
                                        .frame(width: 30, height: 30)
                                        .foregroundColor(ColorData().loadSelectedAppColor())
                                        .padding(8)
                                    
                                })
                                
                                
                                Text("3")
                                    .font(.custom(
                                        "Baskerville Bold",
                                        fixedSize: 20))
                                
                                
                            }
                            
                            VStack
                            {
                                
                                Button(action: {}, label: {
                                    
                                    Image(systemName: "hand.thumbsup")
                                        .resizable()
                                        .frame(width: 30, height: 30)
                                        .foregroundColor(ColorData().loadSelectedAppColor())
                                        .padding(8)
                                    
                                })
                                
                                
                                Text("15")
                                    .font(.custom(
                                        "Baskerville Bold",
                                        fixedSize: 20))
                                
                            }
                            
                            VStack
                            {
                                Button(action: {}, label: {
                                    
                                    Image(systemName: "hand.thumbsdown")
                                        .resizable()
                                        .frame(width: 30, height: 30)
                                        .foregroundColor(ColorData().loadSelectedAppColor())
                                        .padding(8)
                                    
                                })
                                
                                
                                Text("1")
                                    .font(.custom(
                                        "Baskerville Bold",
                                        fixedSize: 20))
                                
                            }
                            
                        }
                        .frame(maxWidth: .infinity, alignment: .trailing)
                        .padding([.bottom, .trailing, .top],5)
                        
                        
                        
                        
                    }
                    .frame(width: geometry.size.width-20)
                    .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 10, style: .continuous))
                    .cornerRadius(10)
                    
                    
                    
                    
                    Text("Description: ")
                        .underline()
                        .font(.custom(
                            "Baskerville Bold",
                            fixedSize: 25))
                    
                    Text("")
                    
                }
                //center the vstack inside the zstack (both width and height)
                .position(x: geometry.size.width / 2, y: geometry.size.height / 2)
                
                
            
                
                 if (isFullScreen)
                 {
                     Color.black
                        .opacity(0.99)
                        .ignoresSafeArea()
                     /*
                     composition.image
                        .resizable()
                        .scaleEffect(scale)
                        .position(x: dragOffset.width, y: dragOffset.height)
                        .gesture(DragGesture()
                            .onChanged
                            {
                                value in
                            
                                let compositionFrame = geometry.frame(in: .global)
                            
                                let changeInDragGesture = value.translation
                            
                                dragOffset.width += changeInDragGesture.width/50
                                dragOffset.height += changeInDragGesture.height/50
                                
                            }
                        )
                        .gesture(MagnificationGesture()
                            .onChanged
                            {
                                value in
                                     
                                withAnimation {
                                
                                    scale = value
                                }
                            }
                            .onEnded
                            {
                                value in
                            
                                scale = value
                                
                            }
                        )
                     */
                     VStack
                     {
                         Spacer()
                         HStack()
                         {
                             Button()
                             {
                                 dragOffset.width = UIScreen.main.bounds.width/2
                                 dragOffset.height = UIScreen.main.bounds.height/3
                                 scale = 1
                             }
                            label:
                             {
                                 HStack
                                 {
                                     Image(systemName: "arrow.triangle.2.circlepath")
                                     Text("Reset")
                                 }
                             }
                             .buttonStyle(.bordered)
                             .background(Color(UIColor.systemBackground).cornerRadius(8))
                             .padding([.leading, .top, .bottom], 5)
                             
                             Button("Done")
                             {
                                 
                                isFullScreen.toggle()
                                 
                             }
                             .buttonStyle(.bordered)
                             .background(Color(UIColor.systemBackground).cornerRadius(8))
                             .padding([.trailing, .top, .bottom], 5)
                         }
                         .background(ColorData().loadSelectedAppColor().cornerRadius(8))
                         .backgroundStyle(.ultraThinMaterial)
                         .padding()
                     }
                     
                     
                     
                 }
                 
                
            }
            
            
            
        }
        .onAppear(perform: {
            
            /*
            apiRequest.getImage(sessionID: currentUser.SessionID, contentID: contentID, random: 0, completion: {
                
                result in
                switch result
                {
                    
                case.success(let composition):
                    
                    if composition.message != ""
                    {
                        print(composition.message + " with CID: " + String(composition.contentID))
                    }
                    
                    DispatchQueue.main.async
                    {
                        self.composition = composition.image
                    }
                    
                case.failure(_):
                    
                    print("An error occurred fetching the image from the server.")
                }
            
            })
            */
        })
        
    }
    
}
