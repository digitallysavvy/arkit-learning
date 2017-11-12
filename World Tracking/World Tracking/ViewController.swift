//
//  ViewController.swift
//  World Tracking
//
//  Created by Macbook on 11/12/17.
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
        
        // setup debug options for scene
        // shows if feature points are being descovered and if world origin is properly set
        self.sceneView.debugOptions = [ARSCNDebugOptions.showFeaturePoints, ARSCNDebugOptions.showWorldOrigin]
        self.sceneView.autoenablesDefaultLighting = true // adds default (omni directional) light source to the scene
        
        self.sceneView.session.run(configuration) // run session config
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // action for Add button within UIview
    @IBAction func addObject(_ sender: Any) {
        let node = SCNNode() // a node is a position in space (no size or shape)

//        node.geometry = SCNBox(width: 0.1, height: 0.1, length: 0.1, chamferRadius: 0) // add a box to the node (0.1m on all sides)
//        node.geometry = SCNBox(width: 0.1, height: 0.1, length: 0.1, chamferRadius: 0.1/2) // add a sphere
       
        node.geometry = SCNBox(width: 0.1, height: 0.1, length: 0.1, chamferRadius: 0.03) // add a box with rounded corners
        node.geometry?.firstMaterial?.specular.contents = UIColor.orange // specular describes color of light that reflects from surface
        node.geometry?.firstMaterial?.diffuse.contents = UIColor.blue // set the box to blue
        
        // randomly generate locations
        let x = randomNumbers(firstNum: -0.3, secondNum: 0.3)
        let y = randomNumbers(firstNum: -0.3, secondNum: 0.3)
        let z = randomNumbers(firstNum: -0.3, secondNum: 0.3)
        
        node.position = SCNVector3(x,y,z) // set the position at random location
        self.sceneView.scene.rootNode.addChildNode(node) // add the newly created node to the scene
    }
    
    // action for the Reset button within the UIview
    @IBAction func resetBtnAction(_ sender: Any) {
        self.restartSession() //
    }
    
    func restartSession() {
        self.sceneView.session.pause() // pause the scene view session - stops keeping track of position/orientation
        // remove the box node from the scene
        self.sceneView.scene.rootNode.enumerateChildNodes { (child, _) in
            child.removeFromParentNode()
        }
        self.sceneView.session.run(configuration, options: [.resetTracking, .removeExistingAnchors])// restart the tracking session, remove anchors
    }
    
    func randomNumbers(firstNum: CGFloat, secondNum: CGFloat) -> CGFloat {
        return CGFloat(arc4random()) / CGFloat(UINT32_MAX) * abs(firstNum - secondNum) + min(firstNum,secondNum)
    }
    
    
}

