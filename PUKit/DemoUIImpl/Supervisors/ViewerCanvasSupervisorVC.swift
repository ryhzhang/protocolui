//
//  ViewerCanvasSupervisorVC.swift
//  DemoUIImpl
//
//  Created by Henry Zhang on 3/26/19.
//  Copyright © 2019 Henry Zhang. All rights reserved.
//

import DemoUIProtocols
import DemoCoreImpl
import DemoReplacementUIImpl
import Foundation

private struct Constants {
  static let elementsCount: UInt = 8000
}

public final class ViewerCanvasSupervisorVC: NSViewController {
  private var containerView: NSView?
  public var elements: [ViewerCanvasElementProtocol]

  private var datasource: SimpleDemoDatasource?
  private var currentCanvasMode: CanvasMode

  override public init(nibName nibNameOrNil: NSNib.Name?, bundle nibBundleOrNil: Bundle?) {
    currentCanvasMode = .histogram
    elements = [ViewerCanvasElementProtocol]()
    super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}

extension ViewerCanvasSupervisorVC: ViewerCanvasProtocol {
  public func arrange(with frame: NSRect) {
    guard containerView != nil else {
      return
    }

    containerView?.setFrameOrigin(frame.origin)
    containerView?.setFrameSize(frame.size)

    animateLayout(isInitialLoad: false)
  }

  public func setMode(to canvasMode: CanvasMode) {

    currentCanvasMode = canvasMode

    var datasourceDidChange = false
    if datasource == nil {
      datasource = SimpleDemoDatasource.createDatasourceUsingRandomData(with: Constants.elementsCount)
      datasourceDidChange = true
    }

    if datasourceDidChange {
      elements.removeAll()
      deriveView()?.subviews.removeAll()

      let newElementProtocols: [ViewerCanvasElementProtocol] = datasource?.fetchItems().map { DIFactory.createInstanceOfCanvasElement(with: $0) } ?? []
      elements.append(contentsOf: newElementProtocols)
      let newElementViews: [NSView] = elements.compactMap { $0.deriveView() }
      deriveView()?.subviews.append(contentsOf: newElementViews)

      // Raise didInsert
      elementsDidInsert(elementsInserted: newElementProtocols)
    }
    else {
      animateLayout(isInitialLoad: false)
    }
  }

  public func elementsDidInsert(elementsInserted: [ViewerCanvasElementProtocol]) {
    animateLayout(isInitialLoad: true)
  }

  public func elementsDidRemove(elementsRemoved: [ViewerCanvasElementProtocol]) {

  }

  public func addElementsToCanvas(elementsToAdd: [ViewerCanvasElementProtocol]) {

  }

  public func removeElementsFromCanvas(elementsToRemove: [ViewerCanvasElementProtocol]) {
    
  }

  public func deriveView() -> NSView? {
    if containerView == nil {
      let view = ViewerCanvasView(frame: NSMakeRect(0,0,0,0))
      view.wantsLayer = true
      view.layer?.borderWidth = 2
      view.layer?.borderColor = NSColor.green.cgColor

      containerView = view
    }

    return containerView
  }

  private func animateLayout(isInitialLoad: Bool) {
    guard let parentFrame = deriveView()?.frame else {
      return
    }

    var layout: Layout

    switch currentCanvasMode {
    case .grid:       layout = Layout.GridLayout(elementCount: elements.count, canvasFrame: parentFrame)
    case .timeSeries: layout = Layout.TimeSeriesLayout(dataPoints: datasource!.fetchItems(), divisionInSec: 30, canvasFrame: parentFrame)
    case .histogram:  return
    }

    for (index, _) in elements.enumerated() {
      let cellRect = layout.frameRect(for: index)

      if isInitialLoad {
        elements[index].loadingAnimation(to: cellRect)
      }
      else {
        elements[index].transitionAnimation(to: cellRect)
      }
    }
  }
}

fileprivate class Layout {
  private var canvasFrame: NSRect

  init(canvasFrame: NSRect) {
    self.canvasFrame = canvasFrame
  }

  public func cellSize() -> NSSize {
    fatalError()
  }

  public func frameRect(for cellElementAt: Int) -> NSRect {
    fatalError()
  }

  class GridLayout: Layout {

    private var rows: Int
    private var columns: Int
    private var elementCount: Int

    init(elementCount: Int, canvasFrame: NSRect) {
      self.elementCount = elementCount
      let aspectRatio: CGFloat = canvasFrame.width / canvasFrame.height
      let estimatedRows = floor(sqrt(Double(elementCount) / Double(aspectRatio)))
      let estimatedColumns = ceil(Double(elementCount) / estimatedRows)

      rows = Int(estimatedRows)
      columns = Int(estimatedColumns)

      super.init(canvasFrame: canvasFrame)
    }

    override func cellSize() -> NSSize {
      let cellSize = NSMakeSize(canvasFrame.width / CGFloat(columns), canvasFrame.height / CGFloat(rows))
      return cellSize
    }

    override func frameRect(for cellElementAt: Int) -> NSRect {
      let row = cellElementAt / columns
      let col = cellElementAt % columns

      let cell = cellSize()
      let origin = NSMakePoint((CGFloat(col) * cell.width), (canvasFrame.height - (CGFloat(row + 1) * cell.height)))

      let frame = NSMakeRect(origin.x, origin.y, cell.width, cell.height)

      return frame
    }
  }

  class HistogramLayout: Layout {
    public override func cellSize() -> NSSize {
      fatalError()
    }

    public override func frameRect(for cellElementAt: Int) -> NSRect {
      fatalError()
    }
  }

  class TimeSeriesLayout: Layout {
    private var gridLookup = [Int: (Int, Int)]()
    private let rows: Int
    private let columns: Int

    init(dataPoints: [SimpleDataEntity], divisionInSec: TimeInterval, canvasFrame: NSRect) {

      var earliestTime = Date.distantFuture
      earliestTime = dataPoints.reduce(earliestTime) { previous, entity in
        return min(previous, entity.time)
      }

      var latestTime = Date.distantPast
      latestTime = dataPoints.reduce(latestTime) { previous, entity in
        return max(previous, entity.time)
      }

      let timeDeltaInSec = latestTime.timeIntervalSince(earliestTime)

      rows = Int(ceil(timeDeltaInSec / divisionInSec))

      var layoutGrid = [[Int]]()
      layoutGrid.reserveCapacity(rows)
      for _ in 0..<rows {
        layoutGrid.append([Int]())
      }

      var maxColumnsCount = 0

      // Iterate to get the most entries
      for (index, element) in dataPoints.enumerated() {
        let targetRow = Int(floor(element.time.timeIntervalSince(earliestTime) / divisionInSec))

        layoutGrid[targetRow].append(index)

        gridLookup[index] = (targetRow, layoutGrid[targetRow].count - 1)

        // update the maxColumnsCount
        maxColumnsCount = max(maxColumnsCount, layoutGrid[targetRow].count)
      }

      columns = maxColumnsCount + 2 // give it a 2 column buffer

      super.init(canvasFrame: canvasFrame)
    }

    public override func cellSize() -> NSSize {
      let width = canvasFrame.width / CGFloat(columns)
      let height = canvasFrame.height / CGFloat(rows)

      //let square = min(width, height)
      let cellSize = NSMakeSize(width, height)
      return cellSize
    }

    public override func frameRect(for cellElementAt: Int) -> NSRect {
      let position = gridLookup[cellElementAt]!
      let cellDim = cellSize()
      let rect = NSMakeRect(CGFloat(position.1) * cellDim.width, CGFloat(position.0) * cellDim.height, cellDim.width, cellDim.height)
      return rect
    }
  }
}
