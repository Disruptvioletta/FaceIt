//
//  Blinking Face VC.swift
//  FaceIt
//
//  Created by Illarionova Violetta on 16/06/2017.
//  Copyright © 2017 Disruptvioletta LLC. All rights reserved.
//

import UIKit

class Blinking_Face_VC: FaceViewController {

    var blink = false {
        didSet {
            blinkIfNeeded()
        }
    }
    
    override func updateUI() {
        super.updateUI()
        blink = expression.eyes == .squinting
    }
    
    
    private struct BlinkRate {
        static let closedDuration: TimeInterval = 0.4
        static let openDuration: TimeInterval = 2.5
    }
    
    private func blinkIfNeeded() {
        if blink && canBlink && !inAblink {
            faceView.eyesOpen = false
            inAblink = true
            Timer.scheduledTimer(withTimeInterval: BlinkRate.closedDuration, repeats: false) { [weak self] timer in
                self?.faceView.eyesOpen = true
                Timer.scheduledTimer(withTimeInterval: BlinkRate.openDuration, repeats: false) { [weak self] timer in
                    self?.inAblink = false
                    self?.blinkIfNeeded()
                }
            }
        }
    }
    
    private var canBlink = false
    private var inAblink = false
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        canBlink = true
        blinkIfNeeded()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        canBlink = false
        
    }

}
