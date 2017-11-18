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
        print("rendering")
        // get camera translation and rotation
        guard let pointOfView = sceneView.pointOfView else { return }
        let transform = pointOfView.transform // transformation matrix
        let orientation = SCNVector3(-transform.m31, -transform.m32, -transform.m33) // camera rotation
        let location = SCNVector3(transform.m41, transform.m42, transform.m43) // camera translation
        
        let currentPostion = orientation + location
        print(orientation.x, orientation.y, orientation.z)
    }


}

func + (left: SCNVector3, right: SCNVector3) -> SCNVector3 {
    
    return SCNVector3Make(left.x + right.x, left.y + right.y, left.z + right.z)
}
