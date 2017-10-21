//
//  WebServicesConnection.swift
//  EUREKA
//
//  Created by Luiz Felipe Marchetti do Couto on 08/10/16.
//  Copyright © 2016 Instituto Mauá de Tecnologia. All rights reserved.
//

import Foundation

class WebServicesManager: NSObject, NSURLConnectionDelegate, XMLParserDelegate {
    
    static let sharedInstance = WebServicesManager()
    
    let urlEUREKAWS = "https://www2.maua.br/soap/eureka/app"
    let token: String = "11LaY!u/bc/q"

    var metodo: String?
    
    var mutableData: NSMutableData  = NSMutableData()
    var currentElementName: String?
    
    var isAutenticado = false
    
    fileprivate override init() {
        super.init()
    }

    func getUsuarioEureka(email: String) -> Bool {
        metodo = "getUsuarioEureka"
        if email.trimmingCharacters(in: CharacterSet.whitespaces) == "" {
            return false
        }
        let soapMessage = "<?xml version='1.0' encoding='utf-8'?><soapenv:Envelope xmlns:xsi='http://www.w3.org/2001/XMLSchema-instance' xmlns:xsd='http://www.w3.org/2001/XMLSchema' xmlns:soapenv='http://schemas.xmlsoap.org/soap/envelope/' xmlns:app='https://www2.maua.br/soap/eureka/app'><soapenv:Header/><soapenv:Body><app:getUsuarioEureka soapenv:encodingStyle='http://schemas.xmlsoap.org/soap/encoding/'><token xsi:type='xsd:anyType'>\(token)</token><email xsi:type='xsd:anyType'>\(email)</email></app:getUsuarioEureka></soapenv:Body></soapenv:Envelope>"
        
        let url = URL(string: urlEUREKAWS)
        let request = NSMutableURLRequest(url: url!)
        var response: URLResponse?
        let msgLength = soapMessage.characters.count
        
        request.addValue("text/xml; charset=utf-8", forHTTPHeaderField: "Content-Type")
        request.addValue(String(msgLength), forHTTPHeaderField: "Content-Length")
        request.httpMethod = "POST"
        request.httpBody = soapMessage.data(using: String.Encoding.utf8, allowLossyConversion: false)
        
        var data: Data?
        
        do {
            data = try NSURLConnection.sendSynchronousRequest(request as URLRequest, returning: &response)
        } catch (let error) {
            print(error)
        }
        
        let xmlParser = XMLParser(data: data!)
        
        xmlParser.delegate = self
        xmlParser.parse()
        xmlParser.shouldResolveExternalEntities = true
        
        return isAutenticado
    }
    
    // MARK: - Parser
    func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String]) {
        currentElementName = elementName
    }
    
    func parser(_ parser: XMLParser, foundCharacters string: String) {
        if (currentElementName == "return" && string == "true") {
            isAutenticado = true
        }
    }
    
}
