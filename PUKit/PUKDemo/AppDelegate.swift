//
//  AppDelegate.swift
//  PUKDemo
//
//  Created by Henry Zhang on 3/25/19.
//  Copyright © 2019 Henry Zhang. All rights reserved.
//

import Cocoa
import DemoUIImpl

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {

//  @IBOutlet weak var window: NSWindow!
  var window: NSWindow!
  var rootVC: RootSupervisorVC!

  func applicationDidFinishLaunching(_ aNotification: Notification) {

    guard let mainWindow = NSApplication.shared.windows.first else {
      return
    }

    window = mainWindow

    rootVC = RootSupervisorVC(nibName: nil, bundle: nil, forWindow: window)
    window.delegate = rootVC

    let content = window!.contentView! as NSView
    let view = rootVC!.view
    content.addSubview(view)
  }

  func applicationWillTerminate(_ aNotification: Notification) {
    // Insert code here to tear down your application
  }
}
