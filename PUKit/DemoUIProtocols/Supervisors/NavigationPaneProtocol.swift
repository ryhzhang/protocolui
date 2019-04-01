//
//  NavigationSupervisorProtocol.swift
//  PUKit
//
//  Created by Henry Zhang on 3/25/19.
//  Copyright © 2019 Henry Zhang. All rights reserved.
//

import Foundation
import PUKit

public protocol NavigationPaneDelegate: NSObjectProtocol {
  func navigate(to target: CanvasMode)
}

public protocol NavigationPaneProtocol: PUKLayoutProtocol {
  var elements: [NavigationPaneElementProtocol] { get set }
  var delegate: NavigationPaneDelegate? { get set }
}
