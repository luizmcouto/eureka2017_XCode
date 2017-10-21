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
class BuscaOrigemDestinoController: UIViewController, UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate, UITabBarDelegate, AVCaptureMetadataOutputObjectsDelegate {

    @IBOutlet weak var QRCodeView: UIView!
    
    @IBOutlet weak var trabalhoSearchBar: UISearchBar!
    @IBOutlet weak var trabalhoTableView: UITableView!

    @IBOutlet weak var tabBar: UITabBar!
    
    /**************************************************************************/
    
    //Controller de busca
    var searchController: UISearchController?
    
    //Controller pai
    var parentController: MapaController?
    
    //Origem ou destino
    var origemOuDestino: String?

    //QRCode
    var QRCodeFrame: CGRect?
    
    var objCaptureSession: AVCaptureSession?
    var objCaptureVideoPreviewLayer: AVCaptureVideoPreviewLayer?
    
    /**************************************************************************/

    //------------------------------ viewDidLoad -------------------------------
    /*
     @brief
     
     @param sender
     */
    @IBAction func voltar(_ sender: AnyObject) {
        self.dismiss(animated: true, completion: nil)
    }
    
    /**************************************************************************/

    //------------------------------ viewDidLoad -------------------------------
    /*
     @brief
     */
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let textFieldInsideSearchBar = self.trabalhoSearchBar.value(forKey: "searchField") as? UITextField
        
        textFieldInsideSearchBar?.layer.borderWidth = 0.7
        textFieldInsideSearchBar?.layer.borderColor = UIColor.white.cgColor
        textFieldInsideSearchBar?.layer.cornerRadius = 6
        textFieldInsideSearchBar?.backgroundColor = UIColor(red: 0.00, green: 0.10, blue: 0.17, alpha: 1.0)
        textFieldInsideSearchBar?.textColor = UIColor.white
        
        self.searchController = UISearchController(searchResultsController: nil)
        
        self.definesPresentationContext = true
        
        self.tabBar.selectedItem = self.tabBar.items![1]
    }
    
    //------------------------------ viewDidAppear -----------------------------
    /*
     @brief
     
     @param animated
     */
    override func viewDidAppear(_ animated: Bool) {
        //Liga a câmera e coloca a imagem como fundo da view
        self.configureVideoCapture()
        
        //Define o QRCodeFrame para leitura do QRCode
        self.addVideoPreviewLayer()

        //Adiciona o QRCodeFrame ao view
        self.createQRCodeOverlay(CGRect(x: 0.0, y: 0.0, width: self.QRCodeView.frame.width, height: self.QRCodeView.frame.height))
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

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    // MARK: - Tab bar
    
    //------------------------------ tabBar ------------------------------------
    /*
     @brief
     
     @param tabBar
     @param didSelectItem
     @param item
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

    // MARK: - Table view data source
    
    //------------------------------ numberOfSectionsInTableView ---------------
    /*
     @brief
     
     @param tableView
     
     @return
     */
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    //------------------------------ tableView ---------------------------------
    /*
     @brief
     
     @param tableView
     @param numberOfRowsInSection
     
     @return
     */
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if (self.trabalhoSearchBar.text != "") {
            return filteredTrabalhos.count
        } else {
            return trabalhos.count
        }
    }
    
    //------------------------------ tableView ---------------------------------
    /*
     @brief
     
     @param tableView
     @param cellForRowAtIndexPath
     
     @return
     */
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var trabalho: Trabalho
        
        if (self.trabalhoSearchBar.text != "") {
            trabalho = filteredTrabalhos[(indexPath as NSIndexPath).row]
        } else {
            trabalho = trabalhos[(indexPath as NSIndexPath).row]
        }
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "trabalhoCell", for: indexPath) as! ProjetoViewCell
        
        cell.tituloLabel.text = trabalho.titulo
        cell.descricaoLabel.text = trabalho.descricao
        
        return cell
    }
    
    //------------------------------ tableView ---------------------------------
    /*
     @brief
     
     @param tableView
     @param didSelectRowAtIndexPath
     
     @return
     */
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        var trabalho: Trabalho
        
        if (self.trabalhoSearchBar.text != "") {
            trabalho = filteredTrabalhos[(indexPath as NSIndexPath).row]
        } else {
            trabalho = trabalhos[(indexPath as NSIndexPath).row]
        }
        
        if (self.origemOuDestino == "origem") {
            self.parentController!.origemLabel.text = String(describing: trabalho.estande)
        } else if (self.origemOuDestino == "destino") {
            self.parentController!.destinoLabel.text = String(describing: trabalho.estande)
        }
        
        self.trabalhoTableView.isHidden = true
        self.trabalhoTableView.deselectRow(at: indexPath, animated: true)
        
        self.view.endEditing(true)
        
        self.searchController?.view.removeFromSuperview()
        
        self.dismiss(animated: true, completion: nil)
    }
    
    // MARK: - Search
    
    //------------------------------ searchBarShouldBeginEditing ---------------
    /*
     @brief
     
     @param searchBar
     
     @return
     */
    func searchBarShouldBeginEditing(_ searchBar: UISearchBar) -> Bool {
        searchBar.showsScopeBar = true
        searchBar.showsCancelButton = true
        
        let cancelButtonSearchBar = searchBar.value(forKey: "cancelButton") as? UIButton
        
        cancelButtonSearchBar?.setTitle("Cancelar", for: UIControlState())
        
        self.trabalhoTableView.isHidden = false
        self.trabalhoTableView.reloadData()
        
        return true
    }
    
    //------------------------------ searchBarShouldEndEditing -----------------
    /*
     @brief
     
     @param searchBar
     
     @return
     */
    func searchBarShouldEndEditing(_ searchBar: UISearchBar) -> Bool {
        self.trabalhoTableView.isHidden = true
        
        return true
    }
    
    //------------------------------ searchBarCancelButtonClicked --------------
    /*
     @brief
     
     @param searchBar
     
     @return
     */
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.text = ""
        searchBar.showsCancelButton = false
        searchBar.resignFirstResponder()
        
        self.trabalhoTableView.isHidden = true
    }
    
    //------------------------------ searchBar ---------------------------------
    /*
     @brief
     
     @param searchBar
     @param textDidChange
     
     @return
     */
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        filterContentForSearchText(searchBar.text!)
    }
    
    //------------------------------ filterContentForSearchText ----------------
    /*
     @brief
     
     @param filterContentForSearchText
     @param scope
     
     @return
     */
    func filterContentForSearchText(_ searchText: String, scope: String = "All") {
        filteredTrabalhos = trabalhos.filter { trabalho in
            return trabalho.titulo.lowercased().contains(searchText.lowercased())
        }
        
        self.trabalhoTableView.reloadData()
    }
    
    // MARK: - Custom functions
    
    //------------------------------ createQRCodeOverlay -----------------------
    /*
     @brief
     
     @param frame
     */
    func createQRCodeOverlay(_ frame : CGRect)
    {
        let overlayView = UIView(frame: frame)
        
        overlayView.backgroundColor = UIColor(red: 0.0, green: 0.10, blue: 0.17, alpha: 0.68)
        
        //Cria máscara
        let maskLayer = CAShapeLayer()
        
        maskLayer.frame = overlayView.bounds
        maskLayer.fillColor = UIColor.black.cgColor
        
        // Create the frame for the circle.
        let radius: CGFloat = 20.0
        let qrCodeFrame = CGRect(x: overlayView.frame.width / 2.0 - 125.0, y: overlayView.frame.height / 2.0 - 125.0, width: 250.0, height: 250.0)
        
        // Create the path.
        let path = UIBezierPath(rect: overlayView.bounds)
        
        maskLayer.fillRule = kCAFillRuleEvenOdd
        
        // Append the circle to the path so that it is subtracted.
        path.append(UIBezierPath(roundedRect: qrCodeFrame, cornerRadius: radius))
        
        maskLayer.path = path.cgPath

        overlayView.layer.mask = maskLayer

        self.QRCodeView.addSubview(overlayView)
    }

    //------------------------------ configureVideoCapture ---------------------
    /*
     @brief
     */
    func configureVideoCapture() {
        let objCaptureDevice = AVCaptureDevice.default(for: AVMediaType.video)
        
        var error: NSError?
        
        let objCaptureDeviceInput: AnyObject!
        
        do {
            objCaptureDeviceInput = try AVCaptureDeviceInput(device: objCaptureDevice!) as AVCaptureDeviceInput
        } catch let error1 as NSError {
            error = error1
            objCaptureDeviceInput = nil
        }

        if (error != nil) {
            let alertController = UIAlertController(title: "Erro", message: "Dispositivo não suportado para esta aplicação!", preferredStyle: UIAlertControllerStyle.alert)
            
            let OKAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil)
            
            alertController.addAction(OKAction)
            
            self.present(alertController, animated: true, completion: nil)

            return
        }
        
        objCaptureSession = AVCaptureSession()
        objCaptureSession?.addInput(objCaptureDeviceInput as! AVCaptureInput)
        
        let objCaptureMetadataOutput = AVCaptureMetadataOutput()
        
        objCaptureSession?.addOutput(objCaptureMetadataOutput)
        
        objCaptureMetadataOutput.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
        objCaptureMetadataOutput.metadataObjectTypes = [AVMetadataObject.ObjectType.qr]
    }

    //------------------------------ addVideoPreviewLayer ----------------------
    /*
     @brief
     */
    func addVideoPreviewLayer()
    {
        objCaptureVideoPreviewLayer = AVCaptureVideoPreviewLayer(session: objCaptureSession!)
        
        objCaptureVideoPreviewLayer?.videoGravity = AVLayerVideoGravity.resizeAspectFill
        objCaptureVideoPreviewLayer?.frame = self.QRCodeView.layer.bounds
        
        self.QRCodeView.layer.addSublayer(objCaptureVideoPreviewLayer!)
        
        objCaptureSession?.startRunning()
    }
    
    //------------------------------ captureOutput -----------------------------
    /*
     @brief
     
     @param didOutputMetadataObjects
     @param fromConnection
     */
    func metadataOutput(captureOutput: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
        
        if metadataObjects == nil || metadataObjects.count == 0 {
            print("No QRCode text detected")
            
            return
        }
        
        let objMetadataMachineReadableCodeObject = metadataObjects[0] as! AVMetadataMachineReadableCodeObject
        
        if (objMetadataMachineReadableCodeObject.type == AVMetadataObject.ObjectType.qr) {
            let objBarCode = self.objCaptureVideoPreviewLayer?.transformedMetadataObject(for: objMetadataMachineReadableCodeObject as AVMetadataMachineReadableCodeObject) as! AVMetadataMachineReadableCodeObject
            
            self.QRCodeFrame = objBarCode.bounds
            
            if (objMetadataMachineReadableCodeObject.stringValue != nil) {
                let trabalho = trabalhos.filter( { trabalho in
                    return trabalho.estande == objMetadataMachineReadableCodeObject.stringValue } )
                
                if (trabalho.count != 0) {
                    if (self.origemOuDestino == "origem") {
                        self.parentController!.origemLabel.text = objMetadataMachineReadableCodeObject.stringValue
                    } else if (self.origemOuDestino == "destino") {
                        self.parentController!.destinoLabel.text = objMetadataMachineReadableCodeObject.stringValue
                    }
                } else {
                    let alertController = UIAlertController(title: "Erro", message: "Trabalho não encontrado!", preferredStyle: UIAlertControllerStyle.alert)
                    
                    let OKAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil)
                    
                    alertController.addAction(OKAction)
                    
                    self.present(alertController, animated: true, completion: nil)
                    
                    return
                }
                
                self.dismiss(animated: true, completion: nil)
            }
        }
    }

}
