//
//  PopoverSwift.swift
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

let CellLabelFont = UIFont.preferredFont(forTextStyle: UIFontTextStyle.subheadline)
let Leading: CGFloat = 20
let Spacing: CGFloat = 14
let ImageWidth: CGFloat = 20
let RowHeight: CGFloat = 44
let MaxRowCount = 7
let LineWidth: CGFloat = 1
let CornerRadius: CGFloat = 6

public enum Direction {
    case up, down
}

public enum PopoverStyle {
    case normal, withImage
}

internal struct AssociationKey {
    internal static var PopoverView: String = "PopoverView"
}

/// Convert a `void *` type to Swift type, use this function carefully
private func convertUnsafePointerToSwiftType<T>(_ value: UnsafeRawPointer) -> T {
    return unsafeBitCast(value, to: UnsafePointer<T>.self).pointee
}

internal extension UIViewController {
    internal var popoverView: PopoverView? {
        get { return objc_getAssociatedObject(self, &AssociationKey.PopoverView) as? PopoverView }
        set { objc_setAssociatedObject(self, &AssociationKey.PopoverView, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC) }
    }
}

internal extension String {
    internal var length: Int {
        return characters.count
    }
    
    internal func size(font: UIFont, preferredMaxLayoutWidth: CGFloat) -> CGSize {
        let str = self as NSString
        let options: NSStringDrawingOptions = [.usesLineFragmentOrigin, .usesFontLeading, .truncatesLastVisibleLine]
        return str.boundingRect(with: CGSize(width: preferredMaxLayoutWidth, height: CGFloat.greatestFiniteMagnitude), options: options, attributes: [NSFontAttributeName: font], context: nil).size
    }
}

internal extension Double {
    var radian: CGFloat {
        return CGFloat(self / 180.0 * M_PI)
    }
}

internal func drawArrawImage(
    in rect: CGRect,
    strokeColor: UIColor,
    fillColor: UIColor = UIColor.clear,
    lineWidth: CGFloat = 1,
    arrawCenterX: CGFloat,
    arrawWidth: CGFloat = 5,
    arrawHeight: CGFloat = 10,
    cornerRadius: CGFloat = 6,
    handstand: Bool = false
    ) -> UIImage?
{
    UIGraphicsBeginImageContextWithOptions(rect.size, false, 0)
    guard let context = UIGraphicsGetCurrentContext() else {
        return nil
    }

    if handstand {
        context.textMatrix = CGAffineTransform.identity
        context.translateBy(x: 0, y: rect.height)
        context.scaleBy(x: 1.0, y: -1.0)
    }
    
    // Perform the drawing
    context.setLineWidth(lineWidth)
    context.setStrokeColor(strokeColor.cgColor)
    context.setFillColor(fillColor.cgColor)
    
    let path = CGMutablePath()
    let lineHalfWidth = lineWidth / 2.0
    let arrawHalfWidth = arrawWidth / 2.0
    path.move(to: CGPoint(x: arrawCenterX, y: lineWidth))
    path.addLine(to: CGPoint(x: arrawCenterX - arrawHalfWidth, y: arrawHeight + lineWidth))
    path.addLine(to: CGPoint(x: cornerRadius + arrawHeight, y: arrawHeight + lineWidth))
    path.addArc(center: CGPoint(x: cornerRadius + lineHalfWidth, y: cornerRadius + arrawHeight + lineWidth), radius: cornerRadius, startAngle: 270.radian, endAngle: 180.radian, clockwise: true)
    path.addLine(to: CGPoint(x: lineHalfWidth, y: rect.height - cornerRadius - lineHalfWidth))
    path.addArc(center: CGPoint(x: cornerRadius + lineHalfWidth, y: rect.height - cornerRadius), radius: cornerRadius, startAngle: 180.radian, endAngle: 90.radian, clockwise: true)
    path.addLine(to: CGPoint(x: rect.width - cornerRadius - lineHalfWidth, y: rect.height - lineHalfWidth))
    path.addArc(center: CGPoint(x: rect.width - cornerRadius - lineHalfWidth, y: rect.height - cornerRadius - lineHalfWidth), radius: cornerRadius, startAngle: 90.radian, endAngle: 0.radian, clockwise: true)
    path.addLine(to: CGPoint(x: rect.width - lineHalfWidth, y: arrawHeight + cornerRadius + lineHalfWidth))
    path.addArc(center: CGPoint(x: rect.width - cornerRadius - lineHalfWidth, y: cornerRadius + arrawHeight + lineWidth), radius: cornerRadius, startAngle: 0.radian, endAngle: (-90).radian, clockwise: true)
    path.addLine(to: CGPoint(x: arrawCenterX + arrawHalfWidth, y: arrawHeight + lineWidth))
    
    path.closeSubpath()
    
    context.addPath(path)
    context.drawPath(using: .fillStroke)
    
    let output = UIGraphicsGetImageFromCurrentImageContext()
    
    UIGraphicsEndImageContext()
    
    return output!
}
