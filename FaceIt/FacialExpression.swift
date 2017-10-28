//
//  FacialExpression.swift
//  FaceIt
//
//  Created by Illarionova Violetta on 17/03/2017.
//  Copyright © 2017 Disruptvioletta LLC. All rights reserved.
//

import Foundation


struct FacialExpression {
    
    
    
   /* 
     init(text: String) {
     self.text = text
     }
     init(name:String) {
     
     self.name = name }
     
     init(name:String, license:Int) {
     self.name = name
     self.license = license 
     }
     */
    
    enum Eyes: Int {
        case open
        case closed
        case squinting
    }
    
    enum Mouth: Int {
        case frown
        case smirk
        case neutral
        case grin
        case smile
        
        var sadder: Mouth {
            return Mouth(rawValue: rawValue - 1) ?? .frown
        }
        var happier: Mouth {
            return Mouth(rawValue: rawValue + 1) ?? .smile
        }
    }
    
    var sadder: FacialExpression {
        return FacialExpression(eyes: self.eyes, mouth: self.mouth.sadder)
    }
    
    var happier: FacialExpression {
        return FacialExpression(eyes: self.eyes, mouth: self.mouth.happier)
    }
    
    let eyes: Eyes
    let mouth: Mouth
    
    init(eyes: Eyes, mouth: Mouth) {
        self.eyes = eyes
        self.mouth = mouth
    }
}

