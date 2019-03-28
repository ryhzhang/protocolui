//
//  RootLogViewerProtocol.swift
//  PUKit
//
//  Created by Henry Zhang on 3/25/19.
//  Copyright © 2019 Henry Zhang. All rights reserved.
//

import Foundation
import PUKit

public protocol RootLogViewerProtocol: PUKLayoutProtocol {
  
  var navigationSupervisor: NavigationPaneProtocol? { get }
  var viewerCanvasSupervisor: ViewerCanvasProtocol? { get }

  func deriveView() -> NSView?
}
