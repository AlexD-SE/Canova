//
//  PostView.swift
//  Salon
//
//  Created by Alex Demerjian on 9/5/22.
//

import SwiftUI

struct PostView: View
{
    var URLAddress: String
    
    var body: some View
    {
        Image(systemName: URLAddress)
            .resizable()
            .padding()
            .frame(width: 200, height: 200)
            .background(Color.green)
            .cornerRadius(15)
    }
}


