//
//  ViewerCanvasView.swift
//  DemoUIImpl
//
//  Created by Henry Zhang on 3/26/19.
//  Copyright © 2019 Henry Zhang. All rights reserved.
//

import Foundation

class ViewerCanvasView: SimpleRectView {
  override func layout() {
    delegate?.layout(simpleRectView: self)
  }
}
