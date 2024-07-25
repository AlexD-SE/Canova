//
//  SearchView.swift
//  Salon
//
//  Created by Alex Demerjian on 8/8/22.
//

import SwiftUI

struct SearchView: View
{
    @State private var searchText = ""
    @State private var searchFor = "Composition"
    @State private var screenWidth = UIScreen.main.bounds.width
    @State private var screenHeight = UIScreen.main.bounds.height
    let searchForOptions = ["Composition", "User"]
    
    var body: some View
    {
        
        NavigationStack
        {
            
            VStack
            {
                HStack
                {
                    Text("For: ")
                    Picker ("", selection: $searchFor)
                    {
                        ForEach(searchForOptions, id: \.self)
                        {
                            Text($0)
                        }
                    }
                    .pickerStyle(.menu)
                }
                .frame(width: 300, height: 25, alignment: .leading)
            }
            .position(x: 175, y: screenHeight * (1/64))
            .navigationTitle("Search")
            
        }
        .searchable(text:$searchText)
            
            
    }
}
