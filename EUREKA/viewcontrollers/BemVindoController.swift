//
//  LoginController.swift
//  EUREKA
//
//  Created by Luiz Felipe Marchetti do Couto on 22/10/16.
//  Copyright © 2016 Instituto Mauá de Tecnologia. All rights reserved.
//

import UIKit

class BemVindoController: UIViewController {
    
    @IBOutlet weak var Descricao: UILabel!
    
    var texto = "Exposição, aberta ao público, dos trabalhos de graduação dos cursos de Administração, Design e Engenharia com o objetivo de divulgar projetos dos estudantes para empresas de diversos segmentos, além de fazer uma conexão do meio acadêmico com o empresarial, realizada no Campus de São Caetano do Sul."
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //////// deixa texto justificado e com hifens
        let paragraphStyle: NSMutableParagraphStyle = NSMutableParagraphStyle()
        paragraphStyle.hyphenationFactor = 1.0
        let attributedString: NSMutableAttributedString = NSMutableAttributedString(string: texto, attributes: [NSAttributedStringKey.paragraphStyle:paragraphStyle])
        
        Descricao.attributedText = attributedString
        Descricao.textAlignment = .justified
        ////////
        
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
