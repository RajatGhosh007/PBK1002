//
//  UIView+Extension.swift
//  PerfectBookKeeping
//
//  Created by Rajat Ghosh on 17/04/23.
//

import Foundation
import UIKit


extension UIView {
   func roundCornersSpecific(corners: UIRectCorner, radius: CGFloat) {
        let path = UIBezierPath(roundedRect: bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        layer.mask = mask
    }
    
    func roundCorners(radius: CGFloat) {
        self.layer.cornerRadius  = 5 ;
        self.layer.borderColor = UIColor.lightGray.cgColor
        self.layer.borderWidth = 0.5
        self.layer.masksToBounds = true
     }
    
    
    func roundCornerWithCornerRadius(cornerRadius:Float,colorBorder: UIColor = UIColor.clear ,borderWidth : Float = 0.0) {
        self.layer.cornerRadius  = CGFloat(cornerRadius) ;
        self.layer.borderColor = colorBorder.cgColor
        self.layer.borderWidth = CGFloat(borderWidth)
        self.layer.masksToBounds = true
     }
    
    func roundCornersWithHalfRadius(colorBorder: UIColor = UIColor.clear ,borderWidth : Float = 0.0) {
        self.layer.cornerRadius  = self.layer.frame.height * 0.5 ;
        self.layer.borderColor = colorBorder.cgColor
        self.layer.borderWidth = CGFloat(borderWidth)
        self.layer.masksToBounds = true
     }
   
    
    enum Direction: Int {
            case topToBottom = 0
            case bottomToTop
            case leftToRight
            case rightToLeft
        }
    
    
    func applyGradient(colors: [Any]?, locations: [NSNumber]? = [0.0, 1.0], direction: Direction = .topToBottom) {
            
            let gradientLayer = CAGradientLayer()
            gradientLayer.frame = self.bounds
            gradientLayer.colors = colors
            gradientLayer.locations = locations
            
            switch direction {
            case .topToBottom:
                gradientLayer.startPoint = CGPoint(x: 0.5, y: 0.0)
                gradientLayer.endPoint = CGPoint(x: 0.5, y: 1.0)
                
            case .bottomToTop:
                gradientLayer.startPoint = CGPoint(x: 0.5, y: 1.0)
                gradientLayer.endPoint = CGPoint(x: 0.5, y: 0.0)
                
            case .leftToRight:
                gradientLayer.startPoint = CGPoint(x: 0.0, y: 0.5)
                gradientLayer.endPoint = CGPoint(x: 1.0, y: 0.5)
                
            case .rightToLeft:
                gradientLayer.startPoint = CGPoint(x: 1.0, y: 0.5)
                gradientLayer.endPoint = CGPoint(x: 0.0, y: 0.5)
            }
            
            self.layer.addSublayer(gradientLayer)
        }
    
  
}
