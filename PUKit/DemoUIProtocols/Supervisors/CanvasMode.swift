//
//  CanvasMode.swift
//  DemoUIProtocols
//
//  Created by Henry Zhang on 3/26/19.
//  Copyright © 2019 Henry Zhang. All rights reserved.
//

import Foundation

public enum CanvasMode: CaseIterable {
  case histogram
  case grid
  case timeSeries
}

public extension CanvasMode {
  public var localizedCaption: String {
    switch self {
    case .grid:
      return NSLocalizedString("Grid", comment: "Grid view")
    case .histogram:
      return NSLocalizedString("Histogram", comment: "Histogram view")
    case .timeSeries:
      return NSLocalizedString("Time series", comment: "Time series view")
    }
  }
}
