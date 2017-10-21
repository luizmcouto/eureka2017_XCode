//
//  Extension KeyBoardHide.swift
//  EUREKA
//
//  Created by Katshuioyse on 13/10/17.
//  Copyright © 2017 Instituto Mauá de Tecnologia. All rights reserved.
//

import UIKit

extension UIViewController {
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}
