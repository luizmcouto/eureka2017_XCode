
import UIKit

class ProjetoDetalheController: UIViewController, UITabBarDelegate {
    
    @IBOutlet weak var estandeLabel: UILabel!
    @IBOutlet weak var tituloLabel: UILabel!
    @IBOutlet weak var integrantesTrabalhoLabel: UILabel!
    @IBOutlet weak var descricaoLabel: UILabel!
    
    @IBOutlet weak var botaoVoltar: UIButton!
    
    @IBOutlet weak var tabBar: UITabBar!
    
    @IBOutlet weak var cosmosView: CosmosView!

    var trabalho: Trabalho?
    
    //var isVoltar = true

    @IBAction func voltar(_ sender: AnyObject) {
        self.dismiss(animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.cosmosView.rating = Double(leNota());
        
        self.estandeLabel.attributedText = justifyLabel("Estande: " + (self.trabalho?.estande)!)
        self.tituloLabel.attributedText = justifyLabel((self.trabalho?.titulo)!)
        
        var integrantesTrabalho: String = "Integrantes:\n"
        
        for integranteTrabalho in (self.trabalho?.integrantesTrabalho)! {
            integrantesTrabalho += integranteTrabalho.nome + "\n"
        }
        
        let orientador: String = "\nOrientador:\n" + (self.trabalho?.orientador)!
        
        self.integrantesTrabalhoLabel.attributedText = justifyLabel(integrantesTrabalho + orientador)
        self.descricaoLabel.attributedText = justifyLabel((self.trabalho?.descricao)!)
        
        //self.tabBar.selectedItem = self.tabBar.items![0]
        
        self.cosmosView.didFinishTouchingCosmos = {
            rating in
            
            let preferences = UserDefaults.standard
            var email : String!
            email = preferences.object(forKey: "email") as! String
            
            let url = URL(string: "http://eureka2017.azurewebsites.net/rating_update")!
            var request = URLRequest(url: url)
            request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
            request.httpMethod = "POST"
            let postString = "email=\(email!)&id_trabalho=\((self.trabalho?.estande)!)&avaliacao=\(rating)"
            request.httpBody = postString.data(using: .utf8)
            let task = URLSession.shared.dataTask(with: request) { data, response, error in
                guard let data = data, error == nil else {                                                 // check for fundamental networking error
                    print("error=\(String(describing: error))")
                    return
                }
                
                if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode != 200 {           // check for http errors
                    print("statusCode should be 200, but is \(httpStatus.statusCode)")
                    print("response = \(String(describing: response))")
                }
                
                let responseString = String(data: data, encoding: .utf8)
                print("responseString = \(String(describing: responseString))")
            }
            task.resume()
            
            self.gravaNota(nota: Int(rating))
        }
        
//        if (!isVoltar) {
//            self.botaoVoltar.isHidden = true
//        }
        
        //self.tabBar.selectedItem = self.tabBar.items![0]
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
    
    // MARK: - Custom functions
    
    func justifyLabel(_ text: String) -> NSAttributedString {
        let paragraphStyle = NSMutableParagraphStyle()
        
        paragraphStyle.alignment = NSTextAlignment.justified
        
        let attributedString = NSAttributedString(string: text, attributes: [ NSAttributedStringKey.paragraphStyle: paragraphStyle, NSAttributedStringKey.baselineOffset: NSNumber(value: 0 as Float) ] )
        
        return attributedString
    }
    
    func gravaNota(nota: Int) {
        UserDefaults.standard.set(nota, forKey: trabalho!.estande)
        
        let alertController = UIAlertController(title: "Sucesso", message: "Nota computada com sucesso!", preferredStyle: UIAlertControllerStyle.alert)
        
        let OKAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil)
        
        alertController.addAction(OKAction)
        
        self.present(alertController, animated: true, completion: nil)
    }

    func leNota() -> Int {
        var nota = UserDefaults.standard.object(forKey: trabalho!.estande) as? Int
        
        if (nota == nil) {
            nota = 0
        }
        
        return nota!
    }
}
