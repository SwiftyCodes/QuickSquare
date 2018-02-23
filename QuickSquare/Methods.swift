//
//  Methods.swift
//  QuickSquare
//
//  Created by Polak on 6/23/17.
//  Copyright © 2017 Polak. All rights reserved.
//

import Foundation
import UIKit

var countRotation = 1
var flipTogleHorizontal = false
var flipTogleVertical = false

class Methods: NSObject {
    
    //MARK: - Image Rotation operations performed here.
    
    func rotateImageClockWise(theImage: UIImage,imageView:UIImageView) -> UIImage {
        
        var orient: UIImageOrientation!
        let imgOrientation = theImage.imageOrientation
        
   
        UIView.transition(with: imageView, duration: 0.2, options: .transitionCrossDissolve, animations: {() -> Void in
            
            switch imgOrientation {
                
            case .left:
                orient = .up
                
            case .right:
                orient = .down
                
            case .up:
                orient = .right
                
            case .down:
                orient = .left
                
            case .upMirrored:
                orient = .rightMirrored
                
            case .downMirrored:
                orient = .leftMirrored
                
            case .leftMirrored:
                orient = .upMirrored
                
            case .rightMirrored:
                orient = .downMirrored
            }
            
           
        }, completion: { _ in })
        
        let rotatedImage = UIImage(cgImage: theImage.cgImage!, scale: 1.0, orientation: orient)
        return rotatedImage
    }
    
    func rotateImageAntiClockWise(theImage: UIImage,imageView:UIImageView) -> UIImage {
        
        var orient: UIImageOrientation!
        let imgOrientation = theImage.imageOrientation
        
        UIView.transition(with: imageView, duration: 0.2, options: .transitionCrossDissolve, animations: {() -> Void in
        
        switch imgOrientation {
            
        case .left:
            orient = .down
            
        case .right:
            orient = .up
            
        case .up:
            orient = .left
            
        case .down:
            orient = .right
            
        case .upMirrored:
            orient = .leftMirrored
            
        case .downMirrored:
            orient = .rightMirrored
            
        case .leftMirrored:
            orient = .downMirrored
            
        case .rightMirrored:
            orient = .upMirrored
        }
         
    }, completion: { _ in })
        
        let rotatedImage = UIImage(cgImage: theImage.cgImage!, scale: 1.0, orientation: orient)
       
        return rotatedImage
    }
    
    //MARK: - Image flipping operations performed here.
    
    func flipImageOnVerticalAxis(theImage: UIImage,imageView:UIImageView) -> UIImage {
        
        var orient: UIImageOrientation!
        let imgOrientation = theImage.imageOrientation
        
        UIView.transition(with: imageView, duration: 0.2, options: .transitionCrossDissolve, animations: {() -> Void in
        
        switch imgOrientation {
            
        case .left:
            orient = .rightMirrored
            
        case .right:
            orient = .leftMirrored
            
        case .up:
            orient = .upMirrored
            
        case .down:
            orient = .downMirrored
            
        case .upMirrored
            :
            orient = .up
            
        case .downMirrored:
            orient = .down
            
        case .leftMirrored:
            orient = .right
            
        case .rightMirrored:
            orient = .left
        }
            
    }, completion: { _ in })
        
         let mirroredImage = UIImage(cgImage: theImage.cgImage!, scale: 1.0, orientation: orient)
        return mirroredImage
    }
    
    func flipImageOnHorizontalAxis(theImage: UIImage,imageView:UIImageView) -> UIImage {
        
        var orient: UIImageOrientation!
        let imgOrientation = theImage.imageOrientation
        
        UIView.transition(with: imageView, duration: 0.2, options: .transitionCrossDissolve, animations: {() -> Void in
        
        switch imgOrientation {
            
        case .left:
            orient = .leftMirrored
            
        case .right:
            orient = .rightMirrored
            
        case .up:
            orient = .downMirrored
            
        case .down:
            orient = .upMirrored
            
        case .upMirrored:
            orient = .down
            
        case .downMirrored:
            orient = .up
            
        case .leftMirrored:
            orient = .left
            
        case .rightMirrored:
            orient = .right
        }
            
    }, completion: { _ in })
        let mirroredImage = UIImage(cgImage: theImage.cgImage!, scale: 1.0, orientation: orient)
        //let mirroredImage = UIImage(CGImage: theImage.CGImage!, scale: 1.0, orientation: orient)
        return mirroredImage
    }
    
    //BACK GROUND COLORS
    
    func UIColorFromRGB(rgbValue: UInt) -> UIColor {
        return UIColor(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0)
        )
    }

}
