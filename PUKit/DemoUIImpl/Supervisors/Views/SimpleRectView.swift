//
//  SimpleRectView.swift
//  DemoUIImpl
//
//  Created by Henry Zhang on 3/26/19.
//  Copyright © 2019 Henry Zhang. All rights reserved.
//

import Foundation

protocol SimpleRectViewDelegate: NSObjectProtocol {
  func layout(simpleRectView: SimpleRectView)
}

class SimpleRectView: NSView {
  public weak var delegate: SimpleRectViewDelegate?

  override func layout() {
    super.layout()
    delegate?.layout(simpleRectView: self)
  }
}
