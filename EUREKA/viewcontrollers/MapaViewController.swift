//
//  MapaViewController.swift
//  EUREKA
//
//  Created by Katshuioyse on 20/10/17.
//  Copyright © 2017 Instituto Mauá de Tecnologia. All rights reserved.
//

import UIKit

class MapaViewController: UIViewController,UIScrollViewDelegate{
    
    @IBOutlet weak var ScrollView: UIScrollView!
    @IBOutlet weak var ImageView: UIImageView!
    
    
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        self.ScrollView.backgroundColor = UIColor(red: 0.00, green: 0.10, blue: 0.17, alpha: 1.0)
        self.ScrollView.bounces = false
        self.ScrollView.minimumZoomScale = 1.0
        self.ScrollView.maximumZoomScale = 3.0
        self.ScrollView.showsVerticalScrollIndicator = false
        self.ScrollView.showsHorizontalScrollIndicator = false
        self.ScrollView.bouncesZoom = true
    }
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return self.ImageView
    }
    
    override var preferredStatusBarStyle : UIStatusBarStyle {
        return UIStatusBarStyle.lightContent
    }
    
}
