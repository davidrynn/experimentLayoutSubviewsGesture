//
//  SwipeGestureTestViewController.swift
//  pvc-experiment
//
//  Created by Rynn, David on 5/11/18.
//  Copyright © 2018 Rynn, David. All rights reserved.
//

import UIKit

class SwipeGestureTestViewController: UIViewController {
    
    let box = UIView()
    var startPoint = CGPoint(x: 0, y: 0)
    let bottomLabelHeight: CGFloat = 60
    let bottomLabel = UILabel()

    override func viewDidLoad() {
        super.viewDidLoad()
        box.backgroundColor = UIColor.blue
        box.frame = CGRect(x: 0, y: 0, width: 100, height: 100)
        view.addSubview(box)
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(boxDragged(recognizer:)))
        box.addGestureRecognizer(panGesture)
        let pinchRecognizer = UIPinchGestureRecognizer(target: self, action: #selector(boxPinched(recognizer:)))
        box.addGestureRecognizer(pinchRecognizer)
        bottomLabel.frame = CGRect(x: 0, y: view.bounds.height - bottomLabelHeight, width: view.bounds.width, height: bottomLabelHeight)
        view.addSubview(bottomLabel)
        

        // Do any additional setup after loading the view.
    }
    
    /** Waits a number of seconds, and then performs a closure on the main thread.
     Hats off to Matt Neuburg: http://stackoverflow.com/questions/24034544/dispatch-after-gcd-in-swift/24318861#24318861 */
    func delay(_ delay: Double, closure: @escaping () -> Void) {
        let when = DispatchTime.now() + delay
        DispatchQueue.main.asyncAfter(deadline: when, execute: closure)
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        bottomLabel.text = #function
        delay(1, closure: {
            self.bottomLabel.text = ""
        })
        print(#function)
    }
    
    @objc func boxPinched(recognizer: UIPinchGestureRecognizer) {
        box.transform = box.transform.scaledBy(x: recognizer.scale, y: recognizer.scale)
        recognizer.scale = 1
    }
    
    @objc func boxDragged(recognizer: UIPanGestureRecognizer){
        let translation = recognizer.translation(in: view)
        let newX = box.center.x + translation.x
        box.center = CGPoint(x: newX, y: box.center.y + translation.y)
        recognizer.setTranslation(CGPoint.zero, in: view)
        //
        if recognizer.state == UIGestureRecognizerState.ended {
            // 1
            let velocity = recognizer.velocity(in: self.view)
            let magnitude = sqrt((velocity.x * velocity.x) + (velocity.y * velocity.y))
            let slideMultiplier = magnitude / 400
            
            // 2
            let slideFactor = 0.1 * slideMultiplier     //Increase for more of a slide
            // 3
            var finalPoint = CGPoint(x:recognizer.view!.center.x + (velocity.x * slideFactor),
                                     y:recognizer.view!.center.y + (velocity.y * slideFactor))
            // 4
            finalPoint.x = min(max(finalPoint.x, 0), self.view.bounds.size.width)
            finalPoint.y = min(max(finalPoint.y, 40), self.view.bounds.size.height - bottomLabelHeight)
            
            // 5
            UIView.animate(withDuration: Double(slideFactor * 2),
                           delay: 0,
                           // 6
                options: UIViewAnimationOptions.curveEaseOut,
                animations: {recognizer.view!.center = finalPoint },
                completion: nil)
        }

    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
