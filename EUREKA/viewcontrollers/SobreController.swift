//
//  LoginController.swift
//  EUREKA
//
//  Created by Luiz Felipe Marchetti do Couto on 22/10/16.
//  Copyright © 2016 Instituto Mauá de Tecnologia. All rights reserved.
//

import UIKit

class SobreController: UIViewController {
    
    @IBAction func voltar(_ sender: AnyObject) {
        dismiss(animated: true, completion: nil)
    }
    @IBAction func voltar_texto(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func websiteEUREKA(_ sender: AnyObject) {
        UIApplication.shared.open(URL(string: "http://eureka.maua.br/")!)
    }
    
    @IBAction func websiteMaua(_ sender: AnyObject) {
        UIApplication.shared.open(URL(string: "http://www.maua.br/")!)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //------------------------------ preferredStatusBarStyle -------------------
    /*
     @brief
     
     @return
     */
    override var preferredStatusBarStyle : UIStatusBarStyle {
        return UIStatusBarStyle.lightContent
    }
    
}
