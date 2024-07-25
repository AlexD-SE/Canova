//
//  DemeerApp.swift
//  Demeer
//
//  Created by Alex Demerjian on 1/2/23.
//

import SwiftUI

@main
struct DemeerApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            
            LoginView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
