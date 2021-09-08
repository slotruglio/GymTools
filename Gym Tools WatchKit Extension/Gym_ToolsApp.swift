//
//  Gym_ToolsApp.swift
//  Gym Tools WatchKit Extension
//
//  Created by Samuele Lo Truglio on 08/09/21.
//

import SwiftUI

@main
struct Gym_ToolsApp: App {
    @SceneBuilder var body: some Scene {
        WindowGroup {
            NavigationView {
                ContentView()
            }
        }

        WKNotificationScene(controller: NotificationController.self, category: "myCategory")
    }
}
