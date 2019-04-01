//
//  AlternateCanvasElement.swift
//  DemoReplacementUIImpl
//
//  Created by Henry Zhang on 3/27/19.
//  Copyright © 2019 Henry Zhang. All rights reserved.
//

import DemoCoreImpl
import DemoUIProtocols
import Foundation

public class AlternateCanvasElement: NSViewController {
  private var itemView: NSButton?
  private var entity: SimpleDataEntity

  public init(with data: SimpleDataEntity) {
    entity = data
    super.init(nibName: nil, bundle: nil)
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}

extension AlternateCanvasElement: ViewerCanvasElementProtocol {
  public func deriveView() -> NSView? {
    if itemView == nil {
      itemView = NSButton(frame: NSMakeRect(0, 0, 0, 0))
      itemView?.title = ""
      itemView?.wantsLayer = true
      itemView?.layer?.borderWidth = 1
      itemView?.layer?.borderColor = NSColor.darkGray.cgColor
      itemView?.layerContentsRedrawPolicy = .onSetNeedsDisplay

      switch entity.threadName {
      case "mainThread":
        itemView?.layer?.backgroundColor = NSColor.brown.cgColor
      default:
        itemView?.layer?.backgroundColor = NSColor.gray.cgColor
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
    itemView?.layer?.removeAllAnimations()

    let posAnimation = CABasicAnimation(keyPath: "position")
    let startPoint = itemView?.frame.origin
    let endPoint = targetFrame.origin

    posAnimation.fromValue = startPoint
    posAnimation.toValue = endPoint

    let scaleAnimation = CABasicAnimation(keyPath: "scale")
    let start = 0.1
    let end = 0.1
    scaleAnimation.fromValue = start
    scaleAnimation.toValue = end

    let animationGroup = CAAnimationGroup()
    animationGroup.animations = [posAnimation, scaleAnimation]
    animationGroup.duration = 1
    //animationGroup.beginTime = 2 //Double(arc4random_uniform(2))

    itemView?.layer?.add(animationGroup, forKey: "group")

    deriveView()?.setFrameOrigin(targetFrame.origin)
    deriveView()?.setFrameSize(targetFrame.size)
  }
}
