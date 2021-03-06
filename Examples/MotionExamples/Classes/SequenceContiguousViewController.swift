//
//  SequenceContiguousViewController.swift
//  MotionExamples
//
//  Created by Brett Walker on 6/2/16.
//  Copyright © 2016 Poet & Mountain, LLC. All rights reserved.
//

import UIKit

public class SequenceContiguousViewController: UIViewController, ButtonsViewDelegate {

    var createdUI: Bool = false
    var buttonsView: ButtonsView!
    var square: UIView!
    var sequence: MotionSequence!
    
    var constraints: [String : NSLayoutConstraint] = [:]
    
    
    convenience init() {
        self.init(nibName: nil, bundle: nil)
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    
    
    public override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        if (!createdUI) {
            setupUI()
            
            // setup motion
            let new_x = Double((view.bounds.size.width * 0.5) - 20.0)
            let move_right = Motion(target: constraints["x"]!,
                                properties: [PropertyData("constant", new_x)],
                                  duration: 1.0,
                                    easing: EasingCubic.easeInOut())
            
            let move_down = Motion(target: constraints["y"]!,
                               properties: [PropertyData("constant", 250.0)],
                                 duration: 0.8,
                                   easing: EasingQuartic.easeInOut())
            
            let change_color = Motion(target: square,
                                  finalState: ["backgroundColor" : UIColor.init(red: 91.0/255.0, green:189.0/255.0, blue:231.0/255.0, alpha:1.0)],
                                    duration: 0.9,
                                      easing: EasingQuadratic.easeInOut())
            
            let expand_width = Motion(target: constraints["width"]!,
                                   properties: [PropertyData("constant", 150.0)],
                                   duration: 0.8,
                                   easing: EasingCubic.easeInOut())
            
            let expand_height = Motion(target: constraints["height"]!,
                                  properties: [PropertyData("constant", 150.0)],
                                    duration: 0.8,
                                      easing: EasingCubic.easeInOut())
            
            let corner_radius = Motion(target: square,
                                       properties: [PropertyData("layer.cornerRadius", 75.0)],
                                       duration: 0.8,
                                       easing: EasingCubic.easeInOut())
            
            let group = MotionGroup(motions: [move_right, change_color])
            let expand_group = MotionGroup(motions: [expand_width, expand_height, corner_radius])
            
            sequence = MotionSequence(steps: [group, move_down, expand_group], options: [.Reverse])
            .stepCompleted({ (sequence) in
                print("step complete")
            })
            .completed({ (sequence) in
                print("sequence complete")
            })
            sequence.reversingMode = .Contiguous
            
            
            createdUI = true
        }
        
    }
    
    
    
    public override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        sequence.start()
    }
    
    
    override public func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        
        sequence.stop()
    }
    
    deinit {
        (view as! ButtonsView).delegate = nil
    }
    
    
    
    
    // MARK: - Private methods
    
    private func setupUI() {
        view.backgroundColor = UIColor.whiteColor()
        let margins = view.layoutMarginsGuide
        
        buttonsView = ButtonsView.init(frame: CGRectZero)
        view.addSubview(buttonsView)
        buttonsView.delegate = self
        buttonsView.translatesAutoresizingMaskIntoConstraints = false
        
        buttonsView.widthAnchor.constraintEqualToAnchor(margins.widthAnchor, constant: 0.0).active = true
        buttonsView.heightAnchor.constraintEqualToAnchor(margins.heightAnchor, constant: 0.0).active = true
        
        
        // set up motion views
        
        square = UIView.init()
        square.backgroundColor = UIColor.init(red: 76.0/255.0, green:164.0/255.0, blue:68.0/255.0, alpha:1.0)
        square.layer.masksToBounds = true
        square.layer.cornerRadius = 20.0
        self.view.addSubview(square)

        
        // set up motion constraints
        square.translatesAutoresizingMaskIntoConstraints = false
        
        let square_x = square.centerXAnchor.constraintEqualToAnchor(margins.leadingAnchor, constant: 20.0)
        square_x.active = true
        let square_y = square.centerYAnchor.constraintEqualToAnchor(margins.topAnchor, constant: topLayoutGuide.length+40.0)
        square_y.active = true
        let square_height = square.heightAnchor.constraintEqualToConstant(40.0)
        square_height.active = true
        let square_width = square.widthAnchor.constraintEqualToConstant(40.0)
        square_width.active = true
        
        constraints["x"] = square_x
        constraints["y"] = square_y
        constraints["width"] = square_width
        constraints["height"] = square_height
    }
    
    
    // MARK: - ButtonsViewDelegate methods
    
    func didStart() {
        sequence.start()
    }
    
    func didStop() {
        sequence.stop()
    }
    
    func didPause() {
        sequence.pause()
    }
    
    func didResume() {
        sequence.resume()
    }


}
