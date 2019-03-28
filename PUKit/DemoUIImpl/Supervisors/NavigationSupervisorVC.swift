//
//  NavigationSupervisorVC.swift
//  DemoUIImpl
//
//  Created by Henry Zhang on 3/26/19.
//  Copyright © 2019 Henry Zhang. All rights reserved.
//

import DemoUIProtocols
import Foundation

public class NavigationSupervisorVC: NSViewController {
  public weak var delegate: NavigationPaneDelegate?

  private var containerView: NSView?
  private var navigationItems: [NavigationPaneElementProtocol]

  public override init(nibName nibNameOrNil: NSNib.Name?, bundle nibBundleOrNil: Bundle?) {
    navigationItems = [NavigationPaneElementProtocol]()
    super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)

    buildNavigationMenu()
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  private func buildNavigationMenu() {
    CanvasMode.allCases.forEach { mode in
      let item = NavigationItemVC(nibName: nil, bundle: nil, canvasMode: mode)
      item.delegate = self
      navigationItems.append(item)
    }
  }
}

// MARK: - Layout
extension NavigationSupervisorVC: NavigationPaneProtocol {
  public func arrange(with frame: NSRect) {
    guard containerView != nil else {
      return
    }

    containerView?.setFrameOrigin(frame.origin)
    containerView?.setFrameSize(frame.size)

    // Arrange menu items with the given frame

    // Layout Type: is vertical, equal height and width.
    for (index, element) in navigationItems.enumerated() {
      let itemFrame = calculateItemRect(forIndex: index, totalElements: navigationItems.count, within: frame)
      element.arrange(with: itemFrame)
    }
  }

  public func deriveView() -> NSView? {
    if containerView == nil {
      let view = SimpleRectView(frame: NSMakeRect(0,0,0,0))
      view.wantsLayer = true
      view.layer?.borderWidth = 2
      view.layer?.borderColor = NSColor.white.cgColor

      containerView = view

      navigationItems.forEach { item in
        if let currentView = item.deriveView() {
          containerView?.addSubview(currentView)
        }
      }
    }

    return containerView
  }

  private func calculateItemRect(forIndex: Int, totalElements: Int, within frame: NSRect) -> NSRect {

    let cellHeight = min(frame.height / CGFloat(totalElements), 55)
    let cellWidth = frame.width
    let origin = NSMakePoint(frame.origin.x, (frame.origin.y + frame.height) - (CGFloat(forIndex + 1) * cellHeight))

    return NSMakeRect(origin.x, origin.y, cellWidth, cellHeight)
  }
}

extension NavigationSupervisorVC: NavigationPaneElementDelegate {
  public func navigationDidInvoke(element: NavigationPaneElementProtocol, with navigationInfo: [String : Any]) {
    delegate?.navigate(to: navigationInfo["canvasMode"] as! CanvasMode)
  }
}
