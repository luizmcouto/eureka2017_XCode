//
//  QRCODEScannerController.swift
//  EUREKA
//
//  Created by Katshuioyse on 20/10/17.
//  Copyright © 2017 Instituto Mauá de Tecnologia. All rights reserved.
//

import UIKit
import AVFoundation

class QRScannerController: UIViewController, AVCaptureMetadataOutputObjectsDelegate {
    
    @IBOutlet var messageLabel:UILabel!
    @IBOutlet var topbar: UIView!
    
    @IBOutlet weak var exitview: UIButton!
    
    @IBAction func exitView(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    var QRCode: String = ""
    
    var captureSession:AVCaptureSession?
    var videoPreviewLayer:AVCaptureVideoPreviewLayer?
    var qrCodeFrameView:UIView?
    
    let supportedCodeTypes = [AVMetadataObject.ObjectType.upce,
                              AVMetadataObject.ObjectType.code39,
                              AVMetadataObject.ObjectType.code39Mod43,
                              AVMetadataObject.ObjectType.code93,
                              AVMetadataObject.ObjectType.code128,
                              AVMetadataObject.ObjectType.ean8,
                              AVMetadataObject.ObjectType.ean13,
                              AVMetadataObject.ObjectType.aztec,
                              AVMetadataObject.ObjectType.pdf417,
                              AVMetadataObject.ObjectType.qr]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Get an instance of the AVCaptureDevice class to initialize a device object and provide the video as the media type parameter.
        let captureDevice = AVCaptureDevice.default(for: AVMediaType.video)
        do {
            // Get an instance of the AVCaptureDeviceInput class using the previous device object.
            let input = try AVCaptureDeviceInput(device: captureDevice!)
            
            // Initialize the captureSession object.
            captureSession = AVCaptureSession()
            
            // Set the input device on the capture session.
            captureSession?.addInput(input)
            
            // Initialize a AVCaptureMetadataOutput object and set it as the output device to the capture session.
            let captureMetadataOutput = AVCaptureMetadataOutput()
            captureSession?.addOutput(captureMetadataOutput)
            
            // Set delegate and use the default dispatch queue to execute the call back
            captureMetadataOutput.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
            captureMetadataOutput.metadataObjectTypes = supportedCodeTypes
            
            // Initialize the video preview layer and add it as a sublayer to the viewPreview view's layer.
            videoPreviewLayer = AVCaptureVideoPreviewLayer(session: captureSession!)
            videoPreviewLayer?.videoGravity = AVLayerVideoGravity.resizeAspectFill
            videoPreviewLayer?.frame = view.layer.bounds
            view.layer.addSublayer(videoPreviewLayer!)
            
            // Start video capture.
            captureSession?.startRunning()
            
            // Move the message label and top bar to the front
            view.bringSubview(toFront: messageLabel)
            view.bringSubview(toFront: topbar)
            
            // Initialize QR Code Frame to highlight the QR code
            qrCodeFrameView = UIView()
            
            if let qrCodeFrameView = qrCodeFrameView {
                qrCodeFrameView.layer.borderColor = UIColor.green.cgColor
                qrCodeFrameView.layer.borderWidth = 2
                view.addSubview(qrCodeFrameView)
                view.bringSubview(toFront: qrCodeFrameView)
            }
            
        } catch {
            // If any error occurs, simply print it out and don't continue any more.
            print(error)
            return
        }
    }
    
    // MARK: - AVCaptureMetadataOutputObjectsDelegate Methods
    
    func captureOutput(_ captureOutput: AVCaptureOutput!, didOutputMetadataObjects metadataObjects: [Any]!, from connection: AVCaptureConnection!) {
        
        // Check if the metadataObjects array is not nil and it contains at least one object.
        if metadataObjects == nil || metadataObjects.count == 0 {
            qrCodeFrameView?.frame = CGRect.zero
            messageLabel.text = "Nenhum QRCode Detectado"
            return
        }
        
        // Get the metadata object.
        let metadataObj = metadataObjects[0] as! AVMetadataMachineReadableCodeObject
        
        if supportedCodeTypes.contains(metadataObj.type) {
            // If the found metadata is equal to the QR code metadata then update the status label's text and set the bounds
            let barCodeObject = videoPreviewLayer?.transformedMetadataObject(for: metadataObj)
            qrCodeFrameView?.frame = barCodeObject!.bounds
            
            if metadataObj.stringValue != nil {
                messageLabel.text = "QRCode Detectado!"
                
                self.exitview.isEnabled = false
                captureSession?.stopRunning()
                
                QRCode = metadataObj.stringValue!
                //AdicionaPontos(QRCode: QRCode)
                print(QRCode)
            }
        }
    }
    
    func AdicionaPontos(QRCode: String){
        
        //Seta url e session
        let url = URL(string: "https://ancient-bastion-16380.herokuapp.com/qrcode.php")
        let session = URLSession.shared
        
        //inicia request de url
        var request = URLRequest(url: url!, cachePolicy: .reloadIgnoringCacheData, timeoutInterval: 30)
        request.httpMethod = "POST"
        
        //Pega dados
        let preferences = UserDefaults.standard
        let email = preferences.object(forKey: "email") as! String
        
        var newString = QRCode.replacingOccurrences(of: "{", with: "", options: .literal, range: nil)
        newString = newString.replacingOccurrences(of: "}", with: "", options: .literal, range: nil)
        newString = newString.replacingOccurrences(of: "\"", with: "", options: .literal, range: nil)
        newString = newString.replacingOccurrences(of: "\\", with: "", options: .literal, range: nil)
        newString = newString.replacingOccurrences(of: " ", with: "", options: .literal, range: nil)
        newString = newString.replacingOccurrences(of: ":", with: "=", options: .literal, range: nil)
        newString = newString.replacingOccurrences(of: ",", with: "&", options: .literal, range: nil)
        
        //Seta Parametros para mandar por POST
        let paramToSend = newString + "&email=" + email
        request.httpBody = paramToSend.data(using: String.Encoding.utf8)
        
        //Resposta da API
        let task = session.dataTask(with: request as URLRequest, completionHandler: {
            (data, response, error) in
            guard let _:Data = data else
            {
                return
            }
            do
            {
                let Resposta = try JSONSerialization.jsonObject(with: data!, options: []) as! [String: Any]
                
                let error = Resposta["error"] as? Bool
                let error_msg = Resposta["error_msg"] as? String
                
                if (error == true){
                    self.MostraAlerta(error_msg!)
                }else{
                    self.MostraAlerta(error_msg!)
                }
            }
            catch
            {
                return
            }
        })
        task.resume()
        
    }
    
    func MostraAlerta(_ message: String) {
        let alert = UIAlertController(title: "Alerta!", message: message, preferredStyle: UIAlertControllerStyle.alert)
        
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: { action in
            self.dismiss(animated: true, completion: nil)
        }
        ))
        self.present(alert, animated: true, completion: nil)
    }
}

