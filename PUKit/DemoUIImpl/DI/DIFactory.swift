//
//  DIFactory.swift
//  DemoUIImpl
//
//  Created by Henry Zhang on 3/28/19.
//  Copyright © 2019 Henry Zhang. All rights reserved.
//

import DemoCoreImpl
import DemoUIProtocols
import DemoReplacementUIImpl
import Foundation

public class DIFactory {
  public static func createInstanceOfCanvasElement(with entity: SimpleDataEntity) -> ViewerCanvasElementProtocol {
    return arc4random_uniform(2) % 2 == 1 ? AlternateCanvasElement(with: entity) : CanvasElement(with: entity)
//    return CanvasElement(with: entity)
    //return AlternateCanvasElement(with: entity)
  }
}
