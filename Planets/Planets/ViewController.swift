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
        let sun = SCNNode(geometry: SCNSphere(radius: 0.35))
        sun.geometry?.firstMaterial?.diffuse.contents = #imageLiteral(resourceName: "SunDiffuse")
        
        let earthParent = SCNNode()
        let venusParent = SCNNode()
        let moonParent = SCNNode()
        
        // set parent node positions
        sun.position = SCNVector3(0,0,-1)
        earthParent.position = SCNVector3(0,0,-1)
        venusParent.position = SCNVector3(0,0,-1)
        moonParent.position = SCNVector3(1.2,0,0)
        
        // setup planets and moons
        let earth = makePlanet(geometry: SCNSphere(radius: 0.2), diffuse: #imageLiteral(resourceName: "Earthday"), specular: #imageLiteral(resourceName: "EarthSpecular"), emission: #imageLiteral(resourceName: "EarthEmission"), normal: #imageLiteral(resourceName: "EarthNormal"), position: SCNVector3(1.2,0,0))
        let venus = makePlanet(geometry: SCNSphere(radius: 0.1), diffuse: #imageLiteral(resourceName: "VenusSurface"), specular: nil, emission: #imageLiteral(resourceName: "VenusAtmosphere"), normal: nil, position: SCNVector3(0.7,0,0))
        let earthMoon = makePlanet(geometry: SCNSphere(radius: 0.05), diffuse: #imageLiteral(resourceName: "MoonDiffuse"), specular: nil, emission: nil, normal: nil, position: SCNVector3(0,0,-0.3))
        
        // setup rotation animations
        let sunRotation = addRotation(time: 8)
        let earthParentRotation = addRotation(time: 14)
        let venusParentRotation = addRotation(time: 10)
        let earthRotation = addRotation(time: 8)
        let moonRotation = addRotation(time: 5)
        let venusRotation = addRotation(time: 8)
        
        sun.runAction(sunRotation)
        earthParent.runAction(earthParentRotation)
        venusParent.runAction(venusParentRotation)
        moonParent.runAction(moonRotation)
        earth.runAction(earthRotation)
        venus.runAction(venusRotation)
        
        // set parent child relationships
        moonParent.addChildNode(earthMoon)
        
        earthParent.addChildNode(earth)
        earthParent.addChildNode(moonParent)
        venusParent.addChildNode(venus)
        
        // add root nodes to the scene
        sceneView.scene.rootNode.addChildNode(sun)
        sceneView.scene.rootNode.addChildNode(earthParent)
        sceneView.scene.rootNode.addChildNode(venusParent)
        
        
    }
    
    func makePlanet(geometry: SCNGeometry, diffuse: UIImage, specular: UIImage?, emission: UIImage?, normal: UIImage?, position: SCNVector3) -> SCNNode {
        let planet = SCNNode(geometry: geometry)
        planet.geometry?.firstMaterial?.diffuse.contents = diffuse
        planet.geometry?.firstMaterial?.specular.contents = specular // how light reflects
        planet.geometry?.firstMaterial?.emission.contents = emission
        planet.geometry?.firstMaterial?.normal.contents = normal
        planet.position = position
        return planet
    }
    
    func addRotation(time: TimeInterval) -> SCNAction {
        let rotation = SCNAction.rotateBy(x: 0, y: CGFloat(360.degreesToRadians), z: 0, duration: time)
        let foreverRotation = SCNAction.repeatForever(rotation)
        return foreverRotation
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

extension Int {
    var degreesToRadians: Double { return Double(self) * .pi/180}
}

