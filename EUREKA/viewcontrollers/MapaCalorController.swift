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
import AVFoundation
import UIKit

//==============================================================================
// Class Definition
//==============================================================================
class MapaCalorController: UIViewController, UITabBarDelegate {
    
    @IBOutlet weak var tabBar: UITabBar!
    
    @IBOutlet weak var mapaCalorView: UIImageView!
    
    /**************************************************************************/
    
    /**************************************************************************/
    
    //------------------------------ viewDidLoad -------------------------------
    /*
     @brief
     */
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.definesPresentationContext = true
        
        //self.tabBar.selectedItem = self.tabBar.items![3]
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if let data = NSData(contentsOf: URL(string: "https://s3-sa-east-1.amazonaws.com/maua/eureka/MapaCalor_EUREKA_2016.png")!) {
            mapaCalorView.image = UIImage(data: data as Data)
        }
    }
    
    //------------------------------ didReceiveMemoryWarning -------------------
    /*
     @brief
     */
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
    
    // MARK: - Tab bar
    
    //------------------------------ pinch -------------------------------------
    /*
     @brief
     
     @param tabBar
     @param didSelectItem
     */
//    func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
//        if (item.tag == 1) {
//            let vc = self.storyboard!.instantiateViewController(withIdentifier: "projeto") as! ProjetoController
//
//            self.present(vc, animated: true, completion: nil)
//        }
//        else if (item.tag == 2) {
//            let vc = self.storyboard!.instantiateViewController(withIdentifier: "mapa") as! MapaController
//
//            self.present(vc, animated: true, completion: nil)
//        }
//        else if (item.tag == 3) {
//            let vc = self.storyboard!.instantiateViewController(withIdentifier: "qrCode") as! QRCodeController
//
//            self.present(vc, animated: true, completion: nil)
//        }
//    }
    
}
