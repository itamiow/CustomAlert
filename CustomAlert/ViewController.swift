//
//  ViewController.swift
//  CustomAlert
//
//  Created by Quang Viện on 15/09/2023.
//

import UIKit
import Lottie
class ViewController: UIViewController {
    var overlayView: UIView?
    var alertView: UIView?
    var dissmis: UIView?
    var animator: UIDynamicAnimator?
    var attachmentBehavior : UIAttachmentBehavior!
    var snapBehavior : UISnapBehavior!
    private var animationView: LottieAnimationView?
    override func viewDidLoad() {
        super.viewDidLoad()
        animator = UIDynamicAnimator(referenceView: view)
        createAlert()
    }
   
    func createAlert() {
        // Here the red alert view is created. It is created with rounded corners and given a shadow around it
        let alertWidth: CGFloat = 300
        let alertHeight: CGFloat = 200
        let buttonWidth: CGFloat = 40
        let alertViewFrame: CGRect = CGRect(x: 100, y: 300, width: alertWidth, height: alertHeight)
        alertView = UIView(frame: alertViewFrame)
        alertView?.backgroundColor = UIColor.white
        alertView?.alpha = 0.0
        alertView?.layer.cornerRadius = 10;
        alertView?.layer.shadowColor = UIColor.black.cgColor;
        alertView?.layer.shadowOffset = CGSize(width: 0, height: 5);
        alertView?.layer.shadowOpacity = 0.3;
        alertView?.layer.shadowRadius = 10.0;
        
        // Create a button and set a listener on it for when it is tapped. Then the button is added to the alert view
        let button = UIButton(type: .custom)
        button.setImage(UIImage(named: "Dismiss.png"), for: UIControl.State())
        button.backgroundColor = UIColor.clear
        button.frame = CGRect(x: alertWidth/2 - buttonWidth/2, y: -buttonWidth/2, width: buttonWidth, height: buttonWidth)
        
        button.addTarget(self, action: #selector(ViewController.dismissAlert), for: UIControl.Event.touchUpInside)
        
        let rectLabel = CGRect(x: 0, y: button.frame.origin.y + button.frame.height, width: alertWidth, height: alertHeight - buttonWidth/2)
        let label = UILabel(frame: rectLabel)
        label.numberOfLines = 0
        label.font = UIFont.boldSystemFont(ofSize: 18)
        label.text = "Hello"
        label.textAlignment = .center
        
        alertView?.addSubview(label)
        alertView?.addSubview(button)
        view.addSubview(alertView!)
//        animationView = .init(name: "animation")
//        animationView!.frame = alertView!.bounds
//        animationView!.contentMode = .scaleAspectFit
//        animationView!.loopMode = .loop
//        animationView!.animationSpeed = 0.7
//        alertView?.addSubview(animationView!)
//        animationView!.play()
    }
    @objc func dismissAlert() {
        animator?.removeAllBehaviors()

        UIView.animate(withDuration: 0.4, animations: {
            self.overlayView?.alpha = 0.0
            self.alertView?.alpha = 0.0
            }, completion: {
                (value: Bool) in
                self.alertView?.removeFromSuperview()
                self.alertView = nil
        })
    }
    func showAlert() {
        if (alertView == nil) {
            createAlert()
        }
        createGestureRecognizer()
        animator?.removeAllBehaviors()
        
        // Animate in the overlay
        UIView.animate(withDuration: 0.4, animations: {
            self.overlayView?.alpha = 1.0
        })
        
        // Animate the alert view using UIKit Dynamics.
        alertView?.alpha = 1.0
        
        let snapBehaviour: UISnapBehavior = UISnapBehavior(item: alertView!, snapTo: view.center)
        animator?.addBehavior(snapBehaviour)
    }
    func createGestureRecognizer() {
        let panGestureRecognizer: UIPanGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(ViewController.handlePan(_:)))
        view.addGestureRecognizer(panGestureRecognizer)
    }
    @objc func handlePan(_ sender: UIPanGestureRecognizer) {
        
        if (alertView != nil) {
            let panLocationInView = sender.location(in: view)
            let panLocationInAlertView = sender.location(in: alertView)
            
            if sender.state == UIGestureRecognizer.State.began {
                animator?.removeAllBehaviors()
                
                let offset = UIOffset(horizontal: panLocationInAlertView.x - alertView!.bounds.midX, vertical: panLocationInAlertView.y - alertView!.bounds.midY);
                attachmentBehavior = UIAttachmentBehavior(item: alertView!, offsetFromCenter: offset, attachedToAnchor: panLocationInView)
                animator?.addBehavior(attachmentBehavior)
            }
            else if sender.state == UIGestureRecognizer.State.changed{
                attachmentBehavior.anchorPoint = panLocationInView
                
            }
            else if sender.state == UIGestureRecognizer.State.ended {
                animator?.removeAllBehaviors()
                
                snapBehavior = UISnapBehavior(item: alertView!, snapTo: view.center)
                animator?.addBehavior(snapBehavior)
                
                if sender.translation(in: view).y > 100 {
                    dismissAlert()
                }
            }
        }
        
    }
    @IBAction func didTapShowAlert(_ sender: Any) {
        showAlert()
        
    }
    
}

