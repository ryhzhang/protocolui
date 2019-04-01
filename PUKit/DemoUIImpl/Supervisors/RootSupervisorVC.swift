//
//  RootSupervisorVC.swift
//  DemoUIProtocols
//
//  Created by Henry Zhang on 3/25/19.
//  Copyright © 2019 Henry Zhang. All rights reserved.
//

import Foundation
import DemoUIProtocols

public final class RootSupervisorVC: NSViewController {

  private var logViewerRootSupervisor: RootLogViewerProtocol?

  private var _navigationSupervisor: NavigationPaneProtocol?
  private var _viewCanvasSupervisor: ViewerCanvasProtocol?

  private var containerView: SimpleRectView?
  private var window: NSWindow

  public init(nibName nibNameOrNil: NSNib.Name?, bundle nibBundleOrNil: Bundle?, forWindow: NSWindow) {
    window = forWindow

    super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)

    logViewerRootSupervisor = self
    _navigationSupervisor = NavigationSupervisorVC()
    _navigationSupervisor?.delegate = self
    _viewCanvasSupervisor = ViewerCanvasSupervisorVC()
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  override public func loadView() {
    guard let rootView = logViewerRootSupervisor?.deriveView() else {
      assertionFailure("No view found.")
      return
    }
    self.view = rootView
  }

  public func deriveView() -> NSView? {

    if containerView == nil {
      let initialFrame = window.contentRect(forFrameRect: window.frame)
      let view = SimpleRectView(frame: initialFrame)
      view.setFrameOrigin(NSMakePoint(0, 0))
      view.wantsLayer = true
      view.layer?.borderWidth = 2
      view.layer?.borderColor = NSColor.purple.cgColor

      containerView = view
      containerView?.delegate = self

      if let navigationView = navigationSupervisor?.deriveView() {
        containerView?.addSubview(navigationView)

        // Set frame
        let navFrame = navigationFrame(from: initialFrame)
        navigationSupervisor?.arrange(with: navFrame)
      }

      if let canvasView = viewerCanvasSupervisor?.deriveView() {
        // Maybe these subview adds should be done implicitly by supervisor parenting algo??
        containerView?.addSubview(canvasView)

        // Set frame
        let canvasFrame = viewerCanvasFrame(from: initialFrame)
        viewerCanvasSupervisor?.arrange(with: canvasFrame)
      }

      containerView?.needsLayout = true
    }

    return containerView
  }

  private func navigationFrame(from frame: NSRect) -> NSRect {
    var rect: NSRect
    rect = NSMakeRect(2, 2, frame.width * 0.1 - 2, frame.height - 4)
    return rect
  }

  private func viewerCanvasFrame(from frame: NSRect) -> NSRect {
    var rect: NSRect

    rect = NSMakeRect(frame.width * 0.1 - 2, 2, frame.width * 0.9 - 2, frame.height - 4)
    return rect
  }
}

extension RootSupervisorVC: RootLogViewerProtocol {
  public func arrange(with frame: NSRect) {
    guard containerView != nil else {
      return
    }

    containerView?.setFrameOrigin(frame.origin)
    containerView?.setFrameSize(frame.size)
  }

  public var navigationSupervisor: NavigationPaneProtocol? {
    return _navigationSupervisor
  }

  public var viewerCanvasSupervisor: ViewerCanvasProtocol? {
    return _viewCanvasSupervisor
  }
}

extension RootSupervisorVC: SimpleRectViewDelegate {
  func layout(simpleRectView: SimpleRectView) {
    
  }
}

extension RootSupervisorVC: NSWindowDelegate {
  public func windowDidResize(_ notification: Notification) {
    let layoutFrame = window.contentRect(forFrameRect: (window.frame))
    containerView?.setFrameOrigin(NSMakePoint(0, 0))
    containerView?.setFrameSize(layoutFrame.size)

    let newNavigationFrame = navigationFrame(from: layoutFrame)
    navigationSupervisor?.arrange(with: newNavigationFrame)

    let newCanvasFrame = viewerCanvasFrame(from: layoutFrame)
    viewerCanvasSupervisor?.arrange(with: newCanvasFrame)
  }
}

extension RootSupervisorVC: NavigationPaneDelegate {
  public func navigate(to target: CanvasMode) {
    viewerCanvasSupervisor?.setMode(to: target)
  }
}
