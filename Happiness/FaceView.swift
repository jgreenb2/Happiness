//
//  FaceView.swift
//  Happiness
//
//  Created by jeff greenberg on 6/11/15.
//  Copyright (c) 2015 Jeff Greenberg. All rights reserved.
//

import UIKit

protocol FaceViewDataSource: class {   // delegate for smiliness data
    func smilinessForFaceView(sender: FaceView) -> Double?
}

@IBDesignable
class FaceView: UIView {

    var faceCenter: CGPoint {
        return convertPoint(center, fromCoordinateSpace: superview!)
    }
    
    @IBInspectable
    var scale: CGFloat = 0.9 { didSet { setNeedsDisplay() } }
    
    var faceRadius: CGFloat {
        return scale * min(bounds.size.height, bounds.size.width) / 2
    }
    
    @IBInspectable
    var lineWidth: CGFloat = 3 { didSet { setNeedsDisplay() } }
    
    @IBInspectable
    var color: UIColor = UIColor.blueColor() { didSet { setNeedsDisplay() } }

    private struct Scaling {
        static let FaceRadiusToEyeRadiusRatio: CGFloat = 10
        static let FaceRadiusToEyeOffsetRatio: CGFloat = 3
        static let FaceRadiusToEyeSeparationRatio: CGFloat = 1.5
        static let FaceRadiusToMouthWidthRatio: CGFloat = 1
        static let FaceRadiusToMouthHeightRatio: CGFloat = 3
        static let FaceRadiusToMouthOffsetRatio: CGFloat = 3
    }
    
    private enum Eye { case Left, Right }
    
    private func bezierPathForEye(whichEye: Eye) -> UIBezierPath {
        let eyeRadius = faceRadius/Scaling.FaceRadiusToEyeRadiusRatio
        let eyeVerticalOffset = faceRadius/Scaling.FaceRadiusToEyeRadiusRatio
        let eyeHorizontalSeparation = faceRadius/Scaling.FaceRadiusToEyeSeparationRatio
        
        var eyeCenter = faceCenter
        eyeCenter.y -= eyeVerticalOffset
        switch whichEye {
        case .Left: eyeCenter.x -= eyeHorizontalSeparation/2
        case .Right: eyeCenter.x += eyeHorizontalSeparation/2
        }
        
        let path = UIBezierPath(arcCenter: eyeCenter, radius: eyeRadius, startAngle: 0, endAngle: CGFloat(2*M_PI), clockwise: true)
        path.lineWidth = lineWidth
        return path
    }
    
    private func bezierPathForSmile(fractionOfSmile: Double) -> UIBezierPath {
        let mouthWidth = faceRadius/Scaling.FaceRadiusToMouthWidthRatio
        let mouthHeight = faceRadius/Scaling.FaceRadiusToMouthHeightRatio
        let mouthVerticalOffset = faceRadius/Scaling.FaceRadiusToMouthOffsetRatio
        
        let smileHeight = CGFloat(max(min(fractionOfSmile,1),-1)) * mouthHeight
        
        let start = CGPoint(x: faceCenter.x - mouthWidth/2, y: faceCenter.y + mouthVerticalOffset)
        let end = CGPoint(x: start.x + mouthWidth, y: start.y)
        let cp1 = CGPoint(x: start.x + mouthWidth/3, y: start.y + smileHeight)
        let cp2 = CGPoint(x: end.x - mouthWidth/3, y: cp1.y)
        
        let path = UIBezierPath()
        path.moveToPoint(start)
        path.addCurveToPoint(end, controlPoint1: cp1, controlPoint2: cp2)
        path.lineWidth = lineWidth
        return path
        
    }
    
    weak var dataSource: FaceViewDataSource?    // delegate. weak because the delgate and the viewController are going to point
                                                // to each other and form a cycle. To allow either to be freed via ARC we need to declare
                                                // one of them as weak
    
    override func drawRect(rect: CGRect) {
        let facePath = UIBezierPath(arcCenter: faceCenter, radius: faceRadius, startAngle: 0, endAngle: CGFloat(2*M_PI), clockwise: true)
        facePath.lineWidth = lineWidth
        color.set()
        facePath.stroke()
        
        bezierPathForEye(.Left).stroke()
        bezierPathForEye(.Right).stroke()
        
        // ?? defines return val if nil
        let smiliness = dataSource?.smilinessForFaceView(self) ?? 0.0
        let smilePath = bezierPathForSmile(smiliness)
        smilePath.stroke()
    }
    
    func scale(gesture: UIPinchGestureRecognizer) {
        if gesture.state == .Changed {
            scale *= gesture.scale
            gesture.scale = 1
        }
    }

}
