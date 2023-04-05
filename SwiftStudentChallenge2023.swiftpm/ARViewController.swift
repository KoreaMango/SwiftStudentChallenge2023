//
//  ARViewController.swift
//  SwiftStudentChallenge2023
//
//  Created by 강민규 on 2023/04/04.
//

import Foundation
import UIKit
import SceneKit
import ARKit

class ARViewController: UIViewController, ARSCNViewDelegate, ARSessionDelegate {
    //MARK: - Properties
    lazy var sceneView: ARSCNView = {
        let scene = ARSCNView()
        scene.delegate = self
        scene.session.delegate = self
        scene.showsStatistics = false
        
        return scene
    }()
    
    let configuration = ARWorldTrackingConfiguration()
    
    //MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        let jar = makeJar()
        let underJar = makeUnderJar()
        
        
        // AddView, Node
        self.view.addSubview(sceneView)
        sceneView.scene.rootNode.addChildNode(jar)
        sceneView.scene.rootNode.addChildNode(underJar)
        
        // Layout
        NSLayoutConstraint.activate([
            sceneView.topAnchor.constraint(equalTo: view.topAnchor),
            sceneView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            sceneView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            sceneView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        
        view.subviews.forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        configuration.planeDetection = .horizontal
        configuration.isLightEstimationEnabled = true
        sceneView.session.run(configuration)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
    
    //MARK: - Scene Function
    func makeJar() -> SCNNode {
        let jarNode = SCNNode()

        let outMaterial = SCNMaterial()
        let inMaterial = SCNMaterial()
        
        let jarOut = SCNTube(innerRadius: 0.08, outerRadius: 0.10, height: 0.25)
        
        outMaterial.diffuse.contents = UIImage(named: "TreeTexture")
        inMaterial.diffuse.contents = UIImage(named: "InnerTreeTexture")
        
        jarNode.geometry = jarOut
        jarNode.geometry?.materials = [outMaterial, inMaterial]
        jarNode.position = SCNVector3(0, -1, -1)
        
        return jarNode
    }
    
    func makeUnderJar() -> SCNNode {
        let underJarNode = SCNNode()
        
        let underMaterial = SCNMaterial()
        
        let jarUnder = SCNCylinder(radius: 0.08, height: 0.05)
        
        underMaterial.diffuse.contents = UIImage(named: "UnderTreeTexture")
        
        underJarNode.geometry = jarUnder
        underJarNode.geometry?.materials = [underMaterial]
        underJarNode.position = SCNVector3(0, -1.05, -1)
        
        return underJarNode
    }
}

