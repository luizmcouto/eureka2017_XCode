//
//  AppDelegate.swift
//  EUREKA
//
//  Created by Roberta Neves Marchetti do Couto on 07/09/16.
//  Copyright © 2016 Instituto Mauá de Tecnologia. All rights reserved.
//

import UIKit

//--------------------------------------------------------------------------
// Struct definition
//--------------------------------------------------------------------------
struct TableVertice {
    var key: String
    var xReal: Double
    var xTela: Double
    var yReal: Double
    var yTela: Double
}

struct TableLado {
    var idVerticeOrigem: String
    var idVerticeDestino: String
    var peso: Double
}

//Filtro da busca
var trabalhos: Array<Trabalho> = Array<Trabalho>()
var filteredTrabalhos: Array<Trabalho> = Array<Trabalho>()

//Resultado do banco de dados
var RSVertice: Array<TableVertice> = Array<TableVertice>()
var RSLado: Array<TableLado> = Array<TableLado>()

//Grafo da rota
var graph: WeightedGraph<String, Double> = WeightedGraph<String, Double>()

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    var resultSetTrabalho: FMResultSet!
    var resultSetIntegrantesTrabalho: FMResultSet!

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        //vai pra tela de login se nao estiver logado e vice versa ////////////////
        self.window = UIWindow(frame: UIScreen.main.bounds)

        let preferences = UserDefaults.standard

        if(preferences.object(forKey: "email") != nil)
        {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let initialViewController = storyboard.instantiateViewController(withIdentifier: "tabprojeto")
            self.window?.rootViewController = initialViewController
            self.window?.makeKeyAndVisible()
        }
        else
        {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let initialViewController = storyboard.instantiateViewController(withIdentifier: "login")
            self.window?.rootViewController = initialViewController
            self.window?.makeKeyAndVisible()
        }
        ////////////////////////////////////////////////////////
        
        
        Utility.copyFile("EUREKA.db")
        
        if (DatabaseManager.sharedInstance.database!.open()) {
            print("Database opened!")
        }
        
        //Resultados da query de busca por trabalhos
        resultSetTrabalho = DatabaseManager.sharedInstance.database!.executeQuery("SELECT ID, NUM_TCC, ESTANDE, CURSO, TITULO, DESCRICAO, ORIENTADOR FROM TRABALHO WHERE CURSO <> 'Institucional' AND DESCRICAO != '' ORDER BY TITULO", withArgumentsIn: [])
        
        if (resultSetTrabalho != nil) {
            var id: Int32
            var numeroTCC: String
            var estande: String
            var curso: String
            var titulo: String
            var descricao: String
            var orientador: String

            while (resultSetTrabalho.next()) {
                id = resultSetTrabalho.int(forColumn: "ID")
                numeroTCC = resultSetTrabalho.string(forColumn: "NUM_TCC")!
                estande = resultSetTrabalho.string(forColumn: "ESTANDE")!
                curso = resultSetTrabalho.string(forColumn: "CURSO")!
                titulo = resultSetTrabalho.string(forColumn: "TITULO")!
                descricao = resultSetTrabalho.string(forColumn: "DESCRICAO")!
                orientador = resultSetTrabalho.string(forColumn: "ORIENTADOR")!
                
                trabalhos.append(Trabalho(id: id, numeroTCC: numeroTCC, estande: estande, curso: curso, titulo: titulo, descricao: descricao, orientador: orientador))
            }
        }
        
        //Leitura dos integrantes do grupo de TCC
        for i in 0..<trabalhos.count {
            //Resultados da query de busca por trabalhos
            resultSetIntegrantesTrabalho = DatabaseManager.sharedInstance.database!.executeQuery("SELECT NOME FROM TRABALHO INNER JOIN TRABALHO_INTEGRANTE ON TRABALHO.ID = TRABALHO_INTEGRANTE.ID_TRABALHO WHERE TRABALHO.ID = ? ORDER BY NOME", withArgumentsIn: [trabalhos[i].id])
            
            if (resultSetIntegrantesTrabalho != nil) {
                var nome: String
                
                while (resultSetIntegrantesTrabalho.next()) {
                    nome = resultSetIntegrantesTrabalho.string(forColumn: "NOME")!
                    
                    trabalhos[i].integrantesTrabalho.append(IntegranteTrabalho(nome: nome))
                }
            }
        }
        
        //Popula vértices e lados do grafo
//        let mapaWidth = (self.window?.bounds.width)!
//        let mapaHeight = (self.window?.bounds.height)! - 68 - 61
//
//        let resultSetVertice: FMResultSet! = DatabaseManager.sharedInstance.database!.executeQuery("SELECT ID, X AS X_REAL, \(mapaWidth) * X / 29.2212 AS X_TELA, Y AS Y_REAL, \(mapaHeight) - (\(mapaHeight) * Y / 71.0098) AS Y_TELA FROM VERTICE", withArgumentsIn: [])
//
//        let resultSetLado: FMResultSet! = DatabaseManager.sharedInstance.database!.executeQuery("SELECT ID, ID_VERTICE_ORIGEM, ID_VERTICE_DESTINO, PESO FROM LADO", withArgumentsIn: [])
//
//        if (resultSetVertice != nil && resultSetLado != nil) {
//            //Vértice
//            var keyVertice: String
//            var xReal: Double
//            var xTela: Double
//            var yReal: Double
//            var yTela: Double
//
//            //Lado
//            var idVerticeOrigem: String
//            var idVerticeDestino: String
//            var peso: Double
//
//            while (resultSetVertice.next()) {
//                keyVertice = resultSetVertice.string(forColumn: "ID")!
//                xReal = resultSetVertice.double(forColumn: "X_REAL")
//                xTela = resultSetVertice.double(forColumn: "X_TELA")
//                yReal = resultSetVertice.double(forColumn: "Y_REAL")
//                yTela = resultSetVertice.double(forColumn: "Y_TELA")
//
//                graph.addVertex(keyVertice)
//
//                RSVertice.append(TableVertice(key: keyVertice, xReal: xReal, xTela: xTela, yReal: yReal, yTela: yTela))
//            }
//
//            while (resultSetLado.next()) {
//                idVerticeOrigem = resultSetLado.string(forColumn: "ID_VERTICE_ORIGEM")!
//                idVerticeDestino = resultSetLado.string(forColumn: "ID_VERTICE_DESTINO")!
//                peso = resultSetLado.double(forColumn: "PESO")
//
//                graph.addEdge(from: idVerticeOrigem, to: idVerticeDestino, weight: peso)
//
//                RSLado.append(TableLado(idVerticeOrigem: idVerticeOrigem, idVerticeDestino: idVerticeDestino, peso: peso))
//            }
//        }
        
        UIApplication.shared.statusBarStyle = .lightContent
        
        return true
    }
    
    func application(_ application: UIApplication, supportedInterfaceOrientationsFor window: UIWindow?) -> UIInterfaceOrientationMask {
        return UIInterfaceOrientationMask.portrait
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        if (DatabaseManager.sharedInstance.database!.close()) {
            print("Database closed!")
        }
    }


}

