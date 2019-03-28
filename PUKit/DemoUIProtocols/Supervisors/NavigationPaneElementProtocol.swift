//
//  NavigationPaneElementProtocol.swift
//  DemoUIProtocols
//
//  Created by Henry Zhang on 3/26/19.
//  Copyright © 2019 Henry Zhang. All rights reserved.
//

import Foundation
import PUKit

public protocol NavigationPaneElementDelegate: NSObjectProtocol {
  func navigationDidInvoke(element: NavigationPaneElementProtocol, with navigationInfo: [String: Any])
}

public protocol NavigationPaneElementProtocol: PUKLayoutProtocol {
  var delegate: NavigationPaneElementDelegate? { get set }
}
