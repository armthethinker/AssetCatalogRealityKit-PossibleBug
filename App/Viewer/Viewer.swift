//
//  Viewer.swift
//
//  Created by Andrew McHugh on 10/27/21.
//

import SwiftUI
import ARKit
import RealityKit

struct Viewer: View {
    
    @State var nonARGroundMaterial: ViewerMaterials.AvailableAssets = .woodFolder
    
    var body: some View {
        ZStack{
            Color(.gray)
                .ignoresSafeArea()
            #if !targetEnvironment(simulator)
            ViewerScene(
                nonARGroundMaterial: nonARGroundMaterial
            )
                .ignoresSafeArea()
                .preferredColorScheme(.dark)
            #endif
            ZStack{
                VStack{
                    Spacer()
                    Rectangle()
                        .fill(
                            LinearGradient(colors: [Color("GradientStart"), Color("GradientEnd")], startPoint: .bottom, endPoint: .top)
                        )
                        .ignoresSafeArea(.container, edges: .bottom)
                        .frame(maxHeight: 300)
                }
                VStack{
                    Spacer()
                    Button {
                        nonARGroundMaterial = .woodFolder
                    } label: {
                        Text("Use PBR material from folder")
                    }
                    Button {
                        nonARGroundMaterial = .woodAssetCatalog
                    } label: {
                        Text("Use PBR material from asset catalog")
                    }
                }
                .buttonStyle(.bordered)
                .padding(.bottom)
            }
            
        }
    }
}

struct Viewer_Previews: PreviewProvider {
    static var previews: some View {
        Viewer()
    }
}
