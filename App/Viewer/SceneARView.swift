//
//  SceneARView.swift
//   
//
//  Created by Andrew McHugh on 12/3/21.
//

import Foundation
import ARKit
import RealityKit
import SwiftUI

/// Sets up the ARView ... nothing special here.
class SceneARView : ARView {
    
    let config = ARPositionalTrackingConfiguration()
    
    init(cameraMode: ARView.CameraMode){
        
        super.init(frame: .zero)
        
        self.frame = .zero
        self.automaticallyConfigureSession = false
        self.cameraMode = cameraMode
        
        self.environment.sceneUnderstanding.options.remove(.occlusion)
        
        self.renderOptions.insert(.disableGroundingShadows)
        self.renderOptions.insert(.disableAREnvironmentLighting)
        
    }
    
    @MainActor @objc required dynamic init?(coder decoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @MainActor @objc required dynamic init(frame frameRect: CGRect) {
        fatalError("init(frame:) has not been implemented")
    }

}
