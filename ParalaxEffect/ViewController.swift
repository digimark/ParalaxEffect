//
//  ViewController.swift
//  ParalaxEffect
//
//  Created by Nikolay R on 2/2/15.
//  Copyright (c) 2015 Digimark. All rights reserved.
//

import UIKit

enum ParalaxLevel: Float{
    case background = 5.0
    case floor = 0.1
    case floorChildLevel1 = 0.5
    case level1 = 80.0
    case level2 = 160.0
    
    func shadow() -> (offset: CGSize, opacity: Float){
        switch self{
        case .background:
            return (CGSizeZero, 0.0)
        case .level1:
            return (CGSizeMake(1, 1), 0.5)
        case .level2:
            return (CGSizeMake(2, 2), 0.3)
        default:
            return (CGSizeZero, 0.0)
        }
    }
}

class ViewController: UIViewController {

    @IBOutlet var backgroundViews: Array<UIView>?
    @IBOutlet var floorViews: Array<UIView>?
    @IBOutlet var floorChildViewsLevel1: Array<UIView>?
    @IBOutlet var viewsLevel2: Array<UIView>?
    @IBOutlet var viewsLevel3: Array<UIView>?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.addParalaxEffectTo(backgroundViews!, level: .background)
        self.addParalaxEffectTo(floorViews!, level: .floor)
        self.addParalaxEffectTo(floorChildViewsLevel1!, level: .floorChildLevel1)
        self.addParalaxEffectTo(viewsLevel2!, level: .level1)
        self.addParalaxEffectTo(viewsLevel3!, level: .level2)
        
    }

}

//MARK: private
extension ViewController{
    
    private func addParalaxEffectTo(var views: Array<UIView>, var level: ParalaxLevel){
        
        let motionEffectX = UIInterpolatingMotionEffect(keyPath: "center.x", type: .TiltAlongHorizontalAxis)
        motionEffectX.minimumRelativeValue = -level.rawValue
        motionEffectX.maximumRelativeValue = level.rawValue
        
        let motionEffectY = UIInterpolatingMotionEffect(keyPath: "center.y", type: .TiltAlongVerticalAxis)
        motionEffectY.minimumRelativeValue = -level.rawValue/2
        motionEffectY.maximumRelativeValue = level.rawValue/2
        
        let motionGroup = UIMotionEffectGroup()
        motionGroup.motionEffects = [motionEffectX, motionEffectY]
        
        if level == .floor || level == .floorChildLevel1{
            let motionEffectRotateX = UIInterpolatingMotionEffect(keyPath: "transform.rotation.y", type: .TiltAlongHorizontalAxis)
            motionEffectRotateX.minimumRelativeValue = -level.rawValue
            motionEffectRotateX.maximumRelativeValue = level.rawValue
            
            let motionEffectRotateY = UIInterpolatingMotionEffect(keyPath: "transform.rotation.x", type: .TiltAlongVerticalAxis)
            motionEffectRotateY.minimumRelativeValue = level.rawValue * ((level == .floor) ? -0.3 : 0)
            motionEffectRotateY.maximumRelativeValue = level.rawValue * ((level == .floor) ? 0.3 : 0)
            
            motionGroup.motionEffects = [motionEffectX, motionEffectY, motionEffectRotateX, motionEffectRotateY]
        }
       
        
        for view in views{
            view.addMotionEffect(motionGroup)
            view.layer.zPosition = CGFloat(level.rawValue);
            
            view.layer.shadowOffset = level.shadow().offset
            view.layer.shadowOpacity = level.shadow().opacity
            
            
            if level == .floor{
                view.layer.zPosition = 800;
                view.layer.transform = CATransform3DMakeRotation(1.5, 1.0, 0.0, 0.0)
                view.layer.transform.m34 = -1.0/800.0;
            }else if level == .floorChildLevel1{
                view.layer.zPosition = 8000
            }
            
        }
        
    }
    
}

