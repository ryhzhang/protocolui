//
//  ViewerCanvasProtocol.swift
//  PUKit
//
//  Created by Henry Zhang on 3/25/19.
//  Copyright © 2019 Henry Zhang. All rights reserved.
//

import Foundation
import PUKit

public protocol ViewerCanvasProtocol: ViewerCanvasLayoutProtocol, PUKAnimationProtocol {
  var elements: [ViewerCanvasElementProtocol] { get set }
  func setMode(to: CanvasMode)
  func addElementsToCanvas(elementsToAdd: [ViewerCanvasElementProtocol])
  func removeElementsFromCanvas(elementsToRemove: [ViewerCanvasElementProtocol])
}

public protocol ViewerCanvasLayoutProtocol: PUKLayoutProtocol {
  func elementsDidInsert(elementsInserted: [ViewerCanvasElementProtocol])
  func elementsDidRemove(elementsRemoved: [ViewerCanvasElementProtocol])
}
