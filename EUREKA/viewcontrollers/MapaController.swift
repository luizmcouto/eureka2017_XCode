/******************************************************************************/
//                                   EUREKA                                   //
//----------------------------------------------------------------------------//
/*!
 * @brief	Classe MapaController
 *
 * Esta classe funciona como controller do Mapa
 *
 * @author	Luiz Felipe Couto
 */
////////////////////////////////////////////////////////////////////////////////

//------------------------------------------------------------------------------
// Import declaration
//------------------------------------------------------------------------------
import UIKit

//==============================================================================
// Class Definition
//==============================================================================
class MapaController: UIViewController, UITabBarDelegate {

    @IBOutlet weak var origemLabel: UILabel!
    @IBOutlet weak var destinoLabel: UILabel!

    @IBOutlet weak var IRButton: UIButton!
    
    @IBOutlet weak var tabBar: UITabBar!
    
    /**************************************************************************/
    
    //Controle da busca se origem ou destino
    var origemOuDestino: String?
    
    /**************************************************************************/
    
    @IBAction func origemOuDestino(_ sender: UIButton) {
        if (sender.tag == 1) {
            self.origemOuDestino = "origem"
        } else if (sender.tag == 2) {
            self.origemOuDestino = "destino"
        }
    }
    
    /**************************************************************************/

    //------------------------------ viewDidLoad -------------------------------
    /*
     @brief
     */
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.IRButton.isHidden = true
        
        //self.tabBar.selectedItem = self.tabBar.items![1]
    }

    //------------------------------ viewDidAppear -----------------------------
    /*
     @brief
     
     @param animated
     */
    override func viewDidAppear(_ animated: Bool) {
        if (self.origemLabel.text != " " && self.destinoLabel.text != " ") {
            self.IRButton.isHidden = false
        }
    }
    
    //------------------------------ preferredStatusBarStyle -------------------
    /*
     @brief
     
     @return
     */
    override var preferredStatusBarStyle : UIStatusBarStyle {
        return UIStatusBarStyle.lightContent
    }

    //------------------------------ didReceiveMemoryWarning -------------------
    /*
     @brief
     */
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Tab bar
    
    //------------------------------ tabBar ------------------------------------
    /*
     @brief
     
     @param tabBar
     @param didSelectItem
     @param item
     */
//    func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
//        if (item.tag == 1) {
//            let vc = self.storyboard!.instantiateViewController(withIdentifier: "projeto") as! ProjetoController
//
//            self.present(vc, animated: true, completion: nil)
//        }
//        else if (item.tag == 3) {
//            let vc = self.storyboard!.instantiateViewController(withIdentifier: "qrCode") as! QRCodeController
//
//            self.present(vc, animated: true, completion: nil)
//        }
//        else if (item.tag == 4) {
//            let vc = self.storyboard!.instantiateViewController(withIdentifier: "mapaCalor") as! MapaCalorController
//
//            self.present(vc, animated: true, completion: nil)
//        }
//   }
    
    // MARK: - Navigation

    //------------------------------ prepareForSegue ---------------------------
    /*
     @brief
     
     @param segue
     @param sender
     */
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        //Botão Origem
        if (segue.identifier == "origemSegue") {
            let buscaOrigemDestinoController = segue.destination as! BuscaOrigemDestinoController
            
            buscaOrigemDestinoController.parentController = self
            buscaOrigemDestinoController.origemOuDestino = "origem"
        }
        //Botão Destino
        else if (segue.identifier == "destinoSegue") {
            let buscaOrigemDestinoController = segue.destination as! BuscaOrigemDestinoController
            
            buscaOrigemDestinoController.parentController = self
            buscaOrigemDestinoController.origemOuDestino = "destino"
        }
        //Botão IR
        else if (segue.identifier == "irSegue") {
            if (origemLabel.text == destinoLabel.text) {
                let alertController = UIAlertController(title: "Erro", message: "Origem e destino iguais!", preferredStyle: UIAlertControllerStyle.alert)
                
                let OKAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil)
                
                alertController.addAction(OKAction)
                
                self.present(alertController, animated: true, completion: nil)
                
                return
            } else {
                let rotaController = segue.destination as! RotaController
                
                rotaController.idVerticeOrigem = origemLabel.text
                rotaController.idVerticeDestino = destinoLabel.text
            }
        }
    }
    
}
