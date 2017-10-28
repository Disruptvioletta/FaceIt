//
//  ViewController.swift
//  FaceIt
//
//  Created by Illarionova Violetta on 16/03/2017.
//  Copyright © 2017 Disruptvioletta LLC. All rights reserved.
//

import UIKit

class FaceViewController: VCLoggingVC {
    
    var expression = FacialExpression(eyes: .open, mouth: .grin) {
        didSet {
            updateUI()
        }
    }
    
    @IBOutlet weak var faceView: FaceView! {
        didSet {
            let handler = #selector(FaceView.changeScale(byReactingTo:))
            let pinchRecognizer = UIPinchGestureRecognizer(target: faceView, action: handler)
            faceView.addGestureRecognizer(pinchRecognizer)
//            let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(toggleEyes(byReactingTo: )))
//            tapRecognizer.numberOfTapsRequired = 1
//            faceView.addGestureRecognizer(tapRecognizer)
            let swipeUpRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(increaseHappiness))
            swipeUpRecognizer.direction = .up
            faceView.addGestureRecognizer(swipeUpRecognizer)
            let swipeDownRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(decreaseHappiness))
            swipeDownRecognizer.direction = UISwipeGestureRecognizerDirection.down
            faceView.addGestureRecognizer(swipeDownRecognizer)
            updateUI()
        }
    }
    
    private struct HeadShake {
        static let angle = CGFloat.pi/6 //radians
        static let segmentDuration: TimeInterval = 0.5 // Each head shake has 3 segments
    }
    
    private func rotateFace(by angle: CGFloat) {
        faceView.transform = faceView.transform.rotated(by: angle)
    }
    
    
    private func shakeHead() {
        UIView.animate(
            withDuration: HeadShake.segmentDuration,
            animations: { self.rotateFace(by: HeadShake.angle) },
            completion: { finished in
                if finished {
                    UIView.animate(
                        withDuration: HeadShake.segmentDuration,
                        animations: { self.rotateFace(by: -HeadShake.angle * 2 )},
                        completion: { finished in
                            UIView.animate(
                                withDuration: HeadShake.segmentDuration,
                                animations: {self.rotateFace(by: HeadShake.angle) }
                            )
                        }
                    )
                }
            }
        )
    }
    
    @IBAction func shakeHead(_ sender: UITapGestureRecognizer) {
        shakeHead()
        
    }
                            
 
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    func increaseHappiness() {
        expression = expression.happier
    }
    
    func decreaseHappiness() {
        expression = expression.sadder
    }
    
    func toggleEyes(byReactingTo tapRecognizer: UITapGestureRecognizer) {
        if tapRecognizer.state == .ended {
            let eyes: FacialExpression.Eyes = (expression.eyes == .closed) ? .open : .closed
            expression = FacialExpression(eyes: eyes, mouth: expression.mouth)
        }
    }

   

    func updateUI() {
        switch expression.eyes{
        case .open:
            faceView?.eyesOpen = true
        case .closed:
            faceView?.eyesOpen = false
        case .squinting:
//            faceView?.eyesOpen = false
            break
        }
        faceView?.mouthCurvature = mouthCurvatures[expression.mouth] ?? 0.0
    }
    
    private let mouthCurvatures = [FacialExpression.Mouth.grin : 0.5, .frown: -1.0, .smile : 1.0, .neutral : 0.0, .smirk : -0.5]

} // end of class


