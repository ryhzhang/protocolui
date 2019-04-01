//
//  AppDelegate.swift
//  PUKDemo
//
//  Created by Henry Zhang on 3/25/19.
//  Copyright © 2019 Henry Zhang. All rights reserved.
//

import Cocoa
import CocoaLumberjackSwift
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
    DDLog.sharedInstance.log(asynchronous: true, message: DDLogMessage(message: "Hello", level: .debug, flag: .info, context: 0, file: "", function: "", line: 0, tag: nil, options: .copyFile, timestamp: Date()))
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
