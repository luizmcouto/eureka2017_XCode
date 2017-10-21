/******************************************************************************/
//                                   EUREKA                                   //
//----------------------------------------------------------------------------//
/*!
 * @brief    Classe MapaController
 *
 * Esta classe funciona como controller do Mapa
 *
 * @author    Luiz Felipe Couto
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
class QRController: UIViewController, UITabBarDelegate, AVCaptureMetadataOutputObjectsDelegate {
    
    @IBOutlet weak var QRCodeView: UIView!
    
    /**************************************************************************/
    
    //QRCode
    var QRCodeFrame: CGRect?
    
    var objCaptureSession: AVCaptureSession?
    var objCaptureVideoPreviewLayer: AVCaptureVideoPreviewLayer?
    
    var trabalhoEncontrado: Trabalho?
    
    /**************************************************************************/
    
    //------------------------------ viewDidLoad -------------------------------
    /*
     @brief
     */
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.definesPresentationContext = true
        
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
        guard let objCaptureDevice = AVCaptureDevice.default(for: .video) else { return }
        
        var error: NSError?
        
        let objCaptureDeviceInput: AnyObject!
        
        do {
            objCaptureDeviceInput = try AVCaptureDeviceInput(device: objCaptureDevice) as AVCaptureDeviceInput
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
        if (objCaptureSession != nil) {
            objCaptureVideoPreviewLayer = AVCaptureVideoPreviewLayer(session: objCaptureSession!)
        }
        else {
            return;
        }
        
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

    func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection){
        
        if let metadataObject = metadataObjects.first {
            guard let readableObject = metadataObject as? AVMetadataMachineReadableCodeObject else { return }
            guard let stringValue = readableObject.stringValue else { return }
            //AudioServicesPlaySystemSound(SystemSoundID(kSystemSoundID_Vibrate))
            found(code: stringValue)
        }
        
    }
    
    func found(code: String) {
        print(code)
        
        if (code != "") {
            let trabalho = trabalhos.filter( { trabalho in
                return trabalho.estande == code } )
            
            if (trabalho.count != 0) {
                if let projetoDetalheController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "projetoDetalhe") as? ProjetoDetalheController
                {
                    projetoDetalheController.trabalho = trabalho[0]
                    
                    present(projetoDetalheController, animated: true, completion: nil)
                }
                
            } else {
                MostraAlerta("Trabalho não encontrado!")
            }
        } else {
            MostraAlerta("Trabalho não encontrado!")
            
            return
        }
    }
    
    
    
    func MostraAlerta(_ message: String) {
        let alert = UIAlertController(title: "Alerta!", message: message, preferredStyle: UIAlertControllerStyle.alert)
        
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: { action in
            self.dismiss(animated: true, completion: nil)
        }
        ))
        self.present(alert, animated: true, completion: nil)
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .portrait
    }
    
}

