//
//  ViewerCanvasSupervisorVC.swift
//  DemoUIImpl
//
//  Created by Henry Zhang on 3/26/19.
//  Copyright © 2019 Henry Zhang. All rights reserved.
//

import DemoUIProtocols
import DemoCoreImpl
import Foundation

private struct Constants {
  static let elementsCount: UInt = 2000
}

public final class ViewerCanvasSupervisorVC: NSViewController {
  private var containerView: NSView?
  private var contentElements: Array<ViewerCanvasElementProtocol>

  private var datasource: SimpleDemoDatasource?
  private var currentCanvasMode: CanvasMode

  override public init(nibName nibNameOrNil: NSNib.Name?, bundle nibBundleOrNil: Bundle?) {
    currentCanvasMode = .histogram
    contentElements = Array<ViewerCanvasElementProtocol>()
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

    var bucket = [Int]()
    let maxBucketSize = 100

    for (index, _) in contentElements.enumerated() {
      bucket.append(index)
      if bucket.count == maxBucketSize {
        animateLayout(for: bucket)
        bucket.removeAll(keepingCapacity: true)
      }
    }

    animateLayout(for: bucket)
  }

  public func setMode(to canvasMode: CanvasMode) {

    currentCanvasMode = canvasMode

    datasource = SimpleDemoDatasource.createDatasourceUsingRandomData(with: Constants.elementsCount)
    contentElements.removeAll()
    deriveView()?.subviews.removeAll()

    let newElementProtocols: [ViewerCanvasElementProtocol] = datasource?.fetchItems().map { CanvasElement(with: $0) } ?? []
    contentElements.append(contentsOf: newElementProtocols)
    let newElementViews: [NSView] = contentElements.compactMap { $0.deriveView() }
    deriveView()?.subviews.append(contentsOf: newElementViews)

    var bucket = [Int]()
    let maxBucketSize = 10

    for (index, _) in contentElements.enumerated() {
      bucket.append(index)
      if bucket.count == maxBucketSize {
        animateLayout(for: bucket)
        bucket.removeAll(keepingCapacity: true)
      }
    }

    animateLayout(for: bucket)

    // Raise didInsert
    // elementsDidInsert(elementsInserted: newElementProtocols)
  }

  public func elementsDidInsert(elementsInserted: [ViewerCanvasElementProtocol]) {
    // animateLayout()
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

  private func animateLayout(for elementsAt: [Int]) {
    if currentCanvasMode == .grid,
      let parentFrame = deriveView()?.frame {

      let layout = Layout.createLayout(for: currentCanvasMode, elementCount: contentElements.count, canvasFrame: parentFrame)

      let centerOfCanvasX = (deriveView()?.frame.origin.x ?? 0) + ((deriveView()?.frame.size.width ?? 0) / 2)
      let centerOfCanvasY = (deriveView()?.frame.origin.y ?? 0) + ((deriveView()?.frame.size.height ?? 0) / 2)

      NSAnimationContext.runAnimationGroup { context in

        for index in elementsAt {

          let cellRect = layout.frameRect(for: index)

          context.duration = 0.5
          context.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeIn)

          contentElements[index].deriveView()?.setFrameOrigin(NSMakePoint(centerOfCanvasX, centerOfCanvasY))
          contentElements[index].deriveView()?.animator().setFrameOrigin(cellRect.origin)
          contentElements[index].deriveView()?.animator().setFrameSize(cellRect.size)
        }
      }
    }
  }
}

fileprivate class Layout {
  private var elementCount: Int
  private var canvasFrame: NSRect

  init(elementCount: Int, canvasFrame: NSRect) {
    self.elementCount = elementCount
    self.canvasFrame = canvasFrame
  }

  public func cellSize() -> NSSize {
    fatalError()
  }

  public func frameRect(for cellElementAt: Int) -> NSRect {
    fatalError()
  }

  private class GridLayout: Layout {

    private var rows: Int
    private var columns: Int

    override init(elementCount: Int, canvasFrame: NSRect) {
      let aspectRatio: CGFloat = canvasFrame.width / canvasFrame.height
      let estimatedRows = floor(sqrt(Double(elementCount) / Double(aspectRatio)))
      let estimatedColumns = ceil(Double(elementCount) / estimatedRows)

      rows = Int(estimatedRows)
      columns = Int(estimatedColumns)

      super.init(elementCount: elementCount, canvasFrame: canvasFrame)
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

  private class HistogramLayout: Layout {
    public override func cellSize() -> NSSize {
      fatalError()
    }

    public override func frameRect(for cellElementAt: Int) -> NSRect {
      fatalError()
    }
  }

  private class TimeSeriesLayout: Layout {
    public override func cellSize() -> NSSize {
      fatalError()
    }

    public override func frameRect(for cellElementAt: Int) -> NSRect {
      fatalError()
    }
  }

  static func createLayout(for mode: CanvasMode, elementCount: Int, canvasFrame: NSRect) -> Layout {
    switch mode {
    case .grid:
      return GridLayout(elementCount: elementCount, canvasFrame: canvasFrame)
    case .histogram:
      return HistogramLayout(elementCount: elementCount, canvasFrame: canvasFrame)
    case .timeSeries:
      return TimeSeriesLayout(elementCount: elementCount, canvasFrame: canvasFrame)
    }
  }
}
