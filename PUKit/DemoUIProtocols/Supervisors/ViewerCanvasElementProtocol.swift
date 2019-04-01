//
//  ViewerCanvasElementProtocol.swift
//  DemoUIProtocols
//
//  Created by Henry Zhang on 3/26/19.
//  Copyright © 2019 Henry Zhang. All rights reserved.
//

import Foundation
import PUKit

public protocol ViewerCanvasElementProtocol: NSObjectProtocol, PUKLayoutProtocol, ViewerCanvasElementAnimationProtocol, PUKEventProtocol {

}

public protocol ViewerCanvasElementAnimationProtocol: PUKAnimationProtocol {
  func loadingAnimation(to targetFrame: NSRect)
  func transitionAnimation(to targetFrame: NSRect)
}
