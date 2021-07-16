//
//  ViewController.swift
//  Hello World 2
//
//  Created by Yunlong.Adi on 14.07.21.
//
//

import UIKit
import SceneKit
import ARKit

class ViewController: UIViewController, ARSCNViewDelegate {

    @IBOutlet var sceneView: ARSCNView!
//    create label variable
    private let label: UILabel = UILabel()


    override func viewDidLoad() {
        super.viewDidLoad()
//    CODE FOR LABEL
        self.sceneView = ARSCNView(frame: self.view.frame)
        self.label.frame = CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: 44)
        self.label.center = self.sceneView.center
        self.label.textAlignment = .center
        self.label.textColor = UIColor.white
        self.label.font = UIFont.preferredFont(forTextStyle: .headline)
        self.label.alpha = 0

        //        Adding the label to the main view
        self.sceneView.addSubview(self.label)

        //***        DEBUG OPTIONS ***
        self.sceneView.debugOptions = [ARSCNDebugOptions.showFeaturePoints, ARSCNDebugOptions.showWireframe, ARSCNDebugOptions.showWorldOrigin]

        // Show statistics such as fps and timing information
        //        sceneView.showsStatistics = true

        //    connect label to sceneview
        self.sceneView.addSubview(self.sceneView)

        // Set the view's delegate
        sceneView.delegate = self

        // Create a new scene
        let scene = SCNScene()

        // Set the scene to the view
        sceneView.scene = scene
        let boxvar = SCNBox(width: 0.3, height: 0.3, length: 0.3, chamferRadius: 0)

        //        diplsyaing text in VR / ExctrusionDepth assign Depth to Text
        let textVar = SCNText(string: "Theraeasy GmbH - Maria Kauffmann, Robert Freitag", extrusionDepth: 1.0)


        //crete material to wrap around the OBJECT
        let material = SCNMaterial()
        material.name = "Color"
        //        Color || Image : the dressing of the OBJECT
        //    Diffuse.content = how the light is going to reflect when the OBJECT is being viewd in real world enviroment
        //    UIColor.red = red Object Skin
        material.diffuse.contents = UIColor.red

        //        we use (firstMaterial) because we are using it over a text with no sides otherwise to a cube where we used (materials)
        textVar.firstMaterial?.diffuse.contents = UIColor.black

        //assigning the Skin color to the sides of the OBJECT
        //    boxvar is the wireframe geometry OBJECT and with materials the entire OBJECT will have the UIColor.red
        boxvar.materials = [material]

        // To create a Scene in SceneKit we need to create a SCNNode
        //SCNNode can take geomatry and we will call our variable that is holding an object as a value
        let boxvarNODE = SCNNode(geometry: boxvar)
        boxvarNODE.position = SCNVector3(0, 0, -0.5)

        self.sceneView.scene.rootNode.addChildNode(boxvarNODE)

        //        calling the text in  a geometry object
        let textVarNode = SCNNode(geometry: textVar)

        //        setting a position in the real world for the geometry object
        textVarNode.position = SCNVector3(0, 0, -0.5)

        //    text by default will show too big, so we need to scale it
        textVarNode.scale = SCNVector3(0.02, 0.02, 0.02)

        //Calling the object node in the rel world
        sceneView.scene.rootNode.addChildNode(textVarNode)

        //         creating two new fun object
        let blueBall = SCNSphere(radius: 0.4)
        let pinkBall = SCNSphere(radius: 0.5)

        //        creating material for both of the fun objects
        blueBall.firstMaterial?.diffuse.contents = UIImage(named: "art.scnassets/earth.jpg")
        pinkBall.firstMaterial?.diffuse.contents = UIImage(named: "art.scnassets/wood.jpeg")

        //        placing blue ball in a node
        let blueballNode = SCNNode(geometry: blueBall)
        let pinkballNode = SCNNode(geometry: pinkBall)

        //positioning our fun objects
        blueballNode.position = SCNVector3(0, 1, -1)
        pinkballNode.position = SCNVector3(0, -1, -1)

        //        displaying the object in real world using delegate and sceneview
        self.sceneView.scene.rootNode.addChildNode(blueballNode)
        self.sceneView.scene.rootNode.addChildNode(pinkballNode)

        //        implementing a touch action, create a variable and add UITapGestureRecognizer to
        //        it with target and a selector for the action name
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(tappedOnObject))

        //        adding tap gesture to the sceneView
        self.sceneView.addGestureRecognizer(tapGestureRecognizer)
    }

    //        create a an objective C function same name  as selector  and inside store  the UIGestureRecognizer as a parameter
    @objc func tappedOnObject(recognizer: UIGestureRecognizer) {
        //casting recognizer in sceneView to take effect in the real world
        let realWorldsceneView = recognizer.view as! SCNView
        //         let recognizer get the location of the hit
        let touchedOnObject = recognizer.location(in: realWorldsceneView)

        //        when getting the touch location, we run a hit test **RELATED TO AR WORLD**
        let HitTest = realWorldsceneView.hitTest(touchedOnObject, options: [:])

        //        if hitTest is not empty
        if !HitTest.isEmpty {
            let objNode = HitTest[0].node
            let objMaterial = objNode.geometry?.material(named: "Color")

            objMaterial?.diffuse.contents = UIColor.random()
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        // Create a session configuration
        let configuration = ARWorldTrackingConfiguration()
        //        Detecting Horizontal Planes and Vertical PLanes
        configuration.planeDetection = .horizontal
        configuration.planeDetection = .vertical

        // Run the view's session
        sceneView.session.run(configuration)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        // Pause the view's session
        sceneView.session.pause()
    }

    // MARK: - ARSCNViewDelegate
//    func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor) {
//        DispatchQueue.main.async {
//            self.label.text = "THERAEASY - HOLOGRAB"
//
//            UIView.animate(withDuration: 1.0, animations: {
//                self.label.alpha = 1.0
//            }) { (completion: Bool) in
//                self.label.alpha = 0.0
//            }
//        }
//    }

/*
    // Override to create and configure nodes for anchors added to the view's session.
    func renderer(_ renderer: SCNSceneRenderer, nodeFor anchor: ARAnchor) -> SCNNode? {
        let node = SCNNode()

        return node TODO
    }
*/

//    func session(_ session: ARSession, didFailWithError error: Error) {
//        // Present an error message to the user
//
//    }
//
//    func sessionWasInterrupted(_ session: ARSession) {
//        // Inform the user that the session has been interrupted, for example, by presenting an overlay
//
//    }
//
//    func sessionInterruptionEnded(_ session: ARSession) {
//        // Reset tracking and/or remove existing anchors if consistent tracking is required
//
//    }
}
