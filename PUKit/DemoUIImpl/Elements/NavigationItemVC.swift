//
//  NavigationItemVC.swift
//  DemoUIImpl
//
//  Created by Henry Zhang on 3/26/19.
//  Copyright © 2019 Henry Zhang. All rights reserved.
//

import DemoUIProtocols
import Foundation

public class NavigationItemVC: NSViewController {
  private var itemView: NSButton?
  private let canvasMode: CanvasMode
  public weak var delegate: NavigationPaneElementDelegate?

  public init(nibName nibNameOrNil: NSNib.Name?, bundle nibBundleOrNil: Bundle?, canvasMode: CanvasMode) {
    self.canvasMode = canvasMode
    super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}

extension NavigationItemVC: NavigationPaneElementProtocol {

  public func arrange(with frame: NSRect) {
    guard itemView != nil else {
      return
    }

    itemView?.setFrameOrigin(frame.origin)
    itemView?.setFrameSize(frame.size)
  }

  public func deriveView() -> NSView? {
    if itemView == nil {
      itemView = NSButton(frame: NSMakeRect(0, 0, 0, 0))
      itemView?.title = canvasMode.localizedCaption
      itemView?.wantsLayer = true

      // Configure click handler
      itemView?.target = self
      itemView?.action = #selector(handleClick)
    }

    return itemView
  }

  @objc private func handleClick() {
    let info = ["canvasMode" : canvasMode]
    delegate?.navigationDidInvoke(element: self, with: info)
  }
}
