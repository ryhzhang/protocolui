//
//  SimpleDemoDatasource.swift
//  DemoCoreImpl
//
//  Created by Henry Zhang on 3/27/19.
//  Copyright © 2019 Henry Zhang. All rights reserved.
//

import Foundation

public class SimpleDemoDatasource {
  private var items: [SimpleDataEntity]

  init() {
    items = [SimpleDataEntity]()
  }

  public func fetchItems() -> [SimpleDataEntity] {
    return items
  }
}

// MARK: - Factory helpers
extension SimpleDemoDatasource {
  public static func createDatasourceUsingRandomData(with datapointCount: UInt) -> SimpleDemoDatasource {
    let datasource = SimpleDemoDatasource()
    datasource.seedRandomData(with: datapointCount)

    return datasource
  }

  private func seedRandomData(with datapoints: UInt) {
    for _ in 0..<datapoints {
      items.append(SimpleDataEntity.createRandomEntity())
    }
  }
}

extension SimpleDataEntity {
  static let threadSelection = ["mainThread", "networkQueue", "dataQueue", "diskQueue"]
  static let classNameSelection = ["FooSingleton", "BarFactory", "BuggyFetcher", "RenderSomething"]
  static let wordSelection = ["faint","motion","praise","wax","flowers","ritzy","assort","steel","boot","pass","amazing","hypnotize","late","dream","squirrel","hungry","terrify","snobbish","secretary","disagreeable","calendar","protect","tense","assort","lamentable","note","illustrious","nerve","explore","seemly","banish","charge","agreeable","bash","feeble","death","loud","yawn","swell","smoke","happen","history","town","humorous","thoughtful","flap","eager","joke", ",", ".", "!"]

  static func createRandomEntity() -> SimpleDataEntity {
    let threadName = threadSelection[Int(arc4random_uniform(UInt32(truncatingIfNeeded: threadSelection.count)))]
    let className = classNameSelection[Int(arc4random_uniform(UInt32(truncatingIfNeeded: classNameSelection.count)))]
    let wordsInSentence = max(Int(arc4random_uniform(40)), 2)

    var logline = ""
    for _ in 0..<40 {
      logline += "\(wordSelection[Int(arc4random_uniform(UInt32(truncatingIfNeeded: wordSelection.count)))]) "
    }

    // random events with +/- 30 mins range
    let date = Date(timeIntervalSinceNow: Double(arc4random_uniform(3600)) - 1800)
    return SimpleDataEntity(threadName: threadName, time: date, className: className, logDescription: logline)
  }
}
