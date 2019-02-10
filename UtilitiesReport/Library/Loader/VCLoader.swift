//
//  VCLoader.swift
//  UtilitiesReport
//
//  Created by Vadim Albul on 2/10/19.
//  Copyright © 2019 Vadim Albul. All rights reserved.
//

import Foundation
import UIKit.UIViewController
import UIKit.UIStoryboard

class VCLoader<VC: UIViewController> {
    
    enum Storyboards: String {
        case main = "Main"
        case navigation = "Navigation"
    }
    
    class func load(storyboardName storyboard: String!) -> VC {
        let className = NSStringFromClass(VC.self).components(separatedBy: ".").last!
        return VCLoader<VC>.load(storyboardName: storyboard, inStoryboardID: className)
    }
    
    class func loadInitial(storyboardName storyboard: String!) -> VC {
        let storyboard = UIStoryboard(name: storyboard, bundle: Bundle.main)
        return storyboard.instantiateInitialViewController() as! VC
    }
    
    class func load(storyboardName storyboard: String!, inStoryboardID: String!) -> VC {
        let storyboard = UIStoryboard(name: storyboard, bundle: Bundle.main)
        return storyboard.instantiateViewController(withIdentifier: inStoryboardID) as! VC
    }
}

extension VCLoader {
    class func load(storyboardId storyboard: VCLoader.Storyboards) -> VC {
        return VCLoader<VC>.load(storyboardName: storyboard.rawValue)
    }
    
    class func loadInitial(storyboardId storyboard: VCLoader.Storyboards) -> VC {
        return VCLoader<VC>.loadInitial(storyboardName: storyboard.rawValue)
    }
}
