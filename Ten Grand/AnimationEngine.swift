//
//  AnimationEngine.swift
//  Ten Grand
//
//  Created by James Dyer on 6/30/16.
//  Copyright © 2016 James Dyer. All rights reserved.
//

import UIKit
import pop

class AnimationEngine {
    
    class var offScreenRightPosition: CGPoint {
        return CGPointMake(UIScreen.mainScreen().bounds.width, CGRectGetMidY(UIScreen.mainScreen().bounds))
    }
    
    class var offScreenLeftPosition: CGPoint {
        return CGPointMake(-UIScreen.mainScreen().bounds.width, CGRectGetMidY(UIScreen.mainScreen().bounds))
    }
    
    class var screenCenterPosition: CGPoint {
        return CGPointMake(CGRectGetMidX(UIScreen.mainScreen().bounds), CGRectGetMidY(UIScreen.mainScreen().bounds))
    }
    
    var originalConstants = [CGFloat]()
    var constraints: [NSLayoutConstraint]!
    
    init(constraints: [NSLayoutConstraint]) {
        
        for con in constraints {
            originalConstants.append(con.constant)
            con.constant = AnimationEngine.offScreenRightPosition.x
        }
        
        self.constraints = constraints
    }
    
    /*
     Animates the constraints from the right side of the screen to the original constraint.
     */
    func animateOnScreen() {
        let time = dispatch_time(DISPATCH_TIME_NOW, Int64(Double(0.75) * Double(NSEC_PER_SEC)))
        dispatch_after(time, dispatch_get_main_queue()) {
            var index = 0
            repeat {
                let moveAnim = POPSpringAnimation(propertyNamed: kPOPLayoutConstraintConstant)
                moveAnim.toValue = self.originalConstants[index]
                moveAnim.springBounciness = 12
                moveAnim.springSpeed = 12
                
                if (index > 0) {
                    moveAnim.dynamicsFriction += 10 + CGFloat(index)
                }
                
                let con = self.constraints[index]
                con.pop_addAnimation(moveAnim, forKey: "moveOnScreen")
                
                index = index + 1
            } while (index < self.constraints.count)
        }
    }
    
    /*
     Animates the constraints from the left side of the screen to the original constraint.
     */
    func animateBackOnScreen() {
        let time = dispatch_time(DISPATCH_TIME_NOW, Int64(Double(0.75) * Double(NSEC_PER_SEC)))
        dispatch_after(time, dispatch_get_main_queue()) {
            var index = 0
            repeat {
                let moveAnim = POPSpringAnimation(propertyNamed: kPOPLayoutConstraintConstant)
                moveAnim.toValue = self.originalConstants[index]
                moveAnim.springBounciness = 12
                moveAnim.springSpeed = 12
                
                if (index > 0) {
                    moveAnim.dynamicsFriction += 10 + CGFloat(index)
                }
                
                let con = self.constraints[index]
                con.pop_addAnimation(moveAnim, forKey: "moveOnScreen")
                
                index = index + 1
            } while (index < self.constraints.count)
        }
    }
    
    /*
     Animates the constraints from the original constraint to the right side of the screen.
     */
    func animateBackOffScreen() {
        let time = dispatch_time(DISPATCH_TIME_NOW, Int64(Double(0.75) * Double(NSEC_PER_SEC)))
        dispatch_after(time, dispatch_get_main_queue()) {
            var index = 0
            repeat {
                let moveAnim = POPSpringAnimation(propertyNamed: kPOPLayoutConstraintConstant)
                moveAnim.toValue = AnimationEngine.offScreenRightPosition.x
                moveAnim.springBounciness = 12
                moveAnim.springSpeed = 12
                
                if (index > 0) {
                    moveAnim.dynamicsFriction += 10 + CGFloat(index)
                }
                
                let con = self.constraints[index]
                con.pop_addAnimation(moveAnim, forKey: "moveOnScreen")
                
                index = index + 1
            } while (index < self.constraints.count)
        }
    }
    
    /*
     Animates the constraints from the original constraint to the left side of the screen.
     */
    func animateOffScreen() {
        let time = dispatch_time(DISPATCH_TIME_NOW, Int64(Double(0.75) * Double(NSEC_PER_SEC)))
        dispatch_after(time, dispatch_get_main_queue()) {
            var index = 0
            repeat {
                let moveAnim = POPSpringAnimation(propertyNamed: kPOPLayoutConstraintConstant)
                moveAnim.toValue = AnimationEngine.offScreenLeftPosition.x
                moveAnim.springBounciness = 12
                moveAnim.springSpeed = 12
                
                if (index > 0) {
                    moveAnim.dynamicsFriction += 10 + CGFloat(index)
                }
                
                let con = self.constraints[index]
                
                con.pop_addAnimation(moveAnim, forKey: "moveOffScreen")
                
                index = index + 1
            } while (index < self.constraints.count)
        }
    }
    
}
