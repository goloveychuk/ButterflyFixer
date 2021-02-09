//
//  AppDelegate.swift
//  App2
//
//  Created by Vadym Holoveichuk on 03.02.2021.
//  Copyright © 2021 Vadym Holoveichuk. All rights reserved.
//

import Cocoa


@main
class AppDelegate: NSObject, NSApplicationDelegate {

    
    var statusItem: NSStatusItem?



    @objc fileprivate func showWindow() {
//        NSApp.activate(ignoringOtherApps: true)
        print("killed")
        exit(1)
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)
        statusItem?.button?.title = "BF";
        statusItem?.button?.action = #selector(showWindow)
    }
    
    func applicationDidFinishLaunching(_ aNotification: Notification) {
        NSApp.setActivationPolicy(.accessory);
        // Insert code here to initialize your application
        startInterceptor()
    }

    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }


}

