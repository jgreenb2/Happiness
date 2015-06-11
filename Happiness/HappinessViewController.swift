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
    
    func smilinessForFaceView(sender: FaceView) -> Double? {
        return (Double(happiness)-50)/50
    }
}
