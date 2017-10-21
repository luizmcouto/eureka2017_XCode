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

class MapaView: UIView {
    
    //Primeiro vértice
    var firstVertex = true
    
    //Vértices de origem e destino
    var idVerticeOrigem: String!
    var idVerticeDestino: String!
    
    //Vértices do melhor caminho
    var stops: [String]!
    var nameDistance: [String: Double?]!
    
    //Pontos de interesse
    //var pontosInteresse: Array<Vertex> = Array<Vertex>()

    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        if (idVerticeOrigem != nil && idVerticeDestino != nil) {
            let totalDistance = nameDistance[idVerticeDestino]!
            
            //Move para o destino
            if (totalDistance! > 0.0) {
                let pathDrawing: UIBezierPath = UIBezierPath()
                
                //Desenha rota
                for stop in stops {
                    if let i = RSVertice.index(where: {$0.key == stop}) {
                        desenhaRota(pathDrawing, vertex: RSVertice[i])
                    }
                }
                
                let shapeLayer = CAShapeLayer()
                
                shapeLayer.lineWidth = 3.5
                shapeLayer.strokeColor = UIColor.white.cgColor
                shapeLayer.fillColor = UIColor.clear.cgColor
                
                // This is the path that's visible when there'd be no animation.
                shapeLayer.path = pathDrawing.cgPath
                
                self.layer.addSublayer(shapeLayer)

                //Desenha ponto de origem
                if let i = RSVertice.index(where: {$0.key == stops[0]}) {
                    desenhaPontoInteresse(RSVertice[i].xTela, y: RSVertice[i].yTela, color: UIColor.green.cgColor)

                    animaPontoInteresse(RSVertice[i].xTela, y: RSVertice[i].yTela, color: UIColor.green.cgColor)
                }

                //Desenha ponto de origem
                if let i = RSVertice.index(where: {$0.key == stops[stops.count - 1]}) {
                    desenhaPontoInteresse(RSVertice[i].xTela, y: RSVertice[i].yTela, color: UIColor.red.cgColor)
                }
            }
        }
    }
    
    func desenhaRota(_ pathDrawing: UIBezierPath, vertex: TableVertice) {
        if (firstVertex) {
            firstVertex = false
            
            pathDrawing.move(to: CGPoint(x: vertex.xTela, y: vertex.yTela))
        } else {
            pathDrawing.addLine(to: CGPoint(x: vertex.xTela, y: vertex.yTela))
        }
    }
    
    func desenhaPontoInteresse(_ x: Double, y: Double, color: CGColor) {
        let rect = CGRect(x: x - 5, y: y - 5, width: 10, height: 10);
        let path = UIBezierPath(ovalIn: rect)

        let shapeLayer = CAShapeLayer()
        
        shapeLayer.strokeColor = color
        shapeLayer.fillColor = color
        shapeLayer.path = path.cgPath
        
        self.layer.addSublayer(shapeLayer)
        
        //Cria botão para ponto de interesse
        let button = UIButton(type: UIButtonType.system)
        
        button.frame = rect
        //button.backgroundColor = UIColor.brown
        
        self.addSubview(button)
    }

    func animaPontoInteresse(_ x: Double, y: Double, color: CGColor) {
        // The circle/oval in its largest size.
        var rect1: CGRect
        var rect2: CGRect
        
        var path1: UIBezierPath
        var path2: UIBezierPath
        
        let shapeLayer = CAShapeLayer()
        
        var group: CAAnimationGroup
        var pathAnimation: CABasicAnimation
        var alphaAnimation: CABasicAnimation
        
        rect1 = CGRect(x: x - 15, y: y - 15, width: 30, height: 30);
        path1 = UIBezierPath(ovalIn: rect1)
        
        // Shrink it down to a 2x2 circle.
        rect2 = rect1.insetBy(dx: (rect1.size.width / 2) - 1, dy: (rect1.size.height / 2) - 1)
        path2 = UIBezierPath(ovalIn: rect2)
        
        // Configure the layer.
        shapeLayer.lineWidth = 2.0
        shapeLayer.strokeColor = color
        shapeLayer.fillColor = UIColor.clear.cgColor
        
        // This is the path that's visible when there'd be no animation.
        shapeLayer.path = path1.cgPath
        
        self.layer.addSublayer(shapeLayer)
        
        // Animate the path.
        pathAnimation = CABasicAnimation(keyPath: "path")
        pathAnimation.fromValue = path2.cgPath
        pathAnimation.toValue = path1.cgPath
        
        // Animate the alpha value.
        alphaAnimation = CABasicAnimation(keyPath: "opacity")
        alphaAnimation.fromValue = 1
        alphaAnimation.toValue = 0
        
        // We want both animations to run together perfectly, so we
        // put them into an animation group.
        group = CAAnimationGroup()
        group.animations = [ pathAnimation, alphaAnimation ];
        group.duration = 1;
        group.repeatCount = FLT_MAX;
        
        // Add the animation to the layer.
        shapeLayer.add(group, forKey:"sonar")
    }

}
