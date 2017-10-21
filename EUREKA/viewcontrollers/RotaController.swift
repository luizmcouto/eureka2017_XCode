/******************************************************************************/
//                                   EUREKA                                   //
//----------------------------------------------------------------------------//
/*!
 * @brief	Classe RotaController
 *
 * Esta classe funciona como controller da rota no mapa
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
class RotaController: UIViewController, UITabBarDelegate, UIGestureRecognizerDelegate {

    /**************************************************************************/

    @IBOutlet weak var tabBar: UITabBar!
    @IBOutlet weak var mapaView: MapaView!
    
    /**************************************************************************/
    
    //Leitura dos dados do banco
    var firstTimeReadTableVertices: Bool = true
    
    //Vértices de origem e destino
    var idVerticeOrigem: String?
    var idVerticeDestino: String?
    
    //Controle de gestos
    var pinchGesture = UIPinchGestureRecognizer()
    var panGesture = UIPanGestureRecognizer()

    var lastScale: CGFloat = 0.0
    
    /**************************************************************************/

    //------------------------------ viewDidLoad -------------------------------
    /*
     @brief
     */
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Gestures
        //self.pinchGesture.delegate = self
        //self.panGesture.delegate = self
        
        self.pinchGesture = UIPinchGestureRecognizer(target: self, action: #selector(RotaController.pinchRecognized(_:)))
        
        self.panGesture = UIPanGestureRecognizer(target: self, action: #selector(RotaController.panRecognized(_:)))
        
        self.mapaView.addGestureRecognizer(self.pinchGesture)
        self.mapaView.addGestureRecognizer(self.panGesture)
        
        //Busca melhor rota
        if (idVerticeOrigem != nil && idVerticeDestino != nil) {
            self.mapaView.idVerticeOrigem = idVerticeOrigem
            self.mapaView.idVerticeDestino = idVerticeDestino
            
            let (distances, pathDict) = graph.dijkstra(root: idVerticeOrigem!, startDistance: 0.0)
            let path: [WeightedEdge<Double>] = pathDictToPath(from: graph.indexOfVertex(idVerticeOrigem!)!, to: graph.indexOfVertex(idVerticeDestino!)!, pathDict: pathDict)
            let stops: [String] = edgesToVertices(edges: path, graph: graph)
            let nameDistance: [String: Double?] = distanceArrayToVertexDict(distances: distances, graph: graph)
            
            self.mapaView.stops = stops
            self.mapaView.nameDistance = nameDistance
        }
        
        self.tabBar.selectedItem = self.tabBar.items![1]
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
    
    //------------------------------ pinch -------------------------------------
    /*
     @brief
     
     @param tabBar
     @param didSelectItem
     */
    func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        if (item.tag == 1) {
            let vc = self.storyboard!.instantiateViewController(withIdentifier: "projeto") as! ProjetoController
            
            self.present(vc, animated: true, completion: nil)
        }
        else if (item.tag == 3) {
            let vc = self.storyboard!.instantiateViewController(withIdentifier: "qrCode") as! QRCodeController
            
            self.present(vc, animated: true, completion: nil)
        }
        else if (item.tag == 4) {
            let vc = self.storyboard!.instantiateViewController(withIdentifier: "mapaCalor") as! MapaCalorController
            
            self.present(vc, animated: true, completion: nil)
        }
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    // MARK: - Gestures
    
    //------------------------------ pinchRecognized ---------------------------
    /*
     @brief
     
     @param pinch
     */
    @objc func pinchRecognized(_ pinch: UIPinchGestureRecognizer) {
        if (pinch.state == UIGestureRecognizerState.began) {
            lastScale = 1.0
        }
        
        let currentScale: CGFloat = self.mapaView.transform.a
        
        let kMaxScale: CGFloat = 5.0
        let kMinScale: CGFloat = 1.0
        
        var newScale: CGFloat = 1.0 - (lastScale - pinch.scale);
        
        newScale = min(newScale, kMaxScale / currentScale)
        newScale = max(newScale, kMinScale / currentScale)
        
        self.mapaView.transform = self.mapaView.transform.scaledBy(x: newScale, y: newScale)
        
        if (newScale < currentScale) {
            if (mapaView.frame.origin.x > 0) {
                self.mapaView.frame.origin.x = 0.0
                
            } else if ((mapaView.frame.size.width - abs(mapaView.frame.origin.x)) <= self.mapaView.bounds.width) {
                
                self.mapaView.frame.origin.x = self.mapaView.bounds.width - mapaView.frame.size.width
            }
            
            if ((mapaView.frame.size.height - 66 - abs(mapaView.frame.origin.y)) <= self.mapaView.bounds.height) {
                
                self.mapaView.frame.origin.y = self.mapaView.bounds.height + 66 - mapaView.frame.size.height

            } else if (mapaView.frame.origin.y - 66 > 0) {
                self.mapaView.frame.origin.y = 66.0
                
            }
        }

        lastScale = pinch.scale
    }

    //------------------------------ panRecognized -----------------------------
    /*
     @brief
     
     @param pan
     */
    @objc func panRecognized(_ pan: UIPanGestureRecognizer) {
        let translation: CGPoint = pan.translation(in: self.mapaView)
        var finalPoint: CGPoint = CGPoint(x: pan.view!.center.x + translation.x, y: pan.view!.center.y + translation.y)
        
        //limit the boundary
        if ((pan.view!.frame.origin.x > 0 && translation.x > 0) || ((pan.view!.frame.size.width - abs(pan.view!.frame.origin.x)) <= self.mapaView.bounds.width && translation.x < 0)) {
        
            finalPoint.x = pan.view!.center.x
        }
        
        if ((pan.view!.frame.origin.y - 66 > 0 && translation.y > 0) || ((pan.view!.frame.size.height - 66 - abs(pan.view!.frame.origin.y)) <= self.mapaView.bounds.height && translation.y < 0)) {
            
            finalPoint.y = pan.view!.center.y
        }
        
        pan.view?.center = finalPoint
        
        pan.setTranslation(CGPoint.zero, in: self.mapaView)
    }
}
