//
//  LoginController.swift
//  EUREKA
//
//  Created by Luiz Felipe Marchetti do Couto on 22/10/16.
//  Copyright © 2016 Instituto Mauá de Tecnologia. All rights reserved.
//

import UIKit

var email: String?

class LoginController: UIViewController {

    @IBOutlet weak var emailTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        emailTextField.attributedPlaceholder = NSAttributedString(string:"E-mail", attributes: [NSAttributedStringKey.foregroundColor: UIColor.lightGray])
        
        //Usa extension para teclado sumir ao clicar na tela
        self.hideKeyboardWhenTappedAround()
        
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
    
    // MARK: - Navigation
    
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        
        var performSegue = false
        
        if (identifier == "bemVindoSegue") {
            if(emailTextField.text?.trimmingCharacters(in: CharacterSet.whitespaces) != "" && WebServicesManager.sharedInstance.getUsuarioEureka(email: emailTextField.text!)){
                
                    email = emailTextField.text
                    
                    performSegue = true
                    
                    ////////// Guarda credenciais de login
                    let preferences = UserDefaults.standard
                    preferences.set(email, forKey: "email")
                    /////////////////////////////////////
                
            }
            else {
                let alertController = UIAlertController(title: "Erro", message: "E-mail inválido!", preferredStyle: UIAlertControllerStyle.alert)
                
                let OKAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil)
                
                alertController.addAction(OKAction)
                
                self.present(alertController, animated: true, completion: nil)
                
                performSegue = false;
            }
        }
        
        return performSegue;
    }

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }

}
