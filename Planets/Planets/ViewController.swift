//
//  ViewController.swift
//  Planets
//
//  Created by Macbook on 11/22/17.
//  Copyright © 2017 Macbook. All rights reserved.
//

import UIKit
import ARKit

class ViewController: UIViewController {

    @IBOutlet weak var sceneView: ARSCNView!
    let configuration = ARWorldTrackingConfiguration()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        sceneView.debugOptions = [ARSCNDebugOptions.showFeaturePoints, ARSCNDebugOptions.showWorldOrigin]
        sceneView.session.run(configuration)
        sceneView.autoenablesDefaultLighting = true // adds an omni light
    }
    
    override func viewDidAppear(_ animated: Bool) {
        let earth = SCNNode(geometry: SCNSphere(radius: 0.2))
        earth.geometry?.firstMaterial?.diffuse.contents = #imageLiteral(resourceName: "Earthday")
        earth.geometry?.firstMaterial?.specular.contents = #imageLiteral(resourceName: "EarthSpecular") // how light reflects
        earth.geometry?.firstMaterial?.emission.contents = #imageLiteral(resourceName: "EarthEmission")
        earth.geometry?.firstMaterial?.normal.contents = #imageLiteral(resourceName: "EarthNormal")
        earth.position = SCNVector3(0,0,-1)
        sceneView.scene.rootNode.addChildNode(earth)
        
        let action = SCNAction.rotateBy(x: 0, y: CGFloat(360.degreesToRadians), z: 0, duration: 8)
        let forever = SCNAction.repeatForever(action)
        earth.runAction(forever)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

extension Int {
    var degreesToRadians: Double { return Double(self) * .pi/180}
}

