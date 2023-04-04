//
//  ARViewController.swift
//  SwiftStudentChallenge2023
//
//  Created by 강민규 on 2023/04/04.
//

import UIKit
import SceneKit
import ARKit

class ARViewController: UIViewController, ARSCNViewDelegate, ARSessionDelegate {
    //MARK: - Properties
    let testView: UIView = {
       let view = UIView()
        view.backgroundColor = .red
        return view
    }()
    
    //MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.addSubview(testView)
        
        NSLayoutConstraint.activate([
            testView.topAnchor.constraint(equalTo: view.topAnchor),
            testView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            testView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            testView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        
        view.subviews.forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
    
    //MARK: - Scene Function
    
}

