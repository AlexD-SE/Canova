//
//  ColorData.swift
//  Demeer
//
//  Created by Alex Demerjian on 1/14/23.
//

import Foundation
import SwiftUI

struct ColorData
{
    func saveSelectedAppColor(selectedAppColor: Color)
    {
        let color = UIColor(selectedAppColor).cgColor
        
        UserDefaults.standard.set(color.components, forKey: "selectedAppColor")
    }
    
    func loadSelectedAppColor() -> Color
    {
        guard let colorArray = UserDefaults.standard.object(forKey: "selectedAppColor") as? [CGFloat] else
        {
            return Color.blue
        }
        
        let selectedAppColor = Color(.sRGB, red: colorArray[0], green: colorArray[1], blue: colorArray[2], opacity: colorArray[3])
        
        return selectedAppColor
    }
    
}

