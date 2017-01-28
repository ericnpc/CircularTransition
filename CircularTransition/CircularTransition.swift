//
//  CircularTransition.swift
//  CircularTransition
//
//  Created by Training on 26/08/2016. Edited by Eric on 27/01/2017.
//  Copyright © 2017 Eric. All rights reserved.
//

import UIKit

enum CircularTransitionMode:Int {
    case present, dismiss, pop
}

class CircularTransition: NSObject {
    //MARK: Variables
    var circle = UIView()   
    var circleColor = .white    
    var duration = 0.3    
    var transitionMode: .present  
    var startingPoint = CGPoint.zero {
        didSet {
            circle.center = startingPoint
        }
    }    
}

extension CircularTransition: UIViewControllerAnimatedTransitioning {
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return duration
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        let containerView = transitionContext.containerView        
        if transitionMode == .present {
            if let presentedView = transitionContext.view(forKey: .to) {
                let viewCenter = presentedView.center
                let viewSize = presentedView.frame.size
                
                //Create the circle view that will overlay the current view and set it
                circle = UIView()                
                circle.frame = frameForCircle(withViewCenter: viewCenter, size: viewSize, startPoint: startingPoint)
                circle.layer.cornerRadius = circle.frame.size.height / 2
                circle.center = startingPoint
                circle.backgroundColor = circleColor
                circle.transform = CGAffineTransform(scaleX: 0.001, y: 0.001)
                containerView.addSubview(circle)
                                
                //Take the view that's going to be presented and set its coordinates and alpha                
                presentedView.center = startingPoint
                presentedView.transform = CGAffineTransform(scaleX: 0.001, y: 0.001)
                presentedView.alpha = 0
                containerView.addSubview(presentedView)
                
                //This is where the animation takes place, changing the circle coordinates and the new view alpha
                UIView.animate(withDuration: duration, animations: { 
                    self.circle.transform = CGAffineTransform.identity
                    presentedView.transform = CGAffineTransform.identity
                    presentedView.alpha = 1
                    presentedView.center = viewCenter                    
                    }, completion: { (success: Bool) in
                        transitionContext.completeTransition(success)
                })
            }            
        } else {
            let transitionModeKey: UITransitionContextViewKey = (transitionMode == .pop) ? .to : .from            
            if let returningView = transitionContext.view(forKey: transitionModeKey) {
                let viewCenter = returningView.center
                let viewSize = returningView.frame.size                
                
                //Set the circle on full screen
                circle.frame = frameForCircle(withViewCenter: viewCenter, size: viewSize, startPoint: startingPoint)
                circle.layer.cornerRadius = circle.frame.size.height / 2
                circle.center = startingPoint
                
                //Animate the circle to fade and shrink
                UIView.animate(withDuration: duration, animations: { 
                    self.circle.transform = CGAffineTransform(scaleX: 0.001, y: 0.001)
                    returningView.transform = CGAffineTransform(scaleX: 0.001, y: 0.001)
                    returningView.center = self.startingPoint
                    returningView.alpha = 0
                    
                    if self.transitionMode == .pop {
                        containerView.insertSubview(returningView, belowSubview: returningView)
                        containerView.insertSubview(self.circle, belowSubview: returningView)
                    }                  
                }, completion: { (success: Bool) in
                    returningView.center = viewCenter
                    returningView.removeFromSuperview()                    
                    self.circle.removeFromSuperview()                    
                    transitionContext.completeTransition(success)                        
                })                
            }           
        }       
    }   
    
    func frameForCircle (withViewCenter viewCenter: CGPoint, size viewSize: CGSize, startPoint: CGPoint) -> CGRect {
        let xLength = fmax(startPoint.x, viewSize.width - startPoint.x)
        let yLength = fmax(startPoint.y, viewSize.height - startPoint.y)        
        let offsetVector = sqrt(xLength * xLength + yLength * yLength) * 2
        let size = CGSize(width: offsetVector, height: offsetVector)        
        return CGRect(origin: CGPoint.zero, size: size)
    }
}
