//
//  Trabalho.swift
//  EUREKA
//
//  Created by Roberta Neves Marchetti do Couto on 11/09/16.
//  Copyright © 2016 Instituto Mauá de Tecnologia. All rights reserved.
//

import Foundation

struct Trabalho {
    var id: Int32
    var numeroTCC: String
    var estande: String
    var curso: String
    var titulo: String
    var descricao: String
    var orientador: String
    var integrantesTrabalho: Array<IntegranteTrabalho> = Array<IntegranteTrabalho>()
    
    init(id: Int32, numeroTCC: String, estande: String, curso: String, titulo: String, descricao: String, orientador: String) {
        self.id = id
        self.numeroTCC = numeroTCC
        self.estande = estande
        self.curso = curso
        self.titulo = titulo
        self.descricao = descricao
        self.orientador = orientador
    }
}
