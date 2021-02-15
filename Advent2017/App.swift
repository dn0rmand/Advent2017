//
//  Advent2017App.swift
//  Advent2017
//
//  Created by Dominique Normand on 2/14/21.
//

import SwiftUI

class AppDelegate: NSObject, NSApplicationDelegate {
	func applicationShouldTerminateAfterLastWindowClosed(_ sender: NSApplication) -> Bool {
		return true
	}
}

@main
struct Advent2017App: App {
	@NSApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
	
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
