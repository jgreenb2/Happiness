//
//  HappinessViewController.swift
//  Happiness
//
//  Created by jeff greenberg on 6/11/15.
//  Copyright (c) 2015 Jeff Greenberg. All rights reserved.
//

import UIKit

class HappinessViewController: UIViewController, FaceViewDataSource {

    @IBOutlet weak var faceView: FaceView! {
        didSet {
            faceView.dataSource = self
            faceView.addGestureRecognizer(UIPinchGestureRecognizer(target: faceView, action: "scale:"))
        }
    }
    
    func UpdateUI() {
        faceView.setNeedsDisplay()
    }

    // happiness is our pathetic little model
    // a more elaborate model would exist as its own class in
    // its own file
    var happiness: Int = 10 { // 0 = sad, 100 = ecstatic
    didSet {
            happiness=min(max(happiness,0),100)
            println("happiness=\(happiness)")
            UpdateUI()
        }
    }
    
    private struct Constants {
        static let HappinessGestureScale: CGFloat = 4
    }
    @IBAction func changeHappiness(gesture: UIPanGestureRecognizer) {
        switch gesture .state {
        case .Ended: fallthrough
        case .Changed:
            let translation = gesture.translationInView(faceView)
            let happinessChange = -Int(translation.y/Constants.HappinessGestureScale)
            if happinessChange != 0 {
                happiness += happinessChange
                gesture.setTranslation(CGPointZero, inView: faceView)
            }
        default: break
        }
    }
    
    func smilinessForFaceView(sender: FaceView) -> Double? {
        return (Double(happiness)-50)/50
    }
}
