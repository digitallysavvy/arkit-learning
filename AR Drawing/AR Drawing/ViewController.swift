//
//  ViewController.swift
//  AR Drawing
//
//  Created by Macbook on 11/15/17.
//  Copyright © 2017 Macbook. All rights reserved.
//

import UIKit
import ARKit

class ViewController: UIViewController, ARSCNViewDelegate {

    @IBOutlet weak var sceneView: ARSCNView!
    let configuration = ARWorldTrackingConfiguration()
    @IBOutlet weak var drawBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.sceneView.debugOptions = [ARSCNDebugOptions.showWorldOrigin , ARSCNDebugOptions.showFeaturePoints]
        self.sceneView.showsStatistics = true
        self.sceneView.session.run(configuration)
        self.sceneView.delegate = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func renderer(_ renderer: SCNSceneRenderer, willRenderScene scene: SCNScene, atTime time: TimeInterval) {
        // get camera translation and rotation
        guard let pointOfView = sceneView.pointOfView else { return }
        let transform = pointOfView.transform // transformation matrix
        let orientation = SCNVector3(-transform.m31, -transform.m32, -transform.m33) // camera rotation
        let location = SCNVector3(transform.m41, transform.m42, transform.m43) // camera translation
        
        let currentPostionOfCamera = orientation + location
        DispatchQueue.main.async {
            if self.drawBtn.isHighlighted {
                let sphereNode = SCNNode(geometry: SCNSphere(radius: 0.02))
                sphereNode.position = currentPostionOfCamera
                self.sceneView.scene.rootNode.addChildNode(sphereNode)
                sphereNode.geometry?.firstMaterial?.diffuse.contents = UIColor.blue
            } else {
                let brushPointer : SCNNode = SCNNode(geometry: SCNSphere(radius: 0.01))
                brushPointer.position = currentPostionOfCamera // give the user a visual cue of brush position
                brushPointer.name = "brushPointer" // set name to differentiate
                self.sceneView.scene.rootNode.enumerateChildNodes({ (node, _) in
                    if node.name == "brushPointer" {
                        node.removeFromParentNode() // only remove bursh pointer
                    }
                })
                
                self.sceneView.scene.rootNode.addChildNode(brushPointer)
                brushPointer.geometry?.firstMaterial?.diffuse.contents = UIColor.lightGray
            }
        }
    }


}

func + (left: SCNVector3, right: SCNVector3) -> SCNVector3 {
    
    return SCNVector3Make(left.x + right.x, left.y + right.y, left.z + right.z)
}
