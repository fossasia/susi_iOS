//
//  PopoverController.swift
//  PopoverSwift
//
//  Created by Moch Xiao on 3/18/16.
//  Copyright © @2016 Moch Xiao (http://mochxiao.com).
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//  THE SOFTWARE.
//

import UIKit

public final class PopoverController {
    internal let items: [PopoverItem]
    internal let fromView: UIView
    internal let direction: Direction
    internal let reverseHorizontalCoordinates: Bool
    internal let style: PopoverStyle
    
    public var coverColor: UIColor? {
        didSet {
            self.items.forEach { (item: PopoverItem) -> () in
                item.coverColor = coverColor
            }
        }
    }
    public var textColor: UIColor? {
        didSet {
            self.items.forEach { (item: PopoverItem) -> () in
                item.textColor = textColor
            }
        }
    }
    
    public init(
        items: [PopoverItem],
        fromView: UIView,
        direction: Direction = .down,
        reverseHorizontalCoordinates: Bool = false,
        style: PopoverStyle = .normal)
    {
        self.items = items
        self.fromView = fromView
        self.direction = direction
        self.reverseHorizontalCoordinates = reverseHorizontalCoordinates
        self.style = style
    }
    
#if DEBUG
    deinit {
        debugPrint("\(#file):\(#line):\(type(of: self)):\(#function)")
    }
#endif
}
