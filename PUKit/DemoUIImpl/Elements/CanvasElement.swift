//
//  CanvasElement.swift
//  DemoUIImpl
//
//  Created by Henry Zhang on 3/27/19.
//  Copyright © 2019 Henry Zhang. All rights reserved.
//

import DemoCoreImpl
import DemoUIProtocols
import Foundation

public class CanvasElement: NSViewController {
  private var itemView: SimpleRectView?
  private var entity: SimpleDataEntity

  public init(with data: SimpleDataEntity) {
    entity = data
    super.init(nibName: nil, bundle: nil)
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}

extension CanvasElement: ViewerCanvasElementProtocol {

  public func deriveView() -> NSView? {
    if itemView == nil {
      itemView = SimpleRectView(frame: NSMakeRect(0, 0, 0, 0))
      itemView?.wantsLayer = true
      itemView?.layer?.borderWidth = 1
      itemView?.layer?.borderColor = NSColor.darkGray.cgColor
      itemView?.layerContentsRedrawPolicy = .onSetNeedsDisplay

      switch entity.threadName {
      case "mainThread":
        itemView?.layer?.backgroundColor = NSColor.red.cgColor
      default:
        itemView?.layer?.backgroundColor = NSColor.white.cgColor
      }
    }

    return itemView
  }

  public func arrange(with frame: NSRect) {
    guard itemView != nil else {
      return
    }

    itemView?.setFrameOrigin(frame.origin)
    itemView?.setFrameSize(frame.size)
  }

  public func loadingAnimation(to targetFrame: NSRect) {
    deriveView()?.setFrameOrigin(targetFrame.origin)

    NSAnimationContext.runAnimationGroup { context in
      context.duration = entity.threadName == "mainThread" ? 1 : 0.3
      deriveView()?.animator().setFrameSize(targetFrame.size)
    }
  }

  public func transitionAnimation(to targetFrame: NSRect) {

    NSAnimationContext.runAnimationGroup { context in
      context.duration = 0.5
      deriveView()?.animator().setFrameOrigin(targetFrame.origin)
      deriveView()?.animator().setFrameSize(targetFrame.size)
    }
  }
}
