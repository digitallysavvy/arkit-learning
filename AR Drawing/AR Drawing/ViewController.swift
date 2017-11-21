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
    
    @IBOutlet weak var paletteBtn: UIButton!
    @IBOutlet weak var blackColorBtn: UIButton!
    @IBOutlet weak var redColorBtn: UIButton!
    @IBOutlet weak var blueColorBtn: UIButton!
    @IBOutlet weak var whiteColorBtn: UIButton!
    
    var whiteColorBtnCenter : CGPoint = CGPoint()
    var blackColorBtnCenter : CGPoint = CGPoint()
    var redColorBtnCenter : CGPoint = CGPoint()
    var blueColorBtnCenter : CGPoint = CGPoint()
    
    var activeColorBtn : UIButton = UIButton()
    var activePaintColor : UIColor = UIColor()
    
    var allBtns : [UIButton] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.sceneView.debugOptions = [ARSCNDebugOptions.showWorldOrigin , ARSCNDebugOptions.showFeaturePoints]
        self.sceneView.showsStatistics = true
        self.sceneView.session.run(configuration)
        self.sceneView.delegate = self
        
        // place buttons
        whiteColorBtnCenter = whiteColorBtn.center
        blackColorBtnCenter = blackColorBtn.center
        redColorBtnCenter = redColorBtn.center
        blueColorBtnCenter = blueColorBtn.center
        
        whiteColorBtn.center  = paletteBtn.center
        blackColorBtn.center  = paletteBtn.center
        redColorBtn.center  = paletteBtn.center
        blueColorBtn.center  = paletteBtn.center
        
        whiteColorBtn.alpha = 0
        blackColorBtn.alpha = 0
        redColorBtn.alpha = 0
        blueColorBtn.alpha = 0
        
        activePaintColor = UIColor.white
        activeColorBtn = whiteColorBtn
        
        toggleButton(button: whiteColorBtn, onImage: #imageLiteral(resourceName: "paint-color-white-selected"), offImage: #imageLiteral(resourceName: "paint-color-white"))
        
        allBtns = [whiteColorBtn, blackColorBtn, redColorBtn, blueColorBtn]
        
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
                sphereNode.geometry?.firstMaterial?.diffuse.contents = self.activePaintColor
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
    
    @IBAction func paletteBtnTapped(_ sender: UIButton) {
        togglePalett(paletteBtn: sender)
    }
    
    @IBAction func brushTapped(_ sender: Any) {
        if paletteBtn.currentImage == #imageLiteral(resourceName: "color-palette-enabled") {
            togglePalett(paletteBtn: paletteBtn)
        }
    }
    
    @IBAction func setColor(_ sender: UIButton) {
        var stateImgs = getStateImages(btn: sender)
        var newActiveColor : UIColor
        
        toggleActiveColor(activeColorButton: activeColorBtn) // toggle active btn back to inactive state
        
        switch sender {
        case whiteColorBtn:
            newActiveColor = UIColor.white
        case blackColorBtn:
            newActiveColor = UIColor.black
        case redColorBtn:
            newActiveColor = UIColor.red
        case blueColorBtn:
            newActiveColor = UIColor.blue
        default:
            print("setColor: unable to determine sender")
            return
        }
        
        activePaintColor = newActiveColor
        activeColorBtn = sender
        toggleButton(button: sender, onImage: stateImgs[0], offImage: stateImgs[1])
    }
    
    func togglePalett(paletteBtn: UIButton) -> Void {
        if paletteBtn.currentImage == #imageLiteral(resourceName: "color-palette-disabled") {
            UIView.animate(withDuration: 0.3, animations: {
                self.whiteColorBtn.center = self.whiteColorBtnCenter
                self.blackColorBtn.center = self.blackColorBtnCenter
                self.redColorBtn.center = self.redColorBtnCenter
                self.blueColorBtn.center = self.blueColorBtnCenter
                
                self.whiteColorBtn.alpha = 1
                self.blackColorBtn.alpha = 1
                self.redColorBtn.alpha = 1
                self.blueColorBtn.alpha = 1
            })
        } else {
            UIView.animate(withDuration: 0.3, animations: {
                self.whiteColorBtn.center  = self.paletteBtn.center
                self.blackColorBtn.center  = self.paletteBtn.center
                self.redColorBtn.center  = self.paletteBtn.center
                self.blueColorBtn.center  = self.paletteBtn.center
                
                self.whiteColorBtn.alpha = 0
                self.blackColorBtn.alpha = 0
                self.redColorBtn.alpha = 0
                self.blueColorBtn.alpha = 0
            })
        }
        
        toggleButton(button: paletteBtn, onImage: #imageLiteral(resourceName: "color-palette-enabled"), offImage: #imageLiteral(resourceName: "color-palette-disabled"))
    }
    
    
    func toggleActiveColor(activeColorButton: UIButton) {
        var stateImgs = getStateImages(btn: activeColorButton)
        toggleButton(button: activeColorButton, onImage: stateImgs[0], offImage: stateImgs[1])
    }
    
    func getStateImages(btn: UIButton) -> [UIImage] {
        var enabledStateImg : UIImage
        var disabledStateImg : UIImage
        
        switch btn {
        case whiteColorBtn:
            enabledStateImg = #imageLiteral(resourceName: "paint-color-white-selected")
            disabledStateImg = #imageLiteral(resourceName: "paint-color-white")
        case blackColorBtn:
            enabledStateImg = #imageLiteral(resourceName: "paint-color-black-selected")
            disabledStateImg = #imageLiteral(resourceName: "paint-color-black")
        case redColorBtn:
            enabledStateImg = #imageLiteral(resourceName: "paint-color-red-selected")
            disabledStateImg = #imageLiteral(resourceName: "paint-color-red")
        case blueColorBtn:
            enabledStateImg = #imageLiteral(resourceName: "paint-color-blue-selected")
            disabledStateImg = #imageLiteral(resourceName: "paint-color-blue")
        default:
            print("getStateImages: unable to determine btn")
            return []
        }
        return [enabledStateImg, disabledStateImg]
    }
    
    
    func toggleButton(button: UIButton, onImage: UIImage, offImage: UIImage) -> Void {
        if button.currentImage == offImage {
            button.setImage(onImage, for: .normal)
        } else {
            button.setImage(offImage, for: .normal)
        }
    }
    


}

func + (left: SCNVector3, right: SCNVector3) -> SCNVector3 {
    
    return SCNVector3Make(left.x + right.x, left.y + right.y, left.z + right.z)
}
