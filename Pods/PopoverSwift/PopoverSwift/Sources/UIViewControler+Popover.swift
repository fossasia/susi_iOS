//
//  UIViewControler+PopoverSwift.swift
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

public extension UIViewController {    
    public func popover(_ controller: PopoverController) {
        func assertFromView(_ fromView: UIView) {
            var view: UIView? = fromView
            while (nil != view) {
                if view == view {
                    return
                } else {
                    view = view?.superview
                }
            }
            
            fatalError("fromView: \(fromView) must be descendant of self.view")
        }
        
        assertFromView(controller.fromView)
                
        let popoverView = PopoverView(controller, commonSuperView: view)
        popoverView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(popoverView)
        self.popoverView = popoverView
        
        view.addConstraints(
            NSLayoutConstraint.constraints(
                withVisualFormat: "|[popoverView]|",
                options: NSLayoutFormatOptions(),
                metrics: nil,
                views: ["popoverView": popoverView]
            )
        )
        view.addConstraints(
            NSLayoutConstraint.constraints(
                withVisualFormat: "V:|[popoverView]|",
                options: NSLayoutFormatOptions(),
                metrics: nil,
                views: ["popoverView": popoverView]
            )
        )

        popoverView.addConstraints()        
    }
    
    public func dismissPopover() {
        self.popoverView?.dismiss()
    }
    
    public var popoverDidAppear: Bool {
        return nil != popoverView?.superview
    }
}
