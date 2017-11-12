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
        let doorNode = SCNNode(geometry: SCNPlane(width: 0.03, height: 0.06))
        doorNode.geometry?.firstMaterial?.diffuse.contents = UIColor.brown
        
        let boxNode = SCNNode(geometry: SCNBox(width: 0.1, height: 0.1, length: 0.1, chamferRadius: 0))
        boxNode.geometry?.firstMaterial?.diffuse.contents = UIColor.blue
        
        let node = SCNNode() // a node is a position in space (no size or shape)

        // add geometry to scene
//        node.geometry = SCNBox(width: 0.1, height: 0.1, length: 0.1, chamferRadius: 0.1/2) // add a sphere using a box geometry
//        node.geometry = SCNBox(width: 0.1, height: 0.1, length: 0.1, chamferRadius: 0) // add a box to the node (0.1m on all sides)
//        node.geometry = SCNBox(width: 0.1, height: 0.1, length: 0.1, chamferRadius: 0.03) // add a box with rounded corners
//        node.geometry = SCNCapsule(capRadius: 0.1, height: 0.3) // add a capsule
//        node.geometry = SCNCone(topRadius: 0.1, bottomRadius: 0.3, height: 0.3) // add a cone
//        node.geometry = SCNCone(topRadius: 0.1, bottomRadius: 0.1, height: 0.1) // add a cylinder using cone geometry
//        node.geometry = SCNCylinder(radius: 0.2, height: 0.2) // add a cylinder
//        node.geometry = SCNSphere(radius: 0.1) // add a sphere
//        node.geometry = SCNTube(innerRadius: 0.2, outerRadius: 0.3, height: 0.5) // add a tube
//        node.geometry = SCNTorus(ringRadius: 0.3, pipeRadius: 0.1) // add a torus - make sure pipe is smaller than ring
//        node.geometry = SCNPlane(width: 0.2, height: 0.2) // add a plane
//        node.geometry = SCNPyramid(width: 0.1, height: 0.1, length: 0.1) // add a pyramid
        
        // add custom shape
//        let path = UIBezierPath() // init path
//        path.move(to: CGPoint(x: 0, y: 0)) // set path origin
//        path.addLine(to: CGPoint(x:0, y:0.2)) // add a line to the given point
//        path.addLine(to: CGPoint(x: 0.2, y: 0.3))
//        path.addLine(to: CGPoint(x: 0.4, y: 0.2))
//        path.addLine(to: CGPoint(x: 0.4, y: 0))
//        let shape = SCNShape(path: path, extrusionDepth: 0.2) // create shape from path, give extrusion depth
//        node.geometry = shape // add shape to node
        
        node.geometry = SCNPyramid(width: 0.1, height: 0.1, length: 0.1) // add a pyramid
        
        node.geometry?.firstMaterial?.specular.contents = UIColor.orange // specular describes color of light that reflects from surface
        node.geometry?.firstMaterial?.diffuse.contents = UIColor.red // set the box to blue
        
        node.position = SCNVector3(0,0,-0.7) // set the position at location
        boxNode.position = SCNVector3(0, -0.05, 0) // set position relative to pyramid
        doorNode.position = SCNVector3(0,-0.02,0.053)
        
        boxNode.addChildNode(doorNode) // add door as child to box
        node.addChildNode(boxNode) // add box as a child of pyramid
        
        
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

