//
//  CircularTransition.swift
//  CircularTransition
//
//  Created by Training on 26/08/2016. Edited by Eric on 27/01/2017.
//  Copyright © 2017 Eric. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UIViewControllerTransitioningDelegate {
    //MARK: Variables and Outlets
    @IBOutlet weak var menuButton: UIButton!    
    let transition = CircularTransition()  

    //MARK: Lifecycle Events
    override func viewDidLoad() {
        super.viewDidLoad()    
        menuButton.layer.cornerRadius = menuButton.frame.size.width / 2
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let segueVC = segue.destination as! SecondViewController
        segueVC.transitioningDelegate = self
        segueVC.modalPresentationStyle = .custom
    }    
    
    //MARK: UIViewControllerTransitioningDelegate extension methods
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        transition.transitionMode = .present
        transition.startingPoint = menuButton.center
        transition.circleColor = menuButton.backgroundColor!        
        return transition
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        transition.transitionMode = .dismiss
        transition.startingPoint = menuButton.center
        transition.circleColor = menuButton.backgroundColor!        
        return transition
    }
}

