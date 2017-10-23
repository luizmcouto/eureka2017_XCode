//
//  UITabBarController.swift
//  TabTeste
//
//  Created by Katshuioyse on 11/10/17.
//  Copyright © 2017 Katshuioyse. All rights reserved.
//

import UIKit

// Pega tamanho da tela //
let screenSize = UIScreen.main.bounds
let screenWidth = screenSize.width
let screenHeight = screenSize.height
//////////////////////////


class TabController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //let TopView=UIView(frame: CGRect(x: 0, y: 0, width: screenWidth, height: screenHeight * 0.07))
        
        // Change UIView background colour
        //TopView.backgroundColor=UIColor.init(red: 0, green: 25, blue: 43, alpha: 0)
        
        // Add rounded corners to UIView
        //        myNewView.layer.cornerRadius=25
        
        // Add border to UIView
        //        myNewView.layer.borderWidth=2
        
        // Change UIView Border Color to Red
        //        myNewView.layer.borderColor = UIColor.red.cgColor
        
        // Add UIView as a Subview
        //self.view.addSubview(TopView)
        
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override var preferredStatusBarStyle : UIStatusBarStyle {
        return UIStatusBarStyle.lightContent
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

