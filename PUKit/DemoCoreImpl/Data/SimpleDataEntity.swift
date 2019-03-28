//
//  SimpleDataEntity.swift
//  DemoCoreImpl
//
//  Created by Henry Zhang on 3/27/19.
//  Copyright © 2019 Henry Zhang. All rights reserved.
//

import Foundation

public class SimpleDataEntity {
  public let threadName: String?
  public let time: Date
  public let className: String?
  public let logDescription: String?

  init(threadName: String, time: Date, className: String?, logDescription: String?) {
    self.threadName = threadName
    self.time = time
    self.className = className
    self.logDescription = logDescription
  }
}
