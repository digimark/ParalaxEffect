//
//  ViewController.swift
//  ParalaxEffect
//
//  Created by Nikolay R on 2/2/15.
//  Copyright (c) 2015 Digimark. All rights reserved.
//

import UIKit

enum ParalaxLevel: Float{
    case background = 6.0
    case floor = 0.2
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
    
    private func addParalaxEffectTo(views: Array<UIView>, level: ParalaxLevel){
        func motionEffectOnAxis(type: UIInterpolatingMotionEffectType, level: ParalaxLevel) ->UIInterpolatingMotionEffect{
            
            let keyPath = type == .TiltAlongHorizontalAxis ? "center.x" : "center.y"
            let relativeValue = type == .TiltAlongHorizontalAxis ? level.rawValue : level.rawValue/2.0
            
            
            let motionEffect = UIInterpolatingMotionEffect(keyPath: keyPath , type: type)
            motionEffect.minimumRelativeValue = -relativeValue
            motionEffect.maximumRelativeValue = relativeValue
            
            return motionEffect
        }
        
        let motionEffectX = motionEffectOnAxis(.TiltAlongHorizontalAxis, level)
        let motionEffectY = motionEffectOnAxis(.TiltAlongVerticalAxis, level)
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
       
        //Iterate through each view and add motionEffect, shadow and CATransform3D
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
                view.layer.zPosition = 7000
            }
            
        }
        
    }
    
}

